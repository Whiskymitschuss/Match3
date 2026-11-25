extends RefCounted
const C=preload('res://scripts/progression/collection.gd')
const Art=preload('res://scripts/ui/gear_art.gd')
var game:Node2D
var hero=0
var slot='weapon'
var page=0
var busy=false
var error=''
var save_path=''
const SLOT_NAMES={'weapon':'WAFFEN','head':'KOPF','body':'KÖRPER','feet':'SCHUHE','item':'ITEMS','spell':'ZAUBER','skin':'WAFFEN-SKINS','deco':'DEKO'}
func _init(g:Node2D):game=g
func enter() -> bool:
	if game.state in [game.State.COMBAT,game.State.PAUSED,game.State.LEVEL_UP,game.State.SHOP,game.State.WAVE_PREPARATION]:return false
	game.change_state(game.State.CHARACTER_SELECT);return true
func text(value:String,at:Vector2,width:float,font:int=26,color:Color=Color.WHITE) -> Label:
	var node=game.label_at(value,at,font,color);node.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;node.set_deferred('size',Vector2(width,160));return node
func image_item(id:String,rect:Rect2):
	if C.catalog().items[id].slot=='skin':
		var preview=Control.new();preview.set_script(preload('res://scripts/ui/skin_preview.gd'));preview.position=rect.position;preview.size=rect.size;preview.weapon=game.saved.collection.loadouts[game.characters[hero].id].weapon;preview.finish=id;game.ui_root.add_child(preview)
	elif C.catalog().items[id].slot=='weapon':game.weapon_icon(id,rect.position,rect.size)
	else:game.UISkin.image(game,Art.icon(id),rect)
func transact(kind:String,id:String='',serial:int=-1) -> bool:
	if busy or not enter():return false
	var before=game.saved.duplicate(true);var ok=false
	match kind:
		'open':ok=not C.open_case(game.saved,id).is_empty()
		'ack':ok=C.acknowledge(game.saved,serial)
		'upgrade':ok=C.upgrade(game.saved,id)
		'skin_buy':
			var d=C.catalog().items.get(id,{})
			if d.get('slot','')=='skin' and not game.saved.collection.levels.has(id) and game.saved.meta.coins>=int(d.get('price',300)):
				game.saved.meta.coins-=int(d.get('price',300));game.saved.collection.levels[id]=1;ok=true
		'equip':ok=C.equip(game.saved,game.characters[hero].id,id)
		'off':
			if slot!='weapon' and game.saved.collection.heroes.has(game.characters[hero].id):
				if slot=='deco':game.saved.meta.equipped={'ring':'','buddy':'','title':''}
				else:game.saved.collection.loadouts[game.characters[hero].id][slot]=''
				ok=true
	if not ok:return false
	if game.SaveManager.save_local(game.saved,save_path if save_path!='' else game.active_save_path())!=OK:
		game.saved=before;error='Speichern fehlgeschlagen. Es wurde nichts verbraucht.';return false
	error='';return true
func show(index:int=-1,category:String='weapon',offset:int=0):
	if not enter():return
	hero=clampi(index if index>=0 else hero,0,game.characters.size()-1);slot=category if SLOT_NAMES.has(category) else 'weapon';page=maxi(0,offset)
	for id in game.saved.meta.owned:
		if C.catalog().items.has(id):game.saved.collection.levels[id]=1
	var character=game.characters[hero];var state=game.saved.collection;var owned_hero=state.heroes.has(character.id)
	game.backdrop('MAYHEM GARAGE','%s / %d STUDIO-COINS / %d WERKSTATTTEILE' % [character.name,game.saved.meta.coins,state.parts])
	game.UISkin.panel(game,Rect2(90,240,630,680),Color(character.color))
	game.portrait(Vector2(115,270),hero,1.5,'wardrobe')
	text(character.name+(' / DEINE CREW' if owned_hero else ' / CREW-CASE BENÖTIGT'),Vector2(115,845),570,30,Color(character.color))
	text('Deko gilt für alle Fighter' if slot=='deco' else 'Dein Look / Ausrüstung gilt ab Run-Start',Vector2(115,895),570,21)
	button('‹',Vector2(105,245),Vector2(90,80),func():show(posmod(hero-1,game.characters.size()),slot))
	button('›',Vector2(610,245),Vector2(90,80),func():show(posmod(hero+1,game.characters.size()),slot))
	var keys=SLOT_NAMES.keys()
	for i in range(keys.size()):
		var key:String=keys[i]
		var tab=button(SLOT_NAMES[key],Vector2(760+(i%4)*265,240+(i/4)*80),Vector2(250,72),func():show(hero,key),Color('#147F81') if key==slot else Color('#302342'));tab.add_theme_font_size_override('font_size',28)
	var ids:Array=[]
	for id in C.catalog().items:
		if C.catalog().items[id].slot==slot:ids.append(id)
	if slot=='weapon':ids.sort_custom(func(a,b):return int(C.ALLOWED[character.id].has(a))>int(C.ALLOWED[character.id].has(b)))
	var pages=maxi(1,ceili(ids.size()/3.0));page=clampi(page,0,pages-1)
	for i in range(page*3,mini(ids.size(),page*3+3)):
		var id:String=ids[i];var d=C.catalog().items[id];var x=760+(i%3)*355;var rank=int(state.levels.get(id,0));var compatible=slot!='weapon' or C.ALLOWED[character.id].has(id)
		var equipped=game.saved.meta.equipped.get(d.get('group',''),'')==id if slot=='deco' else state.loadouts[character.id].get(slot,'')==id
		game.UISkin.panel(game,Rect2(x,415,330,505),Color(d.color) if rank>0 else Color('#47435A'))
		image_item(id,Rect2(x+90,430,150,120))
		text(d.name,Vector2(x+18,550),295,30,Color(d.color))
		text(d.description,Vector2(x+18,605),295,23)
		text(('WERKSTATTRANG %d / 5' % rank if d.ranked else 'REIN OPTISCH') if rank>0 else ('FUNDORT: '+C.catalog().cases[d.case].name),Vector2(x+18,695),295,21,game.TEAL)
		var label='AKTIV' if equipped else ('AUSRÜSTEN' if rank>0 and compatible and owned_hero else ('KLASSENBINDUNG' if not compatible else 'GESPERRT'))
		var b=button(label,Vector2(x+15,740),Vector2(300,75),func():
			if transact('equip',id):game.sound('garage_equip')
			show(hero,slot,page))
		b.disabled=equipped or rank==0 or not compatible or not owned_hero
		if d.slot=='skin' and rank==0:
			var buy=button('KAUFEN / %d COINS' % int(d.get('price',300)),Vector2(x+15,825),Vector2(300,75),func():
				if transact('skin_buy',id):game.sound('skin_equip')
				show(hero,slot,page))
			buy.disabled=game.saved.meta.coins<int(d.get('price',300))
		if d.ranked:
			var cost=int(C.catalog().upgrade_costs[maxi(0,mini(3,rank-1))]);var upgrade=button('RANG 5 MAX' if rank>=5 else '%d TEILE AUFRÜSTEN' % cost,Vector2(x+15,825),Vector2(300,75),func():
				if transact('upgrade',id):game.sound('garage_upgrade')
				show(hero,slot,page))
			upgrade.disabled=rank==0 or rank>=5 or state.parts<cost
	button('ZURÜCK',Vector2(100,965),Vector2(350,85),func():game.character_select(hero))
	button('MEISTERSCHAFT',Vector2(490,965),Vector2(370,85),func():game.mastery_screen(hero))
	button('ABLEGEN',Vector2(900,965),Vector2(230,85),func():transact('off');show(hero,slot,page)).disabled=slot=='weapon' or not owned_hero
	button('‹',Vector2(1170,965),Vector2(100,85),func():show(hero,slot,page-1)).disabled=page<=0
	text('%d / %d' % [page+1,pages],Vector2(1310,989),110,28,game.GOLD)
	button('›',Vector2(1420,965),Vector2(100,85),func():show(hero,slot,page+1)).disabled=page>=pages-1
	button('CASES',Vector2(1560,965),Vector2(260,85),cases)
	if error!='':text(error,Vector2(110,925),1500,23,Color('#FF4757'))
func cases():
	if not enter():return
	busy=false
	if not game.saved.collection.pending.is_empty():reveal();return
	game.backdrop('MAYHEM CASES','ERSPIELBAR / %d STUDIO-COINS / %d TEILE / %d ÖFFNUNGEN' % [game.saved.meta.coins,game.saved.collection.parts,game.saved.collection.opened])
	var ids=['crew','arsenal','style']
	for i in range(3):
		var id:String=ids[i];var d=C.catalog().cases[id];var x=100+i*585;var ticket=int(game.saved.collection.tickets[id]);var complete=id=='crew' and game.saved.collection.heroes.size()==C.HEROES.size()
		game.UISkin.panel(game,Rect2(x,245,550,675),Color(d.color))
		var texture=AtlasTexture.new();texture.atlas=Art.CASES;texture.region=Art.case_region(id);game.UISkin.image(game,texture,Rect2(x+25,280,500,245))
		text(d.name,Vector2(x+25,535),500,42,Color(d.color))
		text('Crew vollständig: Duplikate geben Teile.' if complete else d.description,Vector2(x+25,600),500,25)
		text('TICKETS: %d / PREIS: %d STUDIO-COINS' % [ticket,d.price],Vector2(x+25,700),500,24,game.GOLD)
		var progress=C.case_progress(game.saved,id)
		text('NEUER FIGHTER IN MAX. %d %s' % [progress.guarantee,'CASE' if progress.guarantee==1 else 'CASES'] if id=='crew' and progress.guarantee>0 else ('NOCH %d COINS BIS ZUM CASE' % progress.needed if not progress.ready else 'BEREIT / DEIN FUND BLEIBT DAUERHAFT'),Vector2(x+25,665),500,21,game.TEAL)
		button('INHALTE & CHANCEN',Vector2(x+25,750),Vector2(500,65),func():chances(id))
		var open=button('GRATISTICKET ÖFFNEN' if ticket>0 else 'ÖFFNEN / %d COINS' % d.price,Vector2(x+25,835),Vector2(500,70),func():open_case(id),Color(d.color).darkened(.65))
		open.disabled=(ticket<=0 and game.saved.meta.coins<d.price) or (complete and ticket<=0)
	button('HAUPTMENÜ',Vector2(100,965),Vector2(350,85),game.main_menu)
	button('INVENTAR',Vector2(490,965),Vector2(430,85),func():show(game.selected))
	button('LETZTE FUNDE',Vector2(960,965),Vector2(400,85),history)
	button('AUFTRÄGE',Vector2(1400,965),Vector2(420,85),func():game.reward_hub.show())
	if error!='':text(error,Vector2(110,925),1600,24,Color('#FF4757'))
func chances(id:String,offset:int=0):
	if not enter():return
	var entries=C.candidates(game.saved,id);var pages=maxi(1,ceili(entries.size()/10.0));offset=clampi(offset,0,pages-1)
	game.backdrop(C.catalog().cases[id].name+' / CHANCEN','Tatsächliche Einzelchancen / Duplikate: Standard20, Selten35, Episch60 Teile')
	var source=C.catalog().heroes if id=='crew' else C.catalog().items
	if id=='crew':text('Crew vollständig: Alle weiteren Funde geben Werkstattteile.' if game.saved.collection.heroes.size()==C.HEROES.size() else 'Neuer Fighter spätestens nach %d weiteren Crew-Cases, solange noch einer fehlt.' % (3-game.saved.collection.pity),Vector2(120,245),1650,29,game.TEAL)
	for i in range(offset*10,mini(entries.size(),offset*10+10)):
		var e=entries[i];var x=110+(i%2)*865;var y=330+((i%10)/2)*115;var owned=game.saved.collection.heroes.has(e.id) if id=='crew' else game.saved.collection.levels.has(e.id)
		game.UISkin.panel(game,Rect2(x,y,815,100))
		text('%s / %.2f %%\n%s' % [source[e.id].name,e.chance*100,'BEREITS VORHANDEN → TEILE' if owned else source[e.id].rarity],Vector2(x+20,y+12),775,27,game.GOLD if owned else Color.WHITE)
	button('ZURÜCK',Vector2(100,965),Vector2(350,85),cases)
	button('VORHERIGE',Vector2(850,965),Vector2(420,85),func():chances(id,offset-1)).disabled=offset<=0
	button('NÄCHSTE',Vector2(1310,965),Vector2(500,85),func():chances(id,offset+1)).disabled=offset>=pages-1
func open_case(id:String) -> bool:
	if not transact('open',id):cases();return false
	game.sound('case_open');busy=true
	if game.test_mode or game.saved.settings.get('reduced_motion',false):reveal();return true
	game.backdrop('DEIN FUND WARTET','Der nächste Baustein für deine Mayhem-Sammlung.')
	var fx=Control.new();fx.set_script(preload('res://scripts/ui/case_opening.gd'));fx.garage=self;fx.case_id=id;fx.revision=game.ui_revision;fx.mouse_filter=Control.MOUSE_FILTER_IGNORE;game.ui_root.add_child(fx)
	button('ÜBERSPRINGEN',Vector2(1310,965),Vector2(500,85),reveal)
	return true
func reveal():
	busy=false;game.sound('case_reveal')
	# Acknowledging clears the saved dictionary in place. Button callbacks must
	# retain an independent receipt for their destination and repeat-tap handling.
	var r:Dictionary=game.saved.collection.pending.duplicate(true)
	if r.is_empty():cases();return
	var d=C.catalog().heroes[r.id] if r.hero else C.catalog().items[r.id]
	game.backdrop('DUPLIKAT / +%d TEILE' % r.parts if r.duplicate else ('NEUER FIGHTER!' if r.hero else 'NEUER FUND!'),C.catalog().cases[r.case].name+' / '+d.rarity)
	game.UISkin.panel(game,Rect2(100,245,1720,675),Color('#FFD166') if not r.duplicate else Color('#795396'))
	if r.hero:
		for i in range(game.characters.size()):
			if game.characters[i].id==r.id:hero=i;game.portrait(Vector2(180,270),i,1.6);break
	else:image_item(r.id,Rect2(200,330,500,400))
	text(d.name,Vector2(850,330),850,64,game.GOLD)
	text(('Bereits in deiner Sammlung. +%d Werkstattteile für dauerhafte Upgrades.' % r.parts) if r.duplicate else ('Fighter und passende Startwaffe sind dauerhaft freigeschaltet.' if r.hero else d.description),Vector2(850,460),850,34)
	text('Der Fund gehört dauerhaft dir.\n%d STUDIO-COINS / %d TEILE' % [game.saved.meta.coins,game.saved.collection.parts],Vector2(850,670),850,29,game.TEAL)
	game.ui_back_action=func():
		if transact('ack','',r.serial):cases()
		else:reveal()
	game.ui_back_priority=3
	button('WEITERE CASES',Vector2(100,965),Vector2(720,85),func():
		if transact('ack','',r.serial):cases()
		else:reveal())
	button('ZUM INVENTAR',Vector2(950,965),Vector2(870,85),func():
		if transact('ack','',r.serial):show(hero,'weapon' if r.hero else d.slot)
		else:reveal())
	if error!='':text(error,Vector2(110,925),1600,24,Color('#FF4757'))
func history(offset:int=0):
	if not enter():return
	var entries=game.saved.collection.history;var pages=maxi(1,ceili(entries.size()/8.0));offset=clampi(offset,0,pages-1)
	game.backdrop('DEINE LETZTEN FUNDE','Öffnungsbelege / lokal gespeichert')
	if entries.is_empty():text('Noch keine Cases geöffnet. Dein Startticket wartet!',Vector2(120,350),1600,38,game.GOLD)
	for i in range(offset*8,mini(entries.size(),offset*8+8)):
		var e=entries[i];var d=C.catalog().heroes[e.id] if e.hero else C.catalog().items[e.id]
		text('#%d / %s / %s' % [e.serial,d.name,('+%d TEILE' % e.parts) if e.duplicate else 'NEU'],Vector2(130,280+(i%8)*80),1600,32,game.TEAL if not e.duplicate else game.GOLD)
	button('ZURÜCK',Vector2(100,965),Vector2(450,85),cases)
	button('VORHERIGE',Vector2(850,965),Vector2(420,85),func():history(offset-1)).disabled=offset<=0
	button('NÄCHSTE',Vector2(1310,965),Vector2(500,85),func():history(offset+1)).disabled=offset>=pages-1

func button(caption:String,at:Vector2,dimensions:Vector2,action:Callable,color:Color=Color('#2F2044')) -> Button:
	# Touch also emits mouse events. Change pages after that dispatch has finished,
	# and discard queued taps from the old screen after its first action navigates.
	var revision=game.ui_revision
	return game.button(caption,at,dimensions,func():dispatch_button.call_deferred(action,revision),color)
func dispatch_button(action:Callable,revision:int):
	if revision==game.ui_revision:action.call()

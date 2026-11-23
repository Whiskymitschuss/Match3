extends RefCounted
const W=preload('res://scripts/progression/world_progress.gd')
var game:Node2D
var save_path='user://save.json'
var busy=false
var error=''
var notice=''
func _init(g:Node2D):game=g
func can_enter() -> bool:return game.state not in [game.State.COMBAT,game.State.PAUSED,game.State.LEVEL_UP,game.State.SHOP,game.State.WAVE_PREPARATION]
func text(value:String,at:Vector2,width:float,font:int=26,color:Color=Color.WHITE) -> Label:
	var node=game.label_at(value,at,font,color);node.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;node.set_deferred('size',Vector2(width,140));return node
func persist() -> bool:
	if game.SaveManager.save_local(game.saved,save_path)!=OK:error='Speichern fehlgeschlagen. Bitte erneut versuchen.';return false
	error='';return true
func claim(id:String) -> bool:
	if busy or not can_enter():return false
	busy=true
	var before=game.saved.duplicate(true)
	if not W.claim(game.saved,id):busy=false;return false
	if not persist():game.saved=before;busy=false;return false
	notice='BELOHNUNG GESICHERT: '+W.reward_text(id);busy=false;game.sound('buy');return true
func show():
	if not can_enter():return
	game.change_state(game.State.ARENA_SELECT);game.arena_cursor=posmod(game.arena_cursor,W.ORDER.size())
	var id:String=W.ORDER[game.arena_cursor];var d=game.Arenas.definition(id);var r=W.rewards()[id];var color=Color(r.color)
	var progress:Dictionary=game.saved.world_progress
	game.backdrop('DIE MAYHEM WELTEN','%s / %s / %d STUDIO-COINS / %d WERKSTATTTEILE' % [game.characters[game.selected].name,'ENDLOS' if game.run_mode=='endless' else 'KAMPAGNE',game.saved.meta.coins,game.saved.collection.parts])
	game.selection_swipe.set_context('arena')
	game.button('MODUS: '+('ENDLOS' if game.run_mode=='endless' else 'KAMPAGNE'),Vector2(1060,75),Vector2(750,85),func():game.run_mode='campaign' if game.run_mode=='endless' else 'endless';show())
	var route=Control.new();route.name='WorldRoute';route.set_script(preload('res://scripts/ui/world_route.gd'));route.game=game;game.ui_root.add_child(route)
	for i in range(W.ORDER.size()):
		var b=game.button('',preload('res://scripts/ui/world_route.gd').card_rect(i).position,Vector2(330,115),func():game.arena_select(i))
		b.name='WorldCard_'+W.ORDER[i]
		for kind in ['normal','hover','pressed','disabled','focus']:b.add_theme_stylebox_override(kind,StyleBoxEmpty.new())
	game.UISkin.panel(game,Rect2(100,530,740,365),color)
	var art=Control.new();art.set_script(preload('res://scripts/ui/arena_preview.gd'));art.game=game;art.texture=game.Arenas.texture(id);art.position=Vector2(112,542);art.size=Vector2(716,340);art.clip_contents=true;art.mouse_filter=Control.MOUSE_FILTER_IGNORE;art.modulate=Color.WHITE if W.available(game.saved,id) else Color(.5,.45,.6);game.ui_root.add_child(art)
	game.UISkin.panel(game,Rect2(900,530,920,365),color)
	text(d.name,Vector2(925,543),865,47,color)
	text('BOSSE 2 / 4 / 6 / 8 / 10 / FINALE: '+d.boss_name,Vector2(925,609),865,25)
	var available=W.available(game.saved,id)
	var previous=W.previous_world(id)
	var status='ARENA GESPERRT / Besiege den Boss in Welle 10 auf '+game.Arenas.definition(previous).name if not available else ('WELT GEMEISTERT / Erneut spielen oder nächste Arena wählen' if progress.cleared.has(id) else 'NÄCHSTES ZIEL / Besiege den Boss in Welle 10')
	if game.run_mode=='endless' and available:status='ENDLOS / Bereits offene Arena / Rekordjagd ohne weitere Weltfreigabe'
	text(status,Vector2(925,651),865,25,game.TEAL if available else game.GOLD)
	text('ERSTABSCHLUSS: '+W.reward_text(id),Vector2(925,719),865,23,game.GOLD)
	var reward=game.button('BELOHNUNG ABHOLEN' if W.eligible(game.saved,id) else ('BEREITS ABGEHOLT' if progress.claimed.has(id) else 'ERSTER ARENASIEG BENÖTIGT'),Vector2(925,795),Vector2(870,80),func():claim(id);show(),Color('#6C3D79'))
	reward.name='ClaimWorldReward';reward.disabled=not W.eligible(game.saved,id)
	var record:Dictionary=game.saved.arena_records[id]
	# Read the stable arena record rather than guessing completion from highest_wave.
	var time:float=0
	for c in record.records.values():
		if float(c.fastest_victory)>0 and (time<=0 or c.fastest_victory<time):time=c.fastest_victory
	var record_text='KAMPAGNE: WELLE %d / 10 / %d SIEGE\nBESTZEIT %s' % [record.highest_wave,record.wins,game.duration_text(time) if time>0 else '—']
	if game.run_mode=='endless':
		var e:Dictionary=game.saved.endless_records[id]
		record_text='ENDLOS: BESTWELLE %d / %d RUNS\nGESAMT %d KILLS' % [e.highest_wave,e.runs,e.kills]
	if id!='scrapyard':text(d.description,Vector2(120,690),695,23,game.GOLD)
	text(record_text,Vector2(120,758),695,23)
	game.button('WÄHRUNGEN',Vector2(100,910),Vector2(350,45),wallet_help)
	game.button('CASES & GARAGE',Vector2(490,910),Vector2(350,45),func():game.garage.cases())
	var enter=game.button('ARENA BETRETEN' if available else 'VORHERIGE WELT ABSCHLIESSEN',Vector2(925,925),Vector2(870,100),func():game.choose_arena(id),color.darkened(.65))
	enter.name='EnterWorld';enter.disabled=not available
	game.button('ZURÜCK',Vector2(100,975),Vector2(260,75),game.character_select)
	game.button('STUFE: '+game.Difficulty.definition(game.selected_difficulty).name,Vector2(400,975),Vector2(440,75),func():game.difficulty_select(game.arena_cursor))
	if error!='':
		enter.disabled=true
		game.UISkin.panel(game,Rect2(900,530,920,365),Color('#FF6D7B'))
		text('FORTSCHRITT SPEICHERN',Vector2(925,545),860,42,Color('#FF6D7B'))
		text(error+'\nDein Fortschritt bleibt für einen erneuten Versuch in dieser Sitzung erhalten. Es wurde keine Belohnung zusätzlich vergeben.',Vector2(925,620),860,27)
		game.button('ERNEUT SPEICHERN',Vector2(925,795),Vector2(870,80),func():persist();show())
	elif notice!='':text(notice,Vector2(105,507),1700,22,game.GOLD)
func wallet_help():
	if not can_enter():return
	game.backdrop('DEINE WÄHRUNGEN','Drei klare Zwecke / Alles erspielbar / Vollständig lokal')
	var rows=[['RUN-COINS','Für Waffen, Items und Heilung im Wellenshop.\nGehören zum laufenden Run. Ein neuer Run startet bei 0.','coins'],['STUDIO-COINS','Dauerhaft für Cases und den kosmetischen Shop.\nDurch Runs, Aufgaben und Erstabschlüsse verdienen.','coins'],['WERKSTATTTEILE','Dauerhaft für Waffen- und Ausrüstungsränge1–5.\nAus Duplikaten und Erstabschlussbelohnungen.','parts']]
	for i in range(3):
		var x=100+i*585
		game.UISkin.panel(game,Rect2(x,275,550,565),[Color('#FFAA43'),Color('#38D5D2'),Color('#A96BE7')][i])
		game.UISkin.image(game,preload('res://scripts/ui/gear_art.gd').icon('parts') if rows[i][2]=='parts' else game.UISkin.Icons.get_icon(rows[i][2]),Rect2(x+195,305,160,160))
		text(rows[i][0],Vector2(x+30,495),490,38,game.GOLD)
		text(rows[i][1],Vector2(x+30,575),490,29)
	game.button('ZUR WELTKARTE',Vector2(100,925),Vector2(700,105),show)
	game.button('CASES & GARAGE',Vector2(1100,925),Vector2(700,105),func():game.garage.cases())

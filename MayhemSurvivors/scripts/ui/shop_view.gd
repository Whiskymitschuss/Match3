extends RefCounted
var game:Node2D
var tab='weapons'
func _init(g:Node2D):game=g
func text(value:String,pos:Vector2,width:float,size:int=26,color:Color=Color.WHITE) -> Label:
	var label=game.label_at(value,pos,size,color)
	label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	label.set_deferred('size',Vector2(width,180))
	label.mouse_filter=Control.MOUSE_FILTER_IGNORE
	return label
func icon(texture:Texture2D,pos:Vector2,size:Vector2):
	var view=TextureRect.new();view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.texture=texture
	view.position=pos;view.size=size;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;view.mouse_filter=Control.MOUSE_FILTER_IGNORE
	game.ui_root.add_child(view)
func panel(pos:Vector2,size:Vector2,color:Color):
	var node=Panel.new();node.position=pos;node.size=size;node.mouse_filter=Control.MOUSE_FILTER_IGNORE
	node.add_theme_stylebox_override('panel',game.style(color));game.ui_root.add_child(node)
func show():
	if game.state!=game.State.SHOP:return
	if not game.saved.settings.get('shop_help_seen',false) and not (game.tutorial and game.tutorial.active):help_page(0);return
	game.backdrop('MAYHEM MARKET','Welle %d geschafft  /  %s  /  %d Run-Coins' % [game.wave_number,game.characters[game.selected].name,game.coins])
	game.button('WERTE',Vector2(1250,75),Vector2(260,85),stats)
	game.button('? HILFE',Vector2(1550,75),Vector2(260,85),func():help_page(0))
	for i in range(game.offers.size()):
		var o=game.offers[i];var x=100+i*435
		panel(Vector2(x,245),Vector2(400,495),Color('#19222F'))
		var color=game.TEAL
		if o.type=='weapon':game.weapon_icon(o.id,Vector2(x+15,270),Vector2(115,95))
		elif o.type=='item':
			color=Color(game.run_items.data[o.id].color);icon(game.run_items.icon(o.id),Vector2(x+25,270),Vector2(90,90))
		else:
			icon(game.UISkin.Icons.get_icon(o.id),Vector2(x+25,270),Vector2(90,90))
		text(o.rarity,Vector2(x+145,285),235,22,color)
		text('WAFFE' if o.type=='weapon' else ('GEGENSTAND' if o.type=='item' else 'VERBESSERUNG'),Vector2(x+145,325),235,18)
		text(o.name,Vector2(x+20,390),360,29,game.GOLD)
		if o.type=='item':
			var lines=o.description.split('\n')
			for j in range(lines.size()):text(lines[j],Vector2(x+20,465+j*43),360,23,Color('#2ED573') if lines[j].begins_with('+') else Color('#FF6376'))
		elif o.type=='weapon':
			var d=game.weapon_data[o.id]
			text(o.description+'\nBasis: %d Schaden / %.2f s' % [d.damage,d.cooldown],Vector2(x+20,465),360,23)
			text('SET: '+game.run_items.FAMILIES[game.run_items.family(o.id)].name,Vector2(x+20,590),360,21,game.TEAL)
		else:text(o.description,Vector2(x+20,465),360,25)
		if o.type=='item':
			var family=game.run_items.data[o.id].family
			text('SET: '+game.run_items.FAMILIES[family].name if game.run_items.FAMILIES.has(family) else 'UNABHÄNGIGES MODUL',Vector2(x+20,590),360,21,color)
		var buy=game.button('GEKAUFT' if o.get('sold',false) else '%d ● KAUFEN' % o.price,Vector2(x+20,640),Vector2(360,85),func():game.buy_offer(i))
		buy.disabled=o.get('sold',false) or game.coins<o.price
	for i in range(3):
		var key=['weapons','items','sets'][i]
		game.button(['WAFFEN (%d)' % game.weapons.size(),'GEGENSTÄNDE (%d)' % game.run_items.owned.size(),'SETS'][i],Vector2(100+i*350,770),Vector2(330,85),func():tab=key;show(),Color('#8B491A') if tab==key else Color('#263342'))
	game.button('REROLL: '+('GRATIS' if game.rerolls==0 else '%d ●' % (5+game.rerolls*3)),Vector2(1300,770),Vector2(480,90),game.reroll_shop)
	game.button('NÄCHSTE WELLE →',Vector2(1300,900),Vector2(480,105),game.next_shop_wave,Color('#8B491A'))
	match tab:
		'weapons':
			for i in range(game.weapons.size()):
				var w=game.weapons[i];var at=Vector2(100+i*255,880)
				game.button('',at,Vector2(235,135),func():weapon_details(w.id))
				game.weapon_icon(w.id,at+Vector2(30,4),Vector2(170,80))
				text('%s • %d' % [game.weapon_data[w.id].name,w.level],at+Vector2(12,92),215,20)
		'items':
			if game.run_items.owned.is_empty():text('Gegenstände ändern deinen Build. Vorteile und Nachteile stehen direkt auf den Karten.',Vector2(110,900),1080,26)
			for i in range(game.run_items.owned.size()):
				var id=game.run_items.owned[i];var at=Vector2(100+i*143,880)
				game.button('',at,Vector2(132,135),func():item_details(id))
				icon(game.run_items.icon(id),at+Vector2(28,8),Vector2(76,76))
				text(game.run_items.data[id].name,at+Vector2(7,92),118,16)
		'sets':
			var counts=game.run_items.counts();var i=0
			for family in game.run_items.FAMILIES:
				var f=game.run_items.FAMILIES[family];var at=Vector2(100+i*365,880);i+=1
				panel(at,Vector2(345,135),Color('#19222F'))
				text('%s  %d/3' % [f.name,mini(3,counts[family])],at+Vector2(12,8),320,23,Color(f.color))
				text(('✓ ' if counts[family]>=2 else '2 Teile: ')+f.two+'\n'+('✓ ' if counts[family]>=3 else '3 Teile: ')+f.three,at+Vector2(12,48),320,20)
func weapon_details(id:String):
	if game.state!=game.State.SHOP:return
	var w:Dictionary={}
	for weapon in game.weapons:
		if weapon.id==id:w=weapon
	if w.is_empty():show();return
	var d=game.weapon_data[id];var spec=game.Specs.definition(w)
	game.backdrop(game.Specs.label(w) if not spec.is_empty() else d.name,'WAFFENWERKSTATT / Stufe %d / %d Run-Coins' % [w.level,game.coins])
	game.weapon_icon(id,Vector2(150,300),Vector2(450,300))
	var damage=float(d.damage)*(1+(w.level-1)*.3)*game.damage_mult*float(spec.get('power',1.0))
	if id=='mop':damage*=game.twinkle.area_multiplier()
	if id=='hammer':damage*=1.0+float(game.characters[game.selected].melee_bonus)
	if id=='tools':damage=game.steelfist.power(w)
	else:damage*=game.gear_weapon_multiplier(id)
	if id in game.united.R.NEW_WEAPONS:damage=game.united.heroes.power(w)*float(spec.get('damage',1))
	var cooldown=float(d.cooldown)/game.attack_mult/(1+.06*(w.level-1))*float(spec.get('cooldown',1.0))
	if id=='orbit':cooldown=.5/game.attack_mult/(1+.08*(w.level-1))*float(spec.get('hit_cooldown',1.0))
	if id=='tools':cooldown=game.steelfist.cooldown(w)
	var reach=(float(d.reach)+10*(w.level-1))*float(spec.get('reach',1.0))
	if id=='orbit':reach=game.specialized_combat.orbit_pose(w).radius
	if id=='tools':reach=game.steelfist.reach(w)
	text('Schaden pro Treffer: %.1f (ohne Krit)\n%s: %.2f s\n%s: %.0f\nKrit-Chance: %.0f %%' % [damage,'Trefferintervall' if id=='orbit' else 'Abklingzeit',cooldown,'Orbit-Radius' if id=='orbit' else 'Zielreichweite',reach,game.crit*100],Vector2(760,285),1000,32)
	text('SET: '+game.run_items.FAMILIES[game.run_items.family(id)].name,Vector2(760,520),1000,29,game.TEAL)
	text(spec.description if not spec.is_empty() else 'Auf Stufe 5 wählst du eine kostenlose Entwicklung. Die Klassenbindung bleibt erhalten.',Vector2(760,590),1000,28)
	if game.united.bosses.weapon_factor(w)>1:text('Gegen Bosse: ×%.2f / %.1f Schaden vor Krit' % [game.united.bosses.weapon_factor(w),damage*game.united.bosses.weapon_factor(w)],Vector2(760,740),1000,26,game.GOLD)
	if id=='tools':text('Jeder 4. Angriff: 150 % Schaden + schwerer Rückstoß.\nSchlüssel und Zange bilden eine gemeinsame Waffe.',Vector2(760,725),1000,26,game.TEAL)
	game.button('ZURÜCK',Vector2(100,840),Vector2(440,105),show)
	var upgrade=game.button('STUFE 5 ERREICHT' if w.level>=5 else 'AUFRÜSTEN • %d ●' % game.run_items.upgrade_price(w),Vector2(610,840),Vector2(570,105),func():game.run_items.upgrade(id))
	upgrade.disabled=w.level>=5 or game.coins<game.run_items.upgrade_price(w)
	var salvage=game.button('LETZTE WAFFE' if game.weapons.size()<=1 else 'VERWERTEN • +%d ●' % game.run_items.salvage_price(w),Vector2(1240,840),Vector2(540,105),func():confirm_salvage(id))
	salvage.disabled=game.weapons.size()<=1
func confirm_salvage(id:String):
	game.backdrop('WAFFE VERWERTEN?','Die Waffe und ihre Entwicklung gehen für diesen Run verloren.')
	text('Du erhältst Run-Coins zurück. Set-Boni werden sofort an deine verbleibende Ausrüstung angepasst.',Vector2(120,340),1500,36)
	game.button('BEHALTEN',Vector2(120,650),Vector2(680,110),func():weapon_details(id))
	game.button('VERWERTEN',Vector2(1000,650),Vector2(680,110),func():game.run_items.salvage(id),Color('#803747'))
func item_details(id:String):
	if not game.run_items.data.has(id):return
	var d=game.run_items.data[id]
	game.backdrop(d.name,'GEGENSTAND / Gilt bis zum Ende dieses Runs')
	icon(game.run_items.icon(id),Vector2(180,300),Vector2(250,250))
	text(d.description,Vector2(650,320),1100,40)
	var family=d.family
	text('SET: '+game.run_items.FAMILIES[family].name if game.run_items.FAMILIES.has(family) else 'Unabhängiges Modul ohne Set-Zählung.',Vector2(650,520),1100,30,Color(d.color))
	text('Jeden Gegenstand kannst du pro Run einmal besitzen. Seine Werte sind bereits in deiner Werteübersicht enthalten.',Vector2(120,710),1550,28)
	game.button('ZURÜCK',Vector2(120,895),Vector2(600,105),show)
func stats():
	game.backdrop('DEIN BUILD','Aktuelle Gesamtwerte inklusive Gegenständen und aktiven Sets')
	game.portrait(Vector2(110,285),game.selected,.95)
	text('HP: %.0f / %.0f\nSchaden: %+.0f %%\nAngriffstempo: %+.0f %%\nKrit-Chance: %.0f %%\nRüstung: %d' % [game.hp,game.max_hp,(game.damage_mult-1)*100,(game.attack_mult-1)*100,game.crit*100,game.armor],Vector2(650,290),520,34)
	text('Bewegung: %.0f\nSammelradius: %.0f\nProjektiltempo: %+.0f %%\nZusatzprojektile: +%d\nLevel: %d' % [game.speed,game.magnet,(game.projectile_speed-1)*100,game.multishot,game.level],Vector2(1230,290),560,32)
	if game.steelfist.active():text('STAHLKRAFT\n+25 % Werkzeugschaden\n10 % Schadensreduktion\n2 % Max-HP Heilung / 5 s',Vector2(125,700),460,25,game.TEAL)
	var counts=game.run_items.counts();var row=0
	for family in counts:
		var d=game.run_items.FAMILIES[family]
		text('%s: %d Teile / %s / %s' % [d.name,counts[family],d.two if counts[family]>=2 else '2er-Bonus inaktiv',d.three if counts[family]>=3 else '3er-Bonus inaktiv'],Vector2(650,645+row*60),1100,25,Color(d.color));row+=1
	game.button('ZUM LADEN',Vector2(110,910),Vector2(600,105),show)
func help_page(page:int):
	game.backdrop('DEINE WERKSTATT','SHOP-HILFE / %d von 3' % [page+1])
	var titles=['ANGEBOTE PRÜFEN','DEINEN BUILD FORMEN','BEREIT FÜR DIE WELLE']
	var descriptions=['Karten zeigen Preis, Seltenheit und Wirkung. Gegenstände haben Vorteile und Nachteile. Der erste Reroll jedes Shopbesuchs ist gratis.','Tippe unten auf eine Waffe: Werte ansehen, aufrüsten oder verwerten. Deine letzte Waffe bleibt geschützt. Auf Stufe 5 wählst du eine Entwicklung.','Gegenstände und passende Waffen aktivieren Set-Boni ab zwei und drei Teilen. Unter WERTE siehst du die aktuellen Gesamtwerte. Erst NÄCHSTE WELLE setzt den Kampf fort.']
	icon(game.run_items.icon(['grip','lens','battery'][page]),Vector2(170,300),Vector2(250,250))
	text(titles[page],Vector2(650,300),1100,42,game.GOLD)
	text(descriptions[page],Vector2(650,405),1080,34)
	game.button('ÜBERSPRINGEN',Vector2(120,855),Vector2(600,105),finish_help)
	game.button('VERSTANDEN' if page==2 else 'WEITER →',Vector2(1050,855),Vector2(700,105),finish_help if page==2 else func():help_page(page+1),Color('#8B491A'))
func finish_help():
	game.saved.settings.shop_help_seen=true;game.save_game();show()

extends RefCounted
const R=preload('res://scripts/core/roster.gd')
const Art=preload('res://scripts/expansion/comic_art.gd')
var game:Node2D
var back:Callable
func _init(g:Node2D):game=g
func text(value:String,at:Vector2,width:float,font:int=29,color:Color=Color.WHITE):
	var l=game.label_at(value,at,font,color);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.set_deferred('size',Vector2(width,500));return l
func show(section:String='rules',page:int=0,return_to:Callable=Callable()):
	if game.state in [game.State.COMBAT,game.State.LEVEL_UP,game.State.SHOP]:return
	if return_to.is_valid():back=return_to
	if not back.is_valid():back=game.main_menu
	game.backdrop('MAYHEM HANDBUCH','Klare Regeln / echte Werte / elf Helden / zehn Welten')
	var tabs=['rules','heroes','enemies','tech'];var names=['SPIELREGELN','HELDEN & WAFFEN','BESTIARIUM','TECHNIK']
	for i in range(4):game.button(names[i],Vector2(100+i*435,245),Vector2(410,80),func():show(tabs[i],0),Color('#66417C') if section==tabs[i] else Color('#2F2044'))
	game.UISkin.panel(game,Rect2(100,355,1720,565))
	var total=1
	if section=='rules':
		text('DEIN RUN',Vector2(140,390),700,46,game.GOLD)
		text('Links unten bewegen. Deine Klassenwaffe greift automatisch an. Rechts unten liegt deine aktive Fähigkeit.\n\n10 Wellen pro Arena: Bosse in 2 / 4 / 6 / 8 / 10. Axel wartet in Welle 6. Der Arenaboss in 10 öffnet die nächste Welt.\n\nGelb = Vorwarnung. Rot = aktive Gefahr. Grün = sichere Ringöffnung.',Vector2(140,465),750,29)
		text('DEIN BUILD',Vector2(960,390),760,46,game.TEAL)
		text('Run-Coins: Wellenshop. Studio-Coins: Cases und kosmetischer Shop. Teile: dauerhafte Werkstatt.\n\nRun-Waffenlevel 1–5: in diesem Lauf. Auf Level 5 eine von zwei Entwicklungen wählen.\n\nWerkstattrang 1–5: dauerhaft. Waffen erhalten maximal +8 % Schaden. Neue Fighter kommen aus Crew-Cases; Bruiser ist frei.',Vector2(960,465),760,29)
	elif section=='heroes':
		total=R.HEROES.size();page=posmod(page,total);var c=game.characters[page];var d=game.weapon_data[c.weapon];var ability=game.hero_ability.data[c.id]
		game.portrait(Vector2(170,395),page,1.25,'wardrobe')
		text(c.name+' / '+c.get('role','MAYHEM CREW'),Vector2(800,390),960,48,Color(c.color))
		text('BASIS: %d HP / %d Tempo / %s\n%s\n\n%s: %.1f Schaden / %.2f s / %d Reichweite\n%s / %.0f s Cooldown\n%s\n\nEntwicklungen: %s' % [roundi(c.hp*(1+float(c.get('hp_bonus',0)))),c.speed,d.name,c.description,d.name,d.damage,d.cooldown,d.reach,ability.name,ability.cooldown,ability.description,' / '.join(game.Specs.choices(c.weapon).map(func(id):return game.Specs.all()[id].name))],Vector2(800,470),950,27)
		if float(d.get('boss_power',1))>1:text('GEGEN BOSSE: ×%.2f Schaden / Entwicklungen können abweichen' % d.boss_power,Vector2(800,867),950,23,game.GOLD)
	elif section=='enemies':
		var ids=Art.ENEMY_IDS.slice(0,19);total=ids.size()+14;page=posmod(page,total)
		var boss=page>=ids.size();var id:String=ids[page] if not boss else 'boss';var idx=page-ids.size() if boss else page
		var texture=AtlasTexture.new();texture.atlas=Art.BOSSES if boss else Art.ENEMIES;texture.region=Art.boss_region(idx) if boss else Art.enemy_region(idx);game.UISkin.image(game,texture,Rect2(140,385,570,480))
		if not boss:
			var d=game.enemy_definition(id);var info=game.united.enemies.data.get(id,{})
			text(info.get('name',id.to_upper()),Vector2(790,390),980,52,Color(d.color))
			text('BASIS: %d HP / %d Tempo / %d Kontaktschaden\n\n%s\n\nGegner werden mit Wellen und Welten stärker. Spezialangriffe sind sichtbar angekündigt. Stun und Rückstoß können viele Angriffe unterbrechen.' % [d.hp,d.speed,d.damage,info.get('description',{'grunt':'Verfolgt dich direkt.','runner':'Schneller Verfolger.','tank':'Robust, aber langsam.','ravox':'Verlasse die Sturmspur seitlich.','spitter':'Erst die rote Ziellinie, dann der Schuss.','drone':'Schützt normale Gegner in ihrer Nähe.','bombling':'Abstand von der Explosionsmarkierung halten.','longshot':'Seine Ziellinie zeigt die Flugrichtung.','hexling':'Verlasse die markierte Zauberfläche.'}.get(id,'Lies die Vorwarnung und halte deinen Fluchtweg frei.'))],Vector2(790,490),930,30)
		else:
			var boss_names=['BREAKER AXEL','SÄUREPANZER / WELLE 2','SCHROTTWALZE / WELLE 4','STURMADMIRAL / WELLE 8']+R.ARENAS.map(func(a):return game.Arenas.definition(a).boss_name)
			text(boss_names[idx],Vector2(790,390),980,50,game.GOLD)
			text('Bossangriffe besitzen feste Vorwarnzeiten. Verlasse Sturmspuren seitlich und nutze grüne Ringöffnungen.\n\nDie Gegner in 2 / 4 / 6 / 8 werden stärker. In Welle 10 kämpfst du gegen den eigenen Abschlussboss deiner Arena.\n\nEin Boss muss vor Ablauf der Zeit fallen. Danach bleiben Coins und XP erhalten; der Shop oder der Arenenabschluss folgt.',Vector2(790,490),930,30)
	elif section=='tech':
		text('ANDROID / OFFLINE',Vector2(150,390),1400,48,game.GOLD)
		text('Version 0.24.0 Alpha / Godot 4.6 / ARM64 / GL Compatibility\nReferenzlayout 1920 × 1080 / Querformat / sichere Bildschirmabstände\n\nAktuell: %.0f FPS / %d Gegner / %d aktive Projektile\nQualität: %s / Effekte begrenzt, Kampfwerte unverändert\n\nLokales Profil mit Backups. Keine Werbung, Käufe oder Server.\nBei Unterbrechung pausiert der Kampf automatisch.' % [Engine.get_frames_per_second(),game.enemies.size(),game.shots.filter(func(s):return s.active).size(),game.saved.settings.quality],Vector2(150,475),1500,30)
		game.button('FPS-ANZEIGE: '+('AN' if game.saved.settings.show_fps else 'AUS'),Vector2(1190,800),Vector2(570,90),func():game.saved.settings.show_fps=not game.saved.settings.show_fps;game.save_game();show('tech'))
	game.button('ZURÜCK',Vector2(100,965),Vector2(400,85),func():back.call())
	if total>1:
		game.button('VORHERIGE',Vector2(800,965),Vector2(430,85),func():show(section,page-1))
		text('%d / %d' % [page+1,total],Vector2(1270,985),150,28,game.GOLD)
		game.button('NÄCHSTE',Vector2(1430,965),Vector2(390,85),func():show(section,page+1))

extends RefCounted
var owner_ref:WeakRef
var game:Node2D:
	get:return owner_ref.get_ref()
var back:Callable
var tab='audio'
func _init(g:Node2D):owner_ref=weakref(g)
func dispose():back=Callable()
func show(return_to:Callable,section:String='audio'):
	back=return_to;tab=section if section in ['audio','graphics','controls','profile'] else 'audio';render()
func leave():
	var target=back;back=Callable()
	if target.is_valid():target.call()
	else:game.main_menu()
func text(value:String,rect:Rect2,font:int=28,color:Color=Color.WHITE):
	var label=game.label_at(value,rect.position,font,color);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.set_deferred('size',rect.size)
func button(value:String,rect:Rect2,callback:Callable,color:Color=Color('#2F2044')) -> Button:return game.button(value,rect.position,rect.size,func():game.queue_ui_action(callback),color)
func toggle(key:String):
	game.saved.settings[key]=not game.saved.settings[key];game.vfx.apply_settings();game.menu_motion.reset();game.save_game();render()
func render():
	game.backdrop('EINSTELLUNGEN','Dein Spielgefühl / Änderungen werden automatisch gespeichert')
	for i in range(4):
		var key=['audio','graphics','controls','profile'][i]
		button(['AUDIO','GRAFIK','STEUERUNG','PROFIL'][i],Rect2(100+i*435,245,410,85),func():tab=key;render(),Color('#64417C') if tab==key else Color('#2F2044'))
	button('ZURÜCK',Rect2(100,960,480,90),leave)
	if tab=='audio':audio()
	elif tab=='graphics':graphics()
	elif tab=='profile':profile()
	else:controls()
func profile():
	game.UISkin.panel(game,Rect2(100,365,1720,550),game.TEAL)
	text('DEIN PROFIL: '+game.profiles.active_name(),Rect2(145,395,1600,70),44,game.GOLD)
	text('Fortschritt und laufender Run bleiben auf diesem Gerät. Mit einer Exportdatei kannst du dein Profil zusätzlich sichern oder auf ein anderes Handy übertragen.',Rect2(145,485,1570,95),29)
	var editable=game.state==game.State.MAIN_MENU
	button('SPIELERPROFILE',Rect2(145,590,740,85),func():dispose();game.profile_view.show()).disabled=not editable
	var backup=game.SaveManager.Store.parse(game.SaveManager.Store.sidecar(game.active_save_path(),'backup'),game.SaveManager.valid_file)
	button('SICHERUNG LADEN',Rect2(1000,590,740,85),func():game.profile_view.confirm_restore(render)).disabled=not editable or backup.is_empty()
	button('EXPORT / IMPORT',Rect2(145,700,740,85),func():dispose();game.profile_transfer.show()).disabled=not editable
	button('BETA-HILFE',Rect2(1000,700,740,85),func():game.beta_view.show(render))
	button('JETZT SPEICHERN',Rect2(145,810,740,85),func():game.save_game();render())
	text(game.save_error,Rect2(1000,820,740,65),23,game.GOLD)
func audio():
	game.UISkin.panel(game,Rect2(100,365,1720,450),game.TEAL)
	for i in range(3):
		var key=['master','music','sfx'][i];var y=405+i*125
		text(['GESAMT','MUSIK','EFFEKTE'][i],Rect2(140,y,350,55),35,game.GOLD)
		var percentage=game.label_at('%d %%' % roundi(float(game.saved.settings[key])*100),Vector2(1640,y),34,game.TEAL)
		var slider=HSlider.new();slider.name='Volume_'+key;slider.position=Vector2(510,y-5);slider.size=Vector2(1040,75);slider.min_value=0;slider.max_value=1;slider.step=.05;slider.value=float(game.saved.settings[key])
		slider.add_theme_icon_override('grabber',preload('res://assets/ui/slider_grab.svg'));slider.add_theme_icon_override('grabber_highlight',preload('res://assets/ui/slider_grab.svg'))
		var rail=game.UISkin.box(Color('#172238'),Color('#51426A'));rail.content_margin_top=6;rail.content_margin_bottom=6
		slider.add_theme_stylebox_override('slider',rail)
		slider.add_theme_stylebox_override('grabber_area',game.UISkin.box(Color('#694197'),game.TEAL))
		slider.value_changed.connect(func(v):game.saved.settings[key]=v;percentage.text='%d %%' % roundi(v*100);game.update_music();game.save_game())
		game.ui_root.add_child(slider)
	text('Eigene Musik für Menü, Kampf und Boss. Warnsignale bleiben klar vom Kampfklang getrennt.',Rect2(120,845,1030,80),28,game.TEAL)
	button('SOUND TESTEN',Rect2(1240,840,570,90),func():game.sound('blaster_fire');game.sound('buy'))
func graphics():
	for i in range(3):
		var q=['LOW','MEDIUM','HIGH'][i];var x=100+i*585
		game.UISkin.panel(game,Rect2(x,370,550,225),game.TEAL if game.saved.settings.quality==q else Color('#795396'))
		button(['NIEDRIG','MITTEL','HOCH'][i]+(' / AKTIV' if game.saved.settings.quality==q else ''),Rect2(x+20,390,510,80),func():game.saved.settings.quality=q;game.vfx.apply_settings();game.save_game();render())
		text(['Weniger Partikel und Menübewegung.','Ausgewogene Darstellung und Effekte.','Volle Effekte und animierte Menüs.'][i],Rect2(x+30,500,480,70),27)
	var keys=['damage_numbers','splatter','reduced_motion','show_fps'];var names=['SCHADENSZAHLEN','CARTOON-SPLATTER','RUHIGE MENÜS','FPS-ANZEIGE']
	for i in range(4):
		var key=keys[i];button(names[i]+': '+('AN' if game.saved.settings[key] else 'AUS'),Rect2(100+(i%2)*875,650+(i/2)*125,835,90),func():toggle(key))
	text('Alle Grafikstufen verwenden dieselben Gegner, Treffer und Belohnungen.',Rect2(120,895,1600,45),25,game.TEAL)
func controls():
	game.UISkin.panel(game,Rect2(100,370,1720,365),game.TEAL)
	button('NEIGUNG: '+('AN' if game.saved.settings.tilt else 'AUS'),Rect2(130,400,790,90),func():toggle('tilt'))
	var modes=['OFF','LOW','HIGH'];var mode=game.saved.settings.haptics
	button('VIBRATION: '+{'OFF':'AUS','LOW':'DEZENT','HIGH':'STARK'}[mode],Rect2(965,400,820,90),func():game.saved.settings.haptics=modes[(modes.find(mode)+1)%3];game.save_game();game.haptic('ability');render())
	text('RECHTS BEWEGEN · LINKS FÄHIGKEITEN' if game.TouchLayout.clean(game.saved.settings.get('touch_layout')).left_handed else 'LINKS BEWEGEN · RECHTS FÄHIGKEITEN',Rect2(140,540,1580,65),40,game.GOLD)
	text('Deine Waffen greifen automatisch an. Neigung bewegt nur den Menühintergrund. Buttons bleiben an ihrem Platz. Ohne Sensor bleibt das Bild stabil.',Rect2(140,625,1580,85),29)
	button('TOUCHLAYOUT ANPASSEN',Rect2(100,750,800,90),func():game.touch_editor.show(render))
	var tutorial=button('TUTORIAL',Rect2(100,855,500,85),func():dispose();game.tutorial.start());tutorial.disabled=game.state==game.State.PAUSED
	button('HANDBUCH',Rect2(650,855,550,85),func():game.game_guide.show('rules',0,func():render()))
	button('NEU ZENTRIEREN',Rect2(1250,855,560,85),func():game.menu_motion.reset();game.sound('click'))

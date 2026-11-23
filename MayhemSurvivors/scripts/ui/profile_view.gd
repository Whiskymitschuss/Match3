extends RefCounted
var game_ref:WeakRef
var game:Node2D:
	get:return game_ref.get_ref()
var selected=''
func _init(g:Node2D):game_ref=weakref(g)
func allowed() -> bool:return game.state==game.State.MAIN_MENU
func text(value:String,rect:Rect2,font:int=28,color:Color=Color.WHITE):
	var label=game.label_at(value,rect.position,font,color);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.set_deferred('size',rect.size)
func button(value:String,rect:Rect2,action:Callable) -> Button:return game.button(value,rect.position,rect.size,func():game.queue_ui_action(action))
func show(id:String=''):
	if not allowed():return
	var profiles=game.profiles
	selected=id if profiles.has(id) else profiles.index.active
	game.backdrop('DEINE SPIELERPROFILE','Vollständig offline / jeder Spieler hat seinen eigenen Fortschritt')
	game.UISkin.panel(game,Rect2(100,270,860,650),game.TEAL);game.UISkin.panel(game,Rect2(1010,270,810,650),game.GOLD)
	var chosen={}
	for i in range(profiles.index.profiles.size()):
		var entry:Dictionary=profiles.index.profiles[i];var active=entry.id==profiles.index.active
		var b=button(entry.name+(' / AKTIV' if active else ''),Rect2(130,300+i*116,800,95),func():show(entry.id))
		if entry.id==selected:b.add_theme_stylebox_override('normal',game.style(Color('#574173')));chosen=entry
	text(chosen.get('name','Spieler'),Rect2(1045,300,730,70),48,game.GOLD)
	text('Freischaltungen, Coins, Ausrüstung, Einstellungen und Statistiken gehören zu diesem Profil.',Rect2(1045,390,720,100),29)
	var activate=button('AKTIVES PROFIL' if selected==profiles.index.active else 'PROFIL AKTIVIEREN',Rect2(1045,510,730,85),func():
		if game.switch_profile(selected):show()
		else:show(selected))
	activate.disabled=selected==profiles.index.active
	button('NAME ÄNDERN',Rect2(1045,620,730,85),func():prompt(false))
	button('NEUES PROFIL',Rect2(1045,730,730,85),func():prompt(true)).disabled=profiles.index.profiles.size()>=profiles.LIMIT
	button('PROFIL ENTFERNEN',Rect2(1045,840,730,65),confirm_remove).disabled=selected in ['player_1',profiles.index.active]
	text(profiles.error if profiles.error!='' else profiles.notice,Rect2(115,925,1680,40),23,Color('#FF6370') if profiles.error!='' else game.TEAL)
	button('ZURÜCK',Rect2(100,975,450,75),game.main_menu)
	button('BETA-HILFE',Rect2(1045,975,730,75),func():game.beta_view.show(show))
func prompt(create:bool,initial_text:String=''):
	if not allowed():return
	var name=''
	for p in game.profiles.index.profiles:
		if p.id==selected:name=p.name
	game.backdrop('NEUES PROFIL' if create else 'PROFIL UMBENENNEN','1–18 Zeichen / Name bleibt ausschließlich auf diesem Gerät')
	game.UISkin.panel(game,Rect2(280,270,1360,390),game.TEAL)
	var edit=LineEdit.new();edit.name='ProfileName';edit.position=Vector2(330,325);edit.size=Vector2(1260,95);edit.text=initial_text if initial_text!='' else ('' if create else name);edit.max_length=18;edit.placeholder_text='Dein Spielername';edit.virtual_keyboard_enabled=true
	edit.add_theme_font_override('font',game.UISkin.BODY);edit.add_theme_font_size_override('font_size',40);edit.add_theme_stylebox_override('normal',game.style(Color('#25223D')));game.ui_root.add_child(edit)
	text('Jedes Profil beginnt mit Bruiser. Dein bisheriger Spielstand bleibt erhalten.',Rect2(330,580,1240,70),28,game.TEAL)
	if game.profiles.error!='':text(game.profiles.error,Rect2(330,545,1240,40),23,Color('#FF6370'))
	var submit=func():
		if not allowed():return
		var value=edit.text
		if create:
			if not game.save_game():prompt(create,value);return
			var id=game.profiles.create(value)
			if id!='':game.switch_profile(id);show();return
		else:
			if game.profiles.rename(selected,value):show(selected);return
		prompt(create,value)
	button('ANLEGEN' if create else 'SPEICHERN',Rect2(980,465,610,90),submit)
	button('ZURÜCK',Rect2(330,465,570,90),func():show(selected))
	edit.text_submitted.connect(func(_value):game.queue_ui_action(submit))
func confirm_remove():
	if not allowed() or selected in ['player_1',game.profiles.index.active]:return
	var id=selected
	game.backdrop('PROFIL AUS AUSWAHL ENTFERNEN?','Der Fortschritt wird nicht mit einem anderen Spieler zusammengeführt.')
	text('Dieses Profil wird aus der Spielerauswahl entfernt. Das aktive Profil und dein Startprofil bleiben geschützt.',Rect2(180,360,1550,160),40,game.GOLD)
	button('ZURÜCK',Rect2(180,650,680,110),func():show(id))
	button('PROFIL ENTFERNEN',Rect2(1000,650,700,110),func():
		if allowed():game.profiles.remove(id);show())
func confirm_restore(back:Callable):
	if not allowed():return
	game.backdrop('SICHERUNGSSTAND LADEN?','Nur das aktive Spielerprofil wird wiederhergestellt.')
	text('Du lädst den letzten gesicherten Stand. Neuere Fortschritte dieses Profils können dabei entfallen. Andere Spielerprofile bleiben erhalten.',Rect2(180,350,1550,190),38,game.GOLD)
	button('ZURÜCK',Rect2(180,650,680,110),back)
	button('SICHERUNG LADEN',Rect2(1000,650,700,110),func():
		if allowed() and game.profiles.restore():game.apply_profile(game.profiles.load_active())
		back.call())

extends RefCounted
const Backup=preload('res://scripts/progression/profile_backup.gd')
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var message=''
var pending:Dictionary={}
var generation=0
var busy=false
func _init(g:Node):game_ref=weakref(g)
func allowed() -> bool:return is_instance_valid(game) and game.state==game.State.MAIN_MENU
func button(label:String,pos:Vector2,size:Vector2,action:Callable) -> Button:return game.button(label,pos,size,func():game.queue_ui_action(action))
func cancel_dialog():generation+=1;pending={};busy=false
func leave():cancel_dialog();game.settings_view.show(game.main_menu,'profile')
func show():
	if not allowed():return
	game.backdrop('DEINE SPIELSTAND-DATEI','Ein Profil sichern oder als zusätzlichen Spieler importieren / vollständig offline')
	game.UISkin.panel(game,Rect2(100,285,1720,600),game.TEAL)
	var text=game.label_at('EXPORT: Sammlung, Coins, Einstellungen, Statistik und gesicherter Run des aktiven Profils.\n\nIMPORT: Legt nach deiner Bestätigung ein zusätzliches Profil an. Andere Spieler bleiben erhalten. Eine Sicherung ist eine Kopie deines Fortschritts; bewahre sie getrennt von der App auf.',Vector2(150,335),31)
	text.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;text.set_deferred('size',Vector2(1590,250))
	button('SICHERUNG EXPORTIEREN',Vector2(150,650),Vector2(730,100),func():choose(true)).disabled=busy
	button('DATEI IMPORTIEREN',Vector2(1000,650),Vector2(730,100),func():choose(false)).disabled=busy or game.profiles.index.profiles.size()>=game.profiles.LIMIT
	game.label_at('Alle fünf Profilplätze sind belegt. Für einen Import brauchst du einen freien Platz.' if game.profiles.index.profiles.size()>=game.profiles.LIMIT else message,Vector2(150,795),25,game.GOLD)
	button('ZURÜCK',Vector2(100,955),Vector2(550,95),leave)
func choose(exporting:bool):
	if not allowed() or busy:return
	if not exporting and game.profiles.index.profiles.size()>=game.profiles.LIMIT:message='Kein freier Profilplatz.';show();return
	if not game.save_game():message=game.save_error;show();return
	var text=Backup.encode(game.saved,game.profiles.active_name()) if exporting else ''
	if exporting and text=='':message='Die Sicherung konnte nicht vorbereitet werden.';show();return
	if not DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG_FILE):message='Auf diesem System ist der native Dateidialog nicht verfügbar.';show();return
	busy=true;generation+=1;var token=generation;var owner=game.profiles.index.active
	var filename='MayhemSurvivors-'+owner+'-'+Time.get_date_string_from_system()+'.json' if exporting else ''
	var mode=DisplayServer.FILE_DIALOG_MODE_SAVE_FILE if exporting else DisplayServer.FILE_DIALOG_MODE_OPEN_FILE
	var result=DisplayServer.file_dialog_show('Spielstand exportieren' if exporting else 'Spielstand importieren','',filename,false,mode,PackedStringArray(['*.json;Mayhem-Spielstand;application/json']),func(ok:bool,paths:PackedStringArray,_filter:int):
		if token!=generation or not allowed() or game.profiles.index.active!=owner:return
		busy=false
		if not ok or paths.is_empty():message='Dateiauswahl abgebrochen.';show();return
		if exporting:
			var error=Backup.write_file(text,paths[0]);message='Sicherung gespeichert. Die Datei enthält dein Profil und gegebenenfalls deinen gesicherten Run.' if error==OK else 'Export fehlgeschlagen. Bitte einen anderen Speicherort versuchen.';show()
		else:preview_file(paths[0]))
	if result!=OK:busy=false;message='Der Dateidialog konnte nicht geöffnet werden.';show()
func preview_file(path:String):
	if not allowed():return
	pending=Backup.read_file(path)
	if pending.get('error','')!='':message=pending.error;pending={};show();return
	preview()
func preview():
	if not allowed() or pending.is_empty():return
	var save:Dictionary=pending.save
	game.backdrop('SICHERUNG IMPORTIEREN?','Ein zusätzliches Profil / bestehende Spieler werden nicht überschrieben')
	game.UISkin.panel(game,Rect2(200,280,1520,510),game.GOLD)
	game.label_at(game.profiles.clean_name(pending.name),Vector2(250,325),48,game.GOLD)
	game.label_at('%d Kämpfer / %d Welten / %d Studio-Coins\n%d Spiele / %d Siege / %d Kills\n%s' % [save.collection.heroes.size(),save.world_progress.unlocked.size(),save.meta.coins,save.games,save.wins,save.kills,'Gesicherter Run enthalten' if not save.active_run.is_empty() else 'Kein aktiver Run enthalten'],Vector2(250,430),32)
	game.label_at('Die Datei kann deinen Profilnamen enthalten.\nFortschritt wird kopiert und nicht mit anderen Profilen verrechnet.',Vector2(250,650),27,game.TEAL)
	button('ABBRECHEN',Vector2(200,855),Vector2(680,110),func():pending={};message='Import abgebrochen.';show())
	button('ALS NEUES PROFIL IMPORTIEREN',Vector2(970,855),Vector2(750,110),confirm_import)
func confirm_import() -> bool:
	if not allowed() or pending.is_empty():return false
	if not game.save_game():message=game.save_error;pending={};show();return false
	var id=game.profiles.import_new(pending.name,pending.save)
	if id=='':message=game.profiles.error;pending={};show();return false
	pending={}
	if not game.switch_profile(id):message='Profil importiert, aber nicht aktiviert: '+game.save_error;show();return false
	message='Profil importiert und aktiviert. Dein gesicherter Run kann im Hauptmenü fortgesetzt werden.';show();return true

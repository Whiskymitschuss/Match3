extends RefCounted
var game_ref:WeakRef
var game:Node2D:
	get:return game_ref.get_ref()
var back:Callable
var guide=false
var copied=false
func _init(g:Node2D):game_ref=weakref(g)
func dispose():back=Callable()
func leave():
	var target=back;back=Callable()
	if target.is_valid():target.call()
	else:game.main_menu()
func report() -> String:
	return 'RF WORLDS / MAYHEM SURVIVORS\n%s\nSystem: %s / %s\nGodot: %s\nAnsicht: %s\nProfil-ID (lokal): %s\nSpeicherstatus: %s\nModus: %s / %s / %s\nStatus: %s / Welle %d / %.1f s\nGegner: %d / Projektile: %d\n\nBitte ergänzen: Was passiert? Welche Schritte führen dazu?' % [ProjectSettings.get_setting('application/config/version'),OS.get_name(),OS.get_model_name(),Engine.get_version_info().string,str(game.get_viewport_rect().size),game.profiles.index.active,game.save_error if game.save_error!='' else game.profiles.load_status.get('status','ok'),game.run_mode,game.arena_id,game.run_difficulty,str(game.state),game.wave_number,game.run_time,game.enemies.size(),game.shots.filter(func(s):return s.active).size()]
func show(return_to:Callable):back=return_to;guide=false;copied=false;render()
func render():
	game.backdrop('GESCHLOSSENE BETA / HILFE','Vollständig offline / Feedback wird nur von dir selbst geteilt')
	game.UISkin.panel(game,Rect2(100,275,1720,625),game.TEAL)
	var edit=TextEdit.new();edit.name='BetaReport';edit.position=Vector2(130,300);edit.size=Vector2(1660,560);edit.editable=false;edit.wrap_mode=TextEdit.LINE_WRAPPING_BOUNDARY;edit.add_theme_font_override('font',game.UISkin.BODY);edit.add_theme_font_size_override('font_size',28)
	edit.text='DEIN BETA-TEST\n\n1. Als neuer Spieler starten: Bruiser, Hammer, Welt 1; alle Guthaben und Fortschritte beginnen bei 0.\n2. Eigenes Profil anlegen, spielen, komplett schließen und erneut öffnen.\n3. Coins, Freischaltungen, Ausrüstung und Statistik kontrollieren.\n4. Zwischen Profilen wechseln und deren Trennung prüfen.\n5. Mit zwei Fingern spielen, Android unterbrechen und zur Pause zurückkehren.\n6. Zehn Wellen, Boss, Shop, Cases und Endlos testen.\n7. Bei Fehlern den Bericht kopieren und deine Schritte ergänzen.\n\nWICHTIG: Dauerhafter Fortschritt wird lokal gesichert. Runs werden bei wichtigen Übergängen, Pause und Android-Unterbrechung gesichert; im Kampf zusätzlich alle 10 Sekunden. Nach App-Neustart im Hauptmenü FORTSETZEN wählen. Export/Import legt eine eigene Sicherungsdatei an. Eine Deinstallation löscht lokale App-Daten.' if guide else report()
	game.ui_root.add_child(edit)
	game.button('ZURÜCK',Vector2(100,960),Vector2(420,90),func():game.queue_ui_action(leave))
	game.button('BERICHT' if guide else 'TESTANLEITUNG',Vector2(560,960),Vector2(580,90),func():game.queue_ui_action(func():guide=not guide;render()))
	game.button('KOPIERT' if copied else 'BERICHT KOPIEREN',Vector2(1180,960),Vector2(630,90),func():game.queue_ui_action(func():DisplayServer.clipboard_set(report());copied=true;render()))

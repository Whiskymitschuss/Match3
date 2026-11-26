extends RefCounted
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
func _init(g:Node):game_ref=weakref(g)
func show():
	if game.state not in [game.State.MAIN_MENU,game.State.CHARACTER_SELECT]:return
	game.main_menu()
	game.backdrop('DEIN MAYHEM / EXTRAS','Üben, Builds vorbereiten und die Steuerung auf dich abstimmen')
	var titles=['BOSS-TRAINING','AUSRÜSTUNGS-BUILDS','DEINE STEUERUNG']
	var descriptions=['Trainiere jede Bossstufe in deinen freigeschalteten Welten. Wähle Fighter und Phase. Dein normaler Run bleibt erhalten.','Drei Ausrüstungs-Presets pro Fighter. Speichere deinen Look und lege Waffen, Kleidung, Item und Zauber gemeinsam an.','Linkshänder, fester oder dynamischer Joystick, Größe und Transparenz. Verschiebe die Bedienelemente in der Vorschau.']
	var icons=['skull','weapon','speed'];var actions=[func():game.practice.show(),func():game.presets_view.show(game.selected),func():game.touch_editor.show(show)]
	for i in range(3):
		var x=100+i*585
		game.UISkin.panel(game,Rect2(x,270,550,615),game.TEAL)
		game.UISkin.image(game,game.UISkin.Icons.get_icon(icons[i]),Rect2(x+195,310,160,160))
		game.label_at(titles[i],Vector2(x+25,490),36,game.GOLD)
		var l=game.label_at(descriptions[i],Vector2(x+25,570),30);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.set_deferred('size',Vector2(500,180))
		var action=actions[i];game.button('ÖFFNEN',Vector2(x+25,770),Vector2(500,85),func():game.queue_ui_action(action))
	game.button('HAUPTMENÜ',Vector2(100,965),Vector2(530,85),func():game.queue_ui_action(game.main_menu))
	game.button('BESTENLISTEN',Vector2(660,965),Vector2(580,85),func():game.queue_ui_action(func():game.leaderboards_view.show()))
	game.ui_back_action=game.main_menu;game.ui_back_priority=3

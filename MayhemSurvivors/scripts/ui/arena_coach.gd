extends RefCounted
var game:Node2D
func _init(g:Node2D):game=g
func offer() -> bool:
	if not game.arena_mechanics.normal_wave() or game.saved.settings.arena_briefings.has(game.arena_id):return false
	show(game.prepare_wave,true);return true
func show(back:Callable,first:bool=false):
	if not game.arena_mechanics.supported() or game.state not in [game.State.WAVE_PREPARATION,game.State.PAUSED]:return
	var reactor=game.arena_id=='reactor';var d=game.arena_mechanics.data[game.arena_id]
	game.backdrop('KICKSYS ARENA-TIPP',game.arena_definition.name+' / '+d.name)
	game.UISkin.panel(game,Rect2(100,270,560,650),game.TEAL)
	game.portrait(Vector2(150,300),4,1.25)
	game.UISkin.panel(game,Rect2(730,270,1080,650),game.GOLD)
	var title=game.label_at('LASS DEN REAKTOR FÜR DICH ARBEITEN' if reactor else 'LASS DIE CONTAINER DEINE GEGNER TREFFEN',Vector2(765,305),40,game.GOLD)
	title.text=game.UISkin.wrap_text(title.text,game.UISkin.HEADING,40,995)
	var body='1 / KERNE SAMMELN\nJeder vierte besiegte Gegner lässt einen Energiekern fallen. Sammle drei.\n\n2 / ÜBERLADUNG STARTEN\nAm Terminal 1,2 Sekunden anhalten. Danach hast du 2,5 Sekunden, um den gelben Kreis zu verlassen.\n\n3 / GEGNER HINEINLOCKEN\nDie Entladung trifft dich und Gegner. Beseitigst du mindestens einen Gegner, gibt es zusätzlich %d Run-Coins. Ein Versuch pro Welle.' % game.arena_mechanics.bonus('reactor') if reactor else '1 / MARKIERUNG LESEN\nAb Welle 3 kommen zwei Doppelladungen pro normaler Welle. Gelb kündigt den Abwurf an.\n\n2 / SEITLICH AUSWEICHEN\nDie Zielposition bleibt fest. Du hast zwei Sekunden. Container treffen dich und Gegner.\n\n3 / GEFAHR NUTZEN\nBeseitige zwei Gegner mit einer Doppelladung: +%d Run-Coins zusätzlich zur normalen Gegnerbeute. Die Kisten versperren keine Wege.' % game.arena_mechanics.bonus('docks')
	var text=game.label_at(body,Vector2(765,420),28);text.text=game.UISkin.wrap_text(body,game.UISkin.BODY,28,995)
	game.label_at('KICKSY / In der Pause unter ARENA-TIPPS erneut ansehen.',Vector2(110,940),24,game.TEAL)
	game.button('VERSTANDEN',Vector2(1000,975),Vector2(810,80),func():game.queue_ui_action(func():
		if first and not game.saved.settings.arena_briefings.has(game.arena_id):game.saved.settings.arena_briefings.append(game.arena_id);game.save_game()
		back.call()),Color('#147F81'))

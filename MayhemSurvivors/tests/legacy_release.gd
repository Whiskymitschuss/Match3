extends RefCounted
# Historical mechanic fixtures deliberately exercise the pre-0.21 boss schedule.
# Current production rules, content and art are covered by united_test/soak/capture.
static func apply(game:Node2D):
	game.united.enabled=false
	# Historical fixtures use a fresh session even when the user profile remembers a world.
	game.selected=0;game.arena_id='scrapyard';game.selected_difficulty='normal';game.run_mode='campaign'
	game.arena_definition=game.Arenas.definition('scrapyard')

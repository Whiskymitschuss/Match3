extends SceneTree
var game
func _initialize():call_deferred('run')
func capture(name: String):
	game.queue_redraw()
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/'+name+'.png')
func run():
	game=load('res://scenes/boot/main.tscn').instantiate()
	game.test_mode=true
	root.add_child(game)
	preload('res://tests/legacy_release.gd').apply(game);game.set_physics_process(false)
	game.saved=game.default_save();preload('res://tests/legacy_collection.gd').unlock_all(game.saved)
	game.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(game.saved)
	game.Arenas.sync(game.saved)
	game.main_menu()
	await capture('reactor_menu')
	game.character_select()
	game.arena_select()
	await capture('reactor_selection')
	game.choose_arena('reactor')
	game.selected=1
	game.start_run()
	game.wave_number=5
	game.begin_wave()
	game.arena_hazards.lane(true,1420,52,1.6,.65,10)
	for i in range(9):
		game.spawn_enemy(['grunt','runner','tank'][i%3])
		game.enemies.back().pos=game.player.position+Vector2.from_angle(i*TAU/9)*(200+i*15)
	game.camera.reset_smoothing()
	game.combat_visuals.update(.016)
	game.update_weapons(.016)
	game.refresh_hud()
	await capture('reactor_arena')
	game.wave_number=10
	game.begin_wave()
	game.enemies[0].pos=game.player.position+Vector2(320,-10)
	game.reactor_guardian.update(3.01)
	game.refresh_hud()
	await capture('reactor_boss')
	game.arena_hazards.clear()
	game.reactor_guardian.update(2.2)
	game.reactor_guardian.update(2.01)
	game.refresh_hud()
	await capture('reactor_bombs')
	game.main_menu()
	game.challenges_screen()
	await capture('reactor_styles')
	game.statistics(-1,'reactor')
	await capture('reactor_statistics')
	game.queue_free()
	await process_frame
	quit()

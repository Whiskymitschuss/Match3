extends SceneTree
var game
func _initialize(): call_deferred('run')
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
	await capture('menu')
	game.character_select()
	await capture('characters')
	game.start_run()
	game.begin_wave()
	for i in range(25):game.spawn_enemy(['grunt','runner','tank'][i%3])
	game.camera.reset_smoothing()
	await capture('arena')
	game.wave_number=10
	game.begin_wave()
	game.enemies[0].pos=game.player.position+Vector2(260,0)
	game.boss_warning='⚠ RADIALSALVE!'
	game.refresh_hud()
	await capture('boss')
	game.cleanup()
	game.coins=200
	game.open_shop()
	await capture('shop')
	game.xp=20
	game.level_up()
	await capture('upgrades')
	game.finish(true)
	await capture('victory')
	game.music.stop()
	await create_timer(.25).timeout
	game.queue_free()
	await process_frame
	quit()

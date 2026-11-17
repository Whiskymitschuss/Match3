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
	game.set_physics_process(false)
	game.saved=game.default_save();preload('res://tests/legacy_collection.gd').unlock_all(game.saved)
	game.selected=1
	game.start_run()
	game.wave_number=3
	game.begin_wave()
	for i in range(12):
		game.spawn_enemy(['grunt','runner','tank'][i%3])
		game.enemies.back().pos=game.player.position+Vector2.from_angle(i*TAU/12)*(170+i*14)
		game.enemies.back().hp=1000
	game.camera.reset_smoothing()
	game.combat_visuals.update(.016)
	game.update_weapons(.016)
	game.combat_visuals.update(.07)
	game.update_shots(.07)
	game.refresh_hud()
	await capture('world_arena')
	game.cleanup()
	for i in range(100):
		game.spawn_enemy(['grunt','runner','tank'][i%3])
		game.enemies.back().pos=game.player.position+Vector2.from_angle(i*2.4)*(45+i%9*19)
	await capture('world_crowd')
	game.cleanup()
	game.player.position=Vector2(320,300)
	game.camera.reset_smoothing()
	for i in range(3):
		game.spawn_enemy(['grunt','runner','tank'][i])
		game.enemies.back().pos=game.player.position+Vector2(160+i*160,80+i*50)
	await capture('world_boundary')
	game.cleanup()
	game.player.position=Vector2(1200,800)
	game.selected=0
	game.start_run()
	game.wave_number=10
	game.begin_wave()
	game.camera.reset_smoothing()
	game.enemies[0].pos=game.player.position+Vector2(340,20)
	game.boss_phase=1
	game.boss_clock=.7
	game.boss_warning='⚠ RADIALSALVE!'
	game.refresh_hud()
	await capture('world_boss_radial')
	game.boss_phase=3
	game.boss_clock=.8
	game.boss_target=game.player.position+Vector2(-60,40)
	game.boss_warning='⚠ STURMANGRIFF!'
	game.refresh_hud()
	await capture('world_boss_charge')
	# Representative test records, not a claim of actual completed user runs.
	game.saved.games=15
	game.saved.wins=4
	game.saved.kills=3120
	game.saved.time=8400
	game.saved.highest_wave=9
	for run in [{'character':'sparky','won':false,'wave':4,'time':230.0,'kills':80,'level':9,'damage':5250.0,'coins':110,'weapons':[{'id':'blaster','level':3}]},{'character':'shade','won':false,'wave':7,'time':410.0,'kills':150,'level':18,'damage':12040.0,'coins':260,'weapons':[{'id':'orbit','level':4}]}]:
		game.RunRecords.add_run(game.saved,run)
		game.saved.games+=1
		game.saved.kills+=run.kills
		game.saved.time+=run.time
	game.run_time=584.2
	game.kills=231
	game.level=20
	game.dealt=14000
	game.earned=520
	game.damage_enemy(game.enemies[0],100000)
	await capture('world_victory')
	game.main_menu()
	game.statistics()
	await capture('world_stats')
	game.statistics(1)
	await capture('world_stats_sparky')
	game.recent_runs_screen()
	await capture('world_history')
	game.queue_free()
	await process_frame
	quit()

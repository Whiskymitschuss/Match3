extends SceneTree
var game
func _initialize():call_deferred('run')
func capture(name:String):
	game.queue_redraw()
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/'+name+'.png')
func setup(weapon:String):
	game.selected=0 if weapon=='hammer' else (2 if weapon=='orbit' else 1)
	game.start_run()
	game.begin_wave()
	game.weapons=[{'id':weapon,'level':5,'clock':0.0}]
	game.camera.reset_smoothing()
func run():
	game=load('res://scenes/boot/main.tscn').instantiate()
	game.test_mode=true
	root.add_child(game)
	game.set_physics_process(false)
	game.saved=game.default_save();preload('res://tests/legacy_collection.gd').unlock_all(game.saved)
	game.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(game.saved)
	for weapon in ['hammer','blaster','splitgun','arc','orbit']:
		setup(weapon)
		game.open_shop()
		await capture('spec_choices_'+weapon)
	for id in ['quake','blast','storm','conductor','wide','swift']:
		var d=game.Specs.all()[id]
		setup(d.weapon)
		game.weapons[0].spec=id
		game.crit=0
		for i in range(10):
			game.spawn_enemy(['grunt','runner','tank'][i%3])
			game.enemies.back().pos=game.player.position+Vector2.from_angle(i*TAU/10)*(100+i*10)
			game.enemies.back().hp=1000
			game.enemies.back().max_hp=1000
		game.orbit_angle=.2
		game.combat_visuals.update(.016)
		game.update_weapons(.016)
		if id=='quake':game.specialized_combat.update(.13)
		if id=='blast':game.update_shots(.12)
		if id=='storm':game.update_shots(.05)
		game.refresh_hud()
		await capture('spec_combat_'+id)
	game.finish(true)
	await capture('spec_result')
	game.main_menu()
	game.recent_runs_screen()
	await capture('spec_history')
	game.queue_free()
	await process_frame
	quit()

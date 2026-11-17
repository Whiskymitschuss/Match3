extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw()
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/'+name+'.png')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	g.selected=1;g.arena_id='reactor';g.start_run()
	await capture('roles_preparation')
	g.wave_number=4;g.begin_wave()
	g.camera.zoom=Vector2(1.3,1.3);g.camera.reset_smoothing()
	g.spawn_enemy('drone');g.enemies.back().pos=g.player.position+Vector2(230,100)
	for offset in [Vector2(160,10),Vector2(320,110),Vector2(220,210)]:
		g.spawn_enemy('grunt');g.enemies.back().pos=g.player.position+offset
	g.spawn_enemy('tank');g.enemies.back().pos=g.player.position+Vector2(310,230)
	g.spawn_enemy('spitter');g.enemies.back().pos=g.player.position+Vector2(-310,-80)
	g.enemies.back().windup=.6;g.enemies.back().aim=g.player.position
	g.spawn_enemy('runner');g.enemies.back().pos=g.player.position+Vector2(-200,200)
	g.refresh_hud()
	await capture('roles_encounter')
	var caster=g.enemies.filter(func(e):return e.kind=='spitter')[0]
	caster.windup=.01
	g.enemy_roles.velocity(caster,Vector2.RIGHT*90,.02)
	g.update_shots(.12)
	g.vfx.update(.06)
	await capture('roles_projectile')
	var drone=g.enemy_roles.drones[0]
	g.damage_enemy(drone,999)
	g.vfx.update(.10)
	g.world_visuals.update(.10)
	await capture('roles_shield_break')
	g.cleanup();g.selected=0;g.arena_id='scrapyard';g.start_run();g.begin_wave()
	g.camera.zoom=Vector2(1.15,1.15);g.camera.reset_smoothing()
	for i in range(10):
		g.spawn_enemy(['grunt','runner','tank'][i%3]);g.enemies.back().pos=g.player.position+Vector2.from_angle(i*TAU/10)*(180+i*12)
	await capture('roles_classic_reference')
	g.queue_free()
	await process_frame
	quit()

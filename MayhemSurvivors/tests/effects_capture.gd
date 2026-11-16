extends SceneTree
var game
func _initialize():call_deferred('run')
func capture(name:String):
	game.queue_redraw()
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/'+name+'.png')
func setup(hero:int,reactor:bool=false):
	game.selected=hero
	game.arena_id='reactor' if reactor else 'scrapyard'
	game.start_run();game.begin_wave()
	game.camera.zoom=Vector2(1.45,1.45)
	game.camera.reset_smoothing()
func run():
	game=load('res://scenes/boot/main.tscn').instantiate()
	game.test_mode=true
	root.add_child(game)
	game.set_physics_process(false)
	game.saved=game.default_save()
	game.saved.wins=1
	setup(1)
	game.crit=.2
	game.rng.seed=51
	for i in range(14):
		game.spawn_enemy(['grunt','runner','tank'][i%3])
		var e=game.enemies.back()
		e.pos=game.player.position+Vector2.from_angle(i*TAU/14)*(120+i%4*45)
		if i%2==0:e.hp=1;game.damage_enemy(e,12)
	game.crit=.2
	game.weapons=[{'id':'blaster','level':5,'clock':0.0,'spec':'blast'},{'id':'splitgun','level':5,'clock':0.0,'spec':'storm'},{'id':'arc','level':5,'clock':0.0,'spec':'conductor'}]
	game.combat_visuals.update(.016)
	game.update_weapons(.016)
	game.update_shots(.06)
	game.vfx.update(.07)
	game.world_visuals.update(.07)
	game.hit_feedback.update(.07)
	game.refresh_hud()
	await capture('fx_splatter_gunfire')
	game.vfx.update(1)
	game.world_visuals.update(1)
	game.combat_visuals.update(1)
	game.hit_feedback.update(1)
	await capture('fx_floor_stains')
	setup(0)
	for i in range(12):
		game.spawn_enemy(['grunt','runner','tank'][i%3])
		game.enemies.back().pos=game.player.position+Vector2.from_angle(i*TAU/12)*(150+i%3*25)
	game.hero_ability.activate()
	game.vfx.update(.10)
	game.hero_ability.update(.10)
	await capture('fx_shockwave')
	setup(1,true)
	for i in range(10):
		game.spawn_enemy(['grunt','runner','tank'][i%3])
		game.enemies.back().pos=game.player.position+Vector2(160,0)+Vector2.from_angle(i*TAU/10)*(50+i%3*30)
	game.hero_ability.activate()
	game.hero_ability.update(.7)
	game.vfx.update(.10)
	await capture('fx_impulse_explosion')
	setup(2)
	game.move_input=Vector2.RIGHT
	game.hero_ability.activate()
	for i in range(5):
		game.hero_ability.move_dash(.026)
		game.hero_ability.update(.026)
		game.vfx.update(.026)
	await capture('fx_shadow_step')
	setup(1,true)
	game.wave_number=10;game.begin_wave()
	game.enemies[0].pos=game.player.position+Vector2(300,0)
	game.reactor_guardian.update(3.01)
	game.vfx.stain(game.enemies[0].pos+Vector2(0,90),Color('#B575FF'),80)
	game.refresh_hud()
	await capture('fx_warning_readability')
	game.main_menu();game.settings(game.main_menu)
	await capture('fx_settings')
	game.queue_free()
	await process_frame
	quit()

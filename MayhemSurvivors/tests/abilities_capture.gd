extends SceneTree
var game
func _initialize():call_deferred('run')
func capture(name:String):
	game.queue_redraw()
	if is_instance_valid(game.ability_button):game.ability_button.queue_redraw()
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/'+name+'.png')
func run():
	game=load('res://scenes/boot/main.tscn').instantiate()
	game.test_mode=true
	root.add_child(game)
	game.set_physics_process(false)
	game.saved=game.default_save()
	game.saved.wins=1
	for hero in range(3):
		game.selected=hero
		game.arena_id='reactor' if hero==1 else 'scrapyard'
		game.start_run()
		if hero==2:await capture('ability_shade_preparation')
		game.begin_wave()
		game.crit=0
		game.camera.reset_smoothing()
		for i in range(8):
			game.spawn_enemy(['grunt','runner','tank'][i%3])
			game.enemies.back().pos=game.player.position+Vector2.from_angle(i*TAU/8)*(130+i*18)
			game.enemies.back().hp=1000
			game.enemies.back().max_hp=1000
		game.move_input=Vector2.RIGHT if hero==2 else Vector2.ZERO
		game.combat_visuals.update(.016)
		if hero==2:await capture('ability_shade_ready')
		game.hero_ability.activate()
		if hero==0:game.hero_ability.update(.18)
		if hero==1:game.hero_ability.update(.36)
		if hero==2:game.hero_ability.move_dash(.10)
		game.refresh_hud()
		await capture('ability_'+game.characters[hero].id)
		if hero==1:
			game.hero_ability.update(.30)
			await capture('ability_sparky_explosion')
	game.main_menu()
	game.settings(game.main_menu)
	await capture('ability_settings')
	game.character_select()
	await capture('ability_characters')
	game.queue_free()
	await process_frame
	quit()

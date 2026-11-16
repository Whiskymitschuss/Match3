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
	game.character_select()
	await capture('grip_characters')
	for hero in range(3):
		game.selected=hero
		game.start_run()
		game.begin_wave()
		game.spawn_enemy('tank')
		game.enemies[0].pos=game.player.position+Vector2(78 if hero==0 else 230,-20)
		game.enemies[0].hp=10000
		game.combat_visuals.update(.016)
		game.update_weapons(.016)
		game.combat_visuals.update(.07)
		game.update_shots(.07)
		game.camera.reset_smoothing()
		game.refresh_hud()
		await capture('grip_'+str(game.characters[hero].id))
		game.camera.zoom=Vector2(3.4,3.4)
		game.camera.reset_smoothing()
		await capture('grip_close_'+str(game.characters[hero].id))
		game.camera.zoom=Vector2(1.15,1.15)
		if hero==1:
			game.weapons=[{'id':'blaster','level':2,'clock':0.0},{'id':'splitgun','level':2,'clock':0.0},{'id':'arc','level':2,'clock':0.0}]
			game.update_weapons(.016)
			game.camera.reset_smoothing()
			await capture('grip_sparky_all')
		game.cleanup()
		game.coins=1000
		game.open_shop()
		await capture('grip_shop_'+str(game.characters[hero].id))
	game.queue_free()
	await process_frame
	quit()

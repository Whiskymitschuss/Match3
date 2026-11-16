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
	for hero in range(3):
		game.selected=hero
		game.start_run()
		game.begin_wave()
		game.camera.reset_smoothing()
		var ids=[['hammer','blaster','splitgun','orbit'],['blaster','splitgun','arc','orbit'],['orbit','blaster','hammer','arc']][hero]
		game.weapons=[]
		for id in ids:game.weapons.append({'id':id,'level':3,'clock':0.0})
		for i in range(9):
			game.spawn_enemy(['grunt','runner','tank'][i%3])
			var e=game.enemies.back()
			e.pos=game.player.position+Vector2.from_angle(i*TAU/9)*(85 if i==0 else 180+i*18)
			e.hp=10000
			game.combat_visuals.update(.016)
		game.orbit_angle=.7
		game.update_weapons(.016)
		game.update_shots(.15)
		game.combat_visuals.impact(game.player.position+Vector2(180,40),'blaster')
		game.refresh_hud()
		await capture('combat_'+str(game.characters[hero].id))
	# Single-gun fixtures make the three character ammo silhouettes easy to compare.
	for hero in range(3):
		game.selected=hero
		game.start_run()
		game.begin_wave()
		game.camera.reset_smoothing()
		game.weapons=[{'id':'blaster','level':1,'clock':0.0}]
		for i in range(5):
			game.spawn_enemy(['grunt','runner','tank'][i%3])
			game.enemies.back().pos=game.player.position+Vector2(240+i*35,(i-2)*75)
		for frame in range(5):game._physics_process(1.0/60)
		await capture('ammo_'+str(game.characters[hero].id))
	game.cleanup()
	game.open_shop()
	game.coins=1000
	game.offers=[]
	for id in ['blaster','hammer','splitgun','arc']:
		game.offers.append({'type':'weapon','id':id,'name':game.weapon_data[id].name,'description':'Comic-Waffe / Level 1','price':30,'rarity':'SELTEN'})
	game.show_shop()
	await capture('combat_shop')
	game.queue_free()
	await process_frame
	quit()

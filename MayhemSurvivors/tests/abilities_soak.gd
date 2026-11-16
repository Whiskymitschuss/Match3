extends SceneTree
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=g.default_save()
	g.saved.wins=1
	var total_uses=0
	for arena in ['scrapyard','reactor']:
		for hero in range(3):
			g.arena_id=arena
			g.selected=hero
			g.saved.settings.quality=['LOW','MEDIUM','HIGH'][hero]
			g.start_run()
			g.wave_number=10 if arena=='reactor' else 9
			g.begin_wave()
			g.rng.seed=704+hero
			g.hp=100000
			g.max_hp=100000
			if arena=='reactor':g.enemies[0].hp=100000000;g.enemies[0].max_hp=100000000
			g.weapons=[]
			for id in g.allowed_weapon_ids():g.weapons.append({'id':id,'level':5,'clock':0.0})
			for i in range(95):g.spawn_enemy(['grunt','runner','tank'][i%3])
			for frame in range(3600):
				g.remaining=90
				g.move_input=Vector2.from_angle(frame*.007)
				if g.hero_ability.ready_to_use():
					if g.hero_ability.activate():total_uses+=1
				g._physics_process(1.0/60)
				while g.state==g.State.LEVEL_UP:
					g.apply_upgrade('damage')
					g.if_more_levels()
				assert(g.state==g.State.COMBAT)
				assert(g.enemies.size()<=100)
				assert(g.shots.size()<=320)
				assert(g.loot.size()<=240)
				assert(g.hero_ability.rings.size()<=1)
				assert(g.hero_ability.afterimages.size()<=8)
				assert(g.hit_feedback.numbers.size()<=64)
				assert(g.arena_hazards.items.size()<=12)
				assert(g.player.position.x>=45 and g.player.position.x<=2355 and g.player.position.y>=45 and g.player.position.y<=1555)
			print('ABILITY SOAK PASS ',arena,' ',g.characters[hero].id,' 3600 steps / 60 simulated seconds, uses=',g.hero_ability.activations)
	# A mass kill can create more than the loot cap in a single activation.
	g.cleanup()
	var xp=0
	for i in range(310):g.loot.append({'pos':Vector2(100,100),'xp':i+1});xp+=i+1
	g.update_loot(0)
	var retained=0
	for l in g.loot:retained+=l.xp
	assert(g.loot.size()==240 and retained==xp)
	print('ABILITY SOAK TOTAL 21600 steps, 360 simulated seconds, ',total_uses,' actual activations; mass-loot merge preserves ',retained,' XP')
	g.queue_free()
	await process_frame
	quit()

extends SceneTree
# Controlled damage opportunity test, not a survivability or Android balance claim.
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	g.set_physics_process(false)
	g.saved=g.default_save()
	g.saved.wins=1
	g.arena_id='reactor'
	var failed=false
	for hero in range(3):
		g.selected=hero
		g.start_run()
		g.wave_number=10
		g.begin_wave()
		g.rng.seed=404
		g.damage_mult=2.2
		g.attack_mult=1.6
		g.crit=.25
		g.multishot=1
		g.weapons.clear()
		for id in g.allowed_weapon_ids():g.weapons.append({'id':id,'level':5,'clock':0.0})
		var boss=g.enemies[0]
		boss.pos=Vector2(1300,800)
		g.player.position=Vector2(1200,800)
		var frames=0
		while g.enemies.has(boss) and frames<5400:
			g.orbit_angle+=3.5/60.0
			boss.orbit_cd=maxf(0,boss.orbit_cd-1.0/60)
			g.update_weapons(1.0/60)
			g.update_shots(1.0/60)
			g.effects.clear()
			frames+=1
		var won=g.state==g.State.VICTORY
		if not won:failed=true
		print('REACTOR DAMAGE ',g.characters[hero].id,' ',frames/60.0,' seconds ', 'PASS' if won else 'FAIL')
	g.queue_free()
	await process_frame
	quit(1 if failed else 0)

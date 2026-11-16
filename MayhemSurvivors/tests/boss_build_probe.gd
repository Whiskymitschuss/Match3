extends SceneTree
# Controlled damage opportunity, no incoming damage/AI: not a full-run balance claim.
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false)
	g.saved=g.default_save();g.saved.wins=1
	var failed=false
	for arena in ['scrapyard','reactor']:
		for id in g.Specs.all():
			var weapon=g.Specs.all()[id].weapon
			g.selected=0 if weapon=='hammer' else (2 if weapon=='orbit' else 1)
			g.arena_id=arena;g.start_run();g.wave_number=10;g.begin_wave()
			g.rng.seed=404;g.damage_mult=2.2;g.attack_mult=1.6;g.crit=.25;g.multishot=1
			g.weapons=[{'id':weapon,'level':5,'clock':0.0,'spec':id}]
			var boss=g.enemies[0]
			g.player.position=Vector2(1200,800)
			boss.pos=g.player.position+Vector2(150 if weapon=='orbit' else (125 if weapon=='hammer' else 140),0)
			var frames=0
			while g.enemies.has(boss) and frames<5400:
				g.orbit_angle+=3.5/60.0;boss.orbit_cd=maxf(0,boss.orbit_cd-1.0/60)
				g.update_weapons(1.0/60)
				if g.state==g.State.COMBAT:g.update_shots(1.0/60)
				g.vfx.update(1.0/60);g.specialized_combat.update(1.0/60);g.hit_feedback.update(1.0/60)
				frames+=1
			var won=g.state==g.State.VICTORY
			if not won:failed=true
			print('BOSS BUILD ',arena,' ',id,' seconds=',frames/60.0,' ', 'PASS' if won else 'FAIL')
	g.queue_free();await process_frame
	quit(1 if failed else 0)

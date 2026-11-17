extends SceneTree
var passed=0
var failed=0
func check(ok: bool, message: String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func _initialize():call_deferred('run')
func run():
	var g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	for hero in range(3):
		g.selected=hero
		g.start_run()
		g.begin_wave()
		g.crit=0
		g.weapons=[{'id':'blaster','level':1,'clock':0.0}]
		g.spawn_enemy('tank')
		g.enemies[0].pos=g.player.position+Vector2(220,0)
		g.update_weapons(.016)
		var shot=g.shots[0]
		check(shot.active and shot.skin==hero and shot.weapon=='blaster','Actual attack stamps character projectile style '+str(hero))
		check(shot.damage==12 and shot.vel.length()==650,'Projectile styling preserves base damage and speed '+str(hero))
		check(g.shots.size()==1,'Projectile slot reused across characters '+str(hero))
		var r=g.combat_visuals.rig('blaster')
		check(r.pulse>0,'Muzzle pulse triggered by actual attack '+str(hero))
		g.pause_game()
		var pulse=r.pulse
		var life=g.combat_visuals.fx[0].life
		g._physics_process(1)
		check(r.pulse==pulse and g.combat_visuals.fx[0].life==life,'Pause freezes combat visual timers '+str(hero))
		g.resume()
		g.cleanup()
		check(g.combat_visuals.rigs.is_empty() and g.combat_visuals.fx.is_empty() and not shot.active,'Cleanup clears weapon feedback and shots '+str(hero))
	for id in ['hammer','arc','orbit']:
		g.start_run()
		g.begin_wave()
		g.weapons=[{'id':id,'level':1,'clock':0.0}]
		g.spawn_enemy('tank')
		g.enemies[0].pos=g.player.position+Vector2(110 if id=='orbit' else 70,0)
		g.orbit_angle=0
		g.update_weapons(.016)
		var kind='slam' if id=='hammer' else ('beam' if id=='arc' else 'impact')
		var found=false
		for effect in g.combat_visuals.fx:
			if effect.kind==kind:found=true
		check(found,'Actual '+id+' attack triggers '+kind+' feedback')
	g.saved.settings.quality='LOW'
	g.cleanup()
	for i in range(100):g.combat_visuals.impact(g.player.position,'blaster')
	check(g.combat_visuals.fx.size()<=24,'LOW quality bounds simultaneous combat effects')
	var art=load('res://scripts/ui/combat_art.gd')
	check(art.projectile(0)!=art.projectile(1) and art.projectile(1)!=art.projectile(2),'Three character projectile regions are distinct')
	for id in ['blaster_fire','splitgun_fire','hammer_slam','arc_zap','blade_hit']:
		check(ResourceLoader.exists('res://assets/audio/'+id+'.wav'),'Weapon sound resource exists '+id)
	print('COMBAT VISUAL RESULT ',passed,' passed, ',failed,' failed')
	g.queue_free()
	await process_frame
	quit(1 if failed else 0)

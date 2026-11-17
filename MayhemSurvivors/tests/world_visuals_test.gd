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
	g.set_physics_process(false)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	g.start_run()
	g.begin_wave()
	var art=load('res://scripts/gameplay/world_visuals.gd')
	var regions:Array=[]
	for kind in ['grunt','runner','tank','boss']:
		var region=art.region(kind)
		check(region.size.x>0 and region.size.y>0 and Rect2(Vector2.ZERO,art.ENEMIES.get_size()).encloses(region),'Enemy sprite region in atlas '+kind)
		check(not regions.has(region),'Distinct sprite silhouette '+kind)
		regions.append(region)
		var radius=float(g.enemy_data[kind].radius)
		check(art.dimensions(radius,kind).is_finite(),'Finite visual dimensions '+kind)
	g.spawn_enemy('grunt')
	var enemy=g.enemies[0]
	var pos=enemy.pos
	var coins=g.coins
	g.damage_enemy(enemy,10000)
	check(g.world_visuals.deaths.size()==1,'Death triggers a single visual snapshot')
	check(g.kills==1 and g.coins==coins+2,'Death art leaves rewards unchanged')
	g.damage_enemy(enemy,10000)
	check(g.world_visuals.deaths.size()==1 and g.kills==1,'Duplicate death does not duplicate effects/rewards')
	enemy.pos=Vector2.ZERO
	check(g.world_visuals.deaths[0].pos==pos,'Death snapshot does not follow removed enemy')
	var life=g.world_visuals.deaths[0].life
	g.pause_game()
	g._physics_process(.1)
	check(g.world_visuals.deaths[0].life==life,'Pause freezes death animation')
	g.resume()
	g.world_visuals.update(.1)
	check(g.world_visuals.deaths[0].life<life,'Death animation advances on resume')
	g.world_visuals.update(1)
	check(g.world_visuals.deaths.is_empty(),'Death animation releases expired snapshots')
	g.saved.settings.quality='LOW'
	for i in range(100):g.world_visuals.enemy_defeated({'kind':'grunt','pos':Vector2(i,0),'radius':23.0})
	check(g.world_visuals.deaths.size()==12,'LOW limits death snapshots independently of gameplay')
	g.cleanup()
	check(g.world_visuals.deaths.is_empty(),'Cleanup removes world effects')
	g.start_run()
	g.wave_number=10
	g.begin_wave()
	check(g.world_visuals.boss_telegraph().is_empty(),'No false warning on initial boss spawn')
	g.boss_clock=0
	g.update_enemies(.016)
	var t=g.world_visuals.boss_telegraph()
	check(t.kind=='radial' and t.radius==78 and is_equal_approx(t.seconds,1.3),'Radial telegraph derives from actual attack phase')
	g.boss_clock=.65
	t=g.world_visuals.boss_telegraph()
	check(is_equal_approx(t.progress,.5),'Telegraph progress matches remaining windup')
	g.pause_game()
	g._physics_process(1)
	check(is_equal_approx(g.world_visuals.boss_telegraph().seconds,.65),'Pause freezes actual warning timer')
	g.resume()
	g.boss_clock=0
	g.update_enemies(.016)
	check(g.world_visuals.boss_telegraph().is_empty(),'Radial warning clears when projectiles fire')
	var bullets=0
	for shot in g.shots:
		if shot.active and shot.hostile:bullets+=1
	check(bullets==18,'Warning adds no damage/projectiles to radial attack')
	g.boss_clock=0
	g.update_enemies(.016)
	t=g.world_visuals.boss_telegraph()
	var locked=g.boss_target
	check(t.kind=='charge' and t.target==locked,'Charge corridor uses actual locked target')
	g.player.position+=Vector2(50,60)
	check(g.world_visuals.boss_telegraph().target==locked,'Charge warning does not falsely follow moving player')
	var rng_state=g.rng.state
	for i in range(20):g.world_visuals.boss_telegraph()
	check(g.rng.state==rng_state,'World visual queries consume no gameplay RNG')
	g.damage_enemy(g.enemies[0],10000)
	check(g.state==g.State.VICTORY and g.saved.wins==1,'New boss artwork still ends in immediate victory')
	var count=0
	for child in g.ui_root.get_children():
		if child.get_script()!=null and child.get_script().resource_path.ends_with('victory_fx.gd'):
			count+=1
			check(child.mouse_filter==Control.MOUSE_FILTER_IGNORE,'Victory particles do not block result buttons')
	check(count==1,'Exactly one result celebration created')
	g.finish(true)
	check(g.saved.wins==1,'Celebration does not record a second win')
	check(ResourceLoader.exists('res://assets/audio/boss_radial_warning.wav') and ResourceLoader.exists('res://assets/audio/boss_charge_warning.wav'),'Both warning sounds available')
	# Saturate the ordinary SFX voices; warning must still use its reserved player.
	g.test_mode=false
	for a in g.sfx_players:
		a.stream=load('res://assets/audio/shot.wav')
		a.play()
	g.sound('boss_charge_warning')
	check(g.alert_audio.stream!=null and g.alert_audio.stream.resource_path.ends_with('boss_charge_warning.wav'),'Boss warning remains routed when regular SFX voices are busy')
	g.alert_audio.stop()
	for a in g.sfx_players:a.stop()
	g.test_mode=true
	await create_timer(.25).timeout
	print('WORLD VISUAL RESULT ',passed,' passed, ',failed,' failed')
	g.queue_free()
	await process_frame
	# Audio mixing uses wall time even when --fixed-fps accelerates SceneTree timers.
	OS.delay_msec(80)
	await process_frame
	quit(0 if failed==0 else 1)

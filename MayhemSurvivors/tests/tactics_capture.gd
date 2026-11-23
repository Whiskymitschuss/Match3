extends SceneTree
var g
func _initialize():call_deferred('run')
func frame(name:String):
	g.refresh_hud();g.queue_redraw();g.camera.position_smoothing_enabled=false;g.camera.reset_smoothing();g.camera.force_update_scroll()
	if is_instance_valid(g.joystick):g.joystick.queue_redraw()
	for i in range(6):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/tactics_'+name+'.png');print('TACTICS FRAME ',name)
func start(arena:String,wave:int=3):
	g.main_menu();g.arena_id=arena;g.run_mode='campaign';g.selected=0;g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func activate():
	var world=g.arena_mechanics.worlds;g.remaining=49.9;g.arena_mechanics.update(.01)
	if world.definition().mode=='relay':
		for at in world.nodes:g.player.position=at;g.arena_mechanics.update(.01)
	else:g.player.position=world.nodes[0];g.arena_mechanics.update(1.01)
func sample(hero:int,seconds:float):
	# Controlled gameplay receipts for UI illustration, not Android/human playtest data.
	g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0;g.weapons[0].clock=999
	g.recap.tick(seconds);g.run_time+=seconds
	for i in range(12):
		g.spawn_enemy('grunt');var e=g.enemies.back();e.hp=40;e.max_hp=40;g.damage_enemy(e,100)
	g.hurt_clock=0;g.hurt(24);g.remaining=0;g._physics_process(.01);g.finish(false)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.master=0;g.saved.settings.reduced_motion=true
	root.size=Vector2i(1600,900);await process_frame;await process_frame;g.update_safe_area()
	for arena in g.arena_mechanics.worlds.IDS:
		start(arena);g.remaining=49.9;g.arena_mechanics.update(.01);g.player.position=g.arena_mechanics.worlds.nodes[0]+Vector2(-95,45)
		await frame(arena+'_tool');activate()
		for i in range(5):g.spawn_enemy('tank');g.enemies.back().pos=g.arena_mechanics.worlds.nodes.back()+Vector2(120+i*32,-30+i*25)
		g.arena_mechanics.update(1.25);g.player.position+=Vector2(-60,55);await frame(arena+'_warning')
		if arena=='frost':g.arena_mechanics.update(.8);await frame('frost_heat')
		g.pause_game();g.arena_coach.show(g.pause_menu);await frame(arena+'_coach')
		start(arena,10);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(180,-80);g.united.bosses.pattern=g.united.bosses.attack_order(boss).find('zones');g.united.bosses.clock=0;g.united.bosses.update(.01);g.arena_mechanics.update(.7);g.united.bosses.update(.7);await frame(arena+'_boss')
	sample(0,53);sample(5,61);sample(11,46)
	for size in [Vector2i(1600,900),Vector2i(2400,1080),Vector2i(1440,1080)]:
		root.size=size;await process_frame;await process_frame;g.update_safe_area();g.main_menu();g.recap_view.show_recent_compare();await frame('compare_'+str(size.x))
	g.saved.recent_runs=g.saved.recent_runs.slice(0,1);g.recap_view.render();await frame('compare_empty')
	g.main_menu();g.saved.collection.heroes=['bruiser'];g.saved.collection.tickets={'crew':0,'arsenal':0,'style':0};g.saved.collection.pity=2;g.saved.meta.coins=37;g.garage.cases();await frame('cases')
	g.saved=original;g.save_game();g.free();call_deferred('finish_capture')
func finish_capture():
	await process_frame;await process_frame;await process_frame;quit()

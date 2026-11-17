extends SceneTree
var g
func _initialize():call_deferred('run')
func capture(name:String):
	g.queue_redraw();g.refresh_hud()
	for i in range(16):await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png('res://tests/difficulty_'+name+'.png');print('DIFFICULTY FRAME ',name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1
	g.character_select();g.difficulty_select();await capture('cards')
	g.selected_difficulty='mayhem';g.selected=1;g.arena_id='docks';g.run_mode='endless';g.start_run();g.wave_number=20;g.begin_wave();g.player.position=Vector2(1200,800);g.camera.reset_smoothing();g.camera.force_update_scroll();g.enemies[0].pos=g.player.position+Vector2(260,0);await capture('combat')
	g.saved.difficulty_records.mayhem.endless.docks.highest_wave=31;g.saved.difficulty_records.mayhem.endless.docks.runs=1;g.difficulty_statistics('mayhem','endless');await capture('records')
	g.queue_free();await process_frame;quit()

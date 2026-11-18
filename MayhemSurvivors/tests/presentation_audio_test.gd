extends SceneTree
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,name:String):
	if ok:passed+=1;print('PASS ',name)
	else:failed+=1;push_error('FAIL '+name)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.update_music()
	check(g.UISkin.LOGO.get_width()>1000 and g.UISkin.ICON.get_height()>1000,'Production wordmark and app icon imported')
	check(g.UISkin.HEADING!=g.UISkin.BODY,'Separate licensed heading and body fonts')
	var found=false
	for node in g.ui_root.get_children():
		if node is TextureRect and node.texture==g.UISkin.LOGO:found=true
	check(found,'Main menu actually displays new wordmark')
	var bg=g.ui_root.get_node('FullBleedBackdrop')
	check(bg.mouse_filter==Control.MOUSE_FILTER_IGNORE,'Decorations cannot intercept touch')
	for node in g.ui_root.get_children():
		if node is Button:check(node.size.y>=85 and node.get_theme_font('font')==g.UISkin.HEADING,'Menu button has touch target and display typography')
	check(g.audio_director.track=='menu_theme','Menu music selected')
	for name in ['menu_theme','combat_theme']:
		check(g.audio_director.cache[name].loop and g.audio_director.cache[name].get_length()>14,'Eight-bar looping score '+name)
	g.start_run();g.begin_wave()
	check(g.audio_director.track=='combat_theme','Combat score selected for actual wave')
	g.pause_game();check(absf(g.music.volume_db-g.audio_director.music_target())<.001,'Pause ducks music')
	var before=g.remaining;g._physics_process(1);check(g.remaining==before,'Audio/UI do not unpause gameplay')
	g.resume();check(absf(g.music.volume_db-g.audio_director.music_target())<.001,'Resume restores music loudness')
	g.cleanup();g.open_shop();check(g.audio_director.track=='menu_theme','Shop returns to workshop music')
	g.saved.settings.music=0;g.update_music()
	check(not g.music.playing and g.audio_director.music_gain()==0 and g.audio_director.sfx_gain()>0,'Music mute leaves effects enabled')
	g.saved.settings.music=.4;g.saved.settings.sfx=0;g.update_music()
	check(g.audio_director.music_gain()>0 and g.audio_director.sfx_gain()==0,'Effects mute leaves music enabled')
	g.saved.settings.master=0;g.update_music()
	check(not g.music.playing and g.audio_director.music_gain()==0 and g.audio_director.sfx_gain()==0,'Master zero mutes music and effects')
	g.saved.settings.master=.8;g.saved.settings.sfx=.8;g.update_music();g.test_mode=false
	for voice in g.sfx_players:voice.stream=g.audio_director.stream('shot');voice.play()
	g.sound('buy');check(g.audio_director.ui_voices[0].playing,'UI purchase sound has reserved voice despite saturated effects')
	g.sound('boss_charge_warning');check(g.alert_audio.playing and g.alert_audio.stream==g.audio_director.stream('boss_charge_warning'),'Critical boss cue has reserved voice')
	var cached=g.audio_director.stream('xp');check(cached==g.audio_director.stream('xp'),'Frequent audio resources cached')
	for voice in g.sfx_players:voice.stop()
	g.sound('coin');g.sound('coin');check(g.sfx_players.filter(func(v):return v.playing).size()==1,'Burst coin events coalesced without voice flooding')
	g.test_mode=true;g.saved.settings.shop_help_seen=true;g.coins=200;g.show_shop()
	check(g.state==g.State.SHOP,'Polished shop retains existing flow')
	g.finish(false);check(g.state==g.State.GAME_OVER,'Polished result retains game over')
	g.start_run();check(g.wave_number==1 and g.coins==0,'Restart retains clean run semantics')
	g.queue_free();await process_frame;OS.delay_msec(180);await process_frame
	print('PRESENTATION AUDIO RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

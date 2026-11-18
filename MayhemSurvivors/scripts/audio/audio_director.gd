extends RefCounted
# Original assets are cached once; fixed voice budgets keep mobile audio bounded.
# Gain is applied per voice, so independent sliders also affect already playing sounds.
var game:Node2D
var cache={}
var last_played={}
var ui_voices:Array[AudioStreamPlayer]=[]
var music_voices={}
var track=''
var music_tween:Tween
const CUES=['steam_warning','core_warning','container_warning','salvage_start','united_warning','united_rage','axel_warning','axel_rage','ravox_warning','boss_phase','elite_warning','warning','boss_radial_warning','boss_charge_warning','victory','defeat']
func _init(g:Node2D):
	game=g
	for i in range(2):
		var voice=AudioStreamPlayer.new();game.add_child(voice);ui_voices.append(voice)
	var directory=DirAccess.open('res://assets/audio')
	if directory:
		for file in directory.get_files():
			if file.ends_with('.wav'):cache[file.get_basename()]=load('res://assets/audio/'+file)
	for name in ['menu_theme','combat_theme']:
		var resource=load('res://assets/audio/'+name+'.ogg');resource.loop=true;cache[name]=resource
		var voice=AudioStreamPlayer.new();voice.stream=resource;game.add_child(voice);music_voices[name]=voice
	game.music=music_voices.menu_theme
	update_settings()
func stream(id:String) -> AudioStream:
	if not cache.has(id):cache[id]=load('res://assets/audio/'+id+'.wav')
	return cache[id]
func music_gain() -> float:return float(game.saved.settings.master)*float(game.saved.settings.music)
func sfx_gain() -> float:return float(game.saved.settings.master)*float(game.saved.settings.sfx)
func music_target() -> float:
	return linear_to_db(maxf(.0001,music_gain()))+(-16 if game.state in [game.State.PAUSED,game.State.LEVEL_UP] else -8)
func play(id:String):
	if game.test_mode or sfx_gain()<=0:return
	var now=Time.get_ticks_msec()
	var gap=70 if id in ['xp','coin','death','fx_splat'] else (40 if id in ['blaster_fire','splitgun_fire','hit','united_flame','united_cryo','united_tesla','united_lance','united_chakram','united_pyro'] else 0)
	if gap>0 and now-int(last_played.get(id,-10000))<gap:return
	last_played[id]=now
	if id in CUES:
		game.alert_audio.stop();game.alert_audio.stream=stream(id);game.alert_audio.volume_db=linear_to_db(sfx_gain());game.alert_audio.play();return
	var voices=ui_voices if id in ['elite_reward','click','buy','level','spec_evolve','salvage_offer','salvage_complete','core_collect','valve_ready','valve_turn'] else game.sfx_players
	for voice in voices:
		if not voice.playing:
			voice.stream=stream(id);voice.volume_db=linear_to_db(sfx_gain())+(-7 if id in ['xp','coin'] else -4);voice.play();return
func state_changed(next:int):
	var wanted=track
	if next in [game.State.COMBAT,game.State.WAVE_PREPARATION]:wanted='combat_theme'
	elif next in [game.State.MAIN_MENU,game.State.CHARACTER_SELECT,game.State.ARENA_SELECT,game.State.SHOP,game.State.VICTORY,game.State.GAME_OVER]:wanted='menu_theme'
	if wanted.is_empty():wanted='menu_theme'
	var changed=wanted!=track
	if music_tween:music_tween.kill();music_tween=null
	if changed:
		game.music.stop();track=wanted;game.music=music_voices[track]
	game.music.volume_db=music_target()
	if not game.test_mode and music_gain()>0 and not game.music.playing:
		game.music.volume_db=music_target()-24;game.music.play()
		music_tween=game.create_tween();music_tween.tween_property(game.music,'volume_db',music_target(),.4)
	if music_gain()<=0:game.music.stop()
func update_settings():
	if music_tween:music_tween.kill();music_tween=null
	game.music.volume_db=music_target()
	if music_gain()<=0:game.music.stop()
	elif not track.is_empty() and not game.test_mode and not game.music.playing:game.music.play()
	for voice in game.sfx_players+ui_voices:
		voice.volume_db=linear_to_db(maxf(.0001,sfx_gain()))-4
		if sfx_gain()<=0:voice.stop()
	game.alert_audio.volume_db=linear_to_db(maxf(.0001,sfx_gain()))
	if sfx_gain()<=0:game.alert_audio.stop()
func stop():
	if music_tween:music_tween.kill();music_tween=null
	for voice in ui_voices:voice.stop();voice.stream=null
	for voice in music_voices.values():voice.stop();voice.stream=null
	music_voices.clear();cache.clear();last_played.clear()

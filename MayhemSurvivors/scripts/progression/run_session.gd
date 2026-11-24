extends RefCounted
const Checkpoint=preload('res://scripts/progression/run_checkpoint.gd')
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var live=false
var run_id=''
var elapsed=0.0
var queued=false
var restoring=false
var test_enabled=false
var notice=''
var worker:Thread
var worker_owner=''
var worker_run=''
var worker_copy_us=0
func _init(g:Node):game_ref=weakref(g)
func enabled() -> bool:return not game.test_mode or test_enabled
func active() -> bool:return live and game.run_mode in ['campaign','endless'] and not game.result_recorded and game.state in [game.State.COMBAT,game.State.PAUSED,game.State.LEVEL_UP,game.State.SHOP,game.State.WAVE_PREPARATION]
func pending() -> bool:return game.saved.get('active_run') is Dictionary and not game.saved.active_run.is_empty()
func begin():
	wait_for_worker()
	live=game.run_mode!='tutorial';run_id=Crypto.new().generate_random_bytes(16).hex_encode();elapsed=0
func end():
	wait_for_worker()
	live=false;elapsed=0;game.saved.active_run={}
func capture() -> bool:
	wait_for_worker()
	if not enabled() or restoring or not active():return true
	var checkpoint=Checkpoint.capture(game,game.profiles.index.active,run_id)
	if checkpoint.is_empty() or Checkpoint.unpack(checkpoint).is_empty():game.save_error='Run konnte nicht gesichert werden.';return false
	game.saved.active_run=checkpoint;elapsed=0;return true
func request():
	if not enabled() or restoring or not active():return
	wait_for_worker()
	if queued:return
	queued=true;call_deferred('_flush')
func _flush():
	queued=false
	if is_instance_valid(game) and active() and enabled() and not restoring:
		game.save_game();elapsed=0
func tick(delta:float):
	if worker and not worker.is_alive():wait_for_worker()
	if not enabled() or not active() or game.state!=game.State.COMBAT:return
	elapsed+=delta
	if elapsed>=10.0 and worker==null:start_worker()
func start_worker() -> bool:
	if worker or not active() or not enabled():return false
	var started=Time.get_ticks_usec()
	game.remember_selection()
	var packet=Checkpoint.gather(game,game.profiles.index.active,run_id)
	if packet.is_empty():return false
	# Native deep copy freezes the frame. Actor IDs restore aliases duplicated by
	# that copy; the worker never reads nodes, live state, resources or UI objects.
	var frozen=packet.duplicate(true);var profile:Dictionary=game.saved.duplicate(true)
	worker_owner=game.profiles.index.active;worker_run=run_id
	worker_copy_us=Time.get_ticks_usec()-started;elapsed=0
	worker=Thread.new()
	var error=worker.start(_write_worker.bind(frozen,profile,game.active_save_path()))
	if error!=OK:worker=null;game.save_error='Autosicherung konnte nicht gestartet werden.';return false
	return true
static func _write_worker(packet:Dictionary,profile:Dictionary,path:String) -> Dictionary:
	var checkpoint=Checkpoint.encode(packet)
	if checkpoint.is_empty() or Checkpoint.unpack(checkpoint).is_empty():return {'error':ERR_INVALID_DATA,'checkpoint':{}}
	profile.active_run=checkpoint
	var Save=preload('res://scripts/autoload/save_manager.gd')
	return {'error':Save.save_local(profile,path),'checkpoint':checkpoint}
func wait_for_worker(apply_result:bool=true):
	if worker==null:return
	var result=worker.wait_to_finish();worker=null
	if not apply_result or not is_instance_valid(game):return
	if game.profiles.index.active!=worker_owner or run_id!=worker_run:return
	if result.error==OK:
		if active():game.saved.active_run=result.checkpoint
		game.save_error=''
	else:game.save_error='Autosicherung fehlgeschlagen. Bitte Speicherplatz prüfen.'
func summary() -> String:
	var cp=game.saved.get('active_run',{})
	if not cp is Dictionary or cp.is_empty():return ''
	var s=cp.get('summary',{})
	return '%s / WELLE %d / LV %d' % [game.Arenas.definition(str(s.get('arena','scrapyard'))).name,int(s.get('wave',1)),int(s.get('level',1))]
func suspend() -> bool:
	if not active():return true
	if not game.save_game():
		if game.state==game.State.PAUSED:game.pause_menu()
		elif is_instance_valid(game.ui_root):
			game.label_at(game.save_error,Vector2(340,845),23,game.GOLD)
		return false
	live=false;return true
func validate_types(d:Dictionary) -> bool:
	for path in Checkpoint.MODULES:
		var object=Checkpoint.module(game,path)
		for key in Checkpoint.MODULES[path]:
			var source=d.modules[path][key];var target=object.get(key)
			if (source is int or source is float) and (target is int or target is float):continue
			if typeof(source)!=typeof(target):return false
	return true
func resume_saved() -> bool:
	if not pending():return false
	var cp=game.saved.active_run;var d=Checkpoint.unpack(cp)
	if d.is_empty() or cp.owner!=game.profiles.index.active or not Checkpoint.compatible(cp,game.saved) or not validate_types(d):
		notice='Dieser Run kann nicht geladen werden. Dein dauerhafter Fortschritt bleibt erhalten.';game.save_error=notice;game.main_menu();return false
	if game.state!=game.State.MAIN_MENU:game.main_menu()
	restoring=true;game.change_state(game.State.RESTORING);game.cleanup()
	for key in Checkpoint.CORE:game.set(key,d.core[key])
	game.arena_definition=game.Arenas.definition(game.arena_id);game.waves=game.read_data(game.arena_definition.waves);game.selected_difficulty=game.run_difficulty
	for path in Checkpoint.MODULES:
		var object=Checkpoint.module(game,path)
		for key in Checkpoint.MODULES[path]:object.set(key,d.modules[path][key])
	game.projectile_pool.items=d.shots;game.shots=game.projectile_pool.items
	game.player.position=d.player.position;game.player.velocity=d.player.velocity
	game.rng.seed=int(d.rng.seed);game.rng.state=int(d.rng.state)
	game.result_recorded=false;game.result_details.clear();game.stick_id=-1;game.stick_pos=Vector2.ZERO;game.move_input=Vector2.ZERO;game.ability_touch_ids.clear();game.equipped_spell.touch_ids.clear()
	run_id=cp.run_id;live=true;elapsed=0
	game.camera.reset_smoothing();game.camera.force_update_scroll()
	match cp.phase:
		'combat':game.change_state(game.State.PAUSED);game.pause_menu()
		'level':game.change_state(game.State.LEVEL_UP);game.show_level_choices()
		'shop':game.change_state(game.State.SHOP);game.show_shop()
		'preparation':game.change_state(game.State.WAVE_PREPARATION);game.prepare_wave()
	restoring=false;notice='Run geladen. Du entscheidest, wann es weitergeht.'
	return true
func confirm_new(action:Callable):
	game.backdrop('GESICHERTEN RUN ERSETZEN?',summary())
	game.label_at('Ein neuer Run ersetzt deinen gesicherten Durchlauf.\nDeine Sammlung und Statistiken bleiben erhalten.',Vector2(180,340),35,game.GOLD)
	game.button('ZURÜCK',Vector2(180,700),Vector2(450,105),func():game.queue_ui_action(game.main_menu))
	game.button('RUN FORTSETZEN',Vector2(680,700),Vector2(500,105),func():game.queue_ui_action(resume_saved))
	game.button('NEUER RUN',Vector2(1230,700),Vector2(500,105),func():game.queue_ui_action(func():
		var previous=game.saved.active_run;game.saved.active_run={}
		if game.save_game():action.call()
		else:game.saved.active_run=previous;confirm_new(action)))

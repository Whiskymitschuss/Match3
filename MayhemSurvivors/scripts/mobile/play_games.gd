extends RefCounted
const Scores=preload('res://scripts/progression/online_scores.gd')
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var plugin
var config:Dictionary={}
var connected=''
var display_name=''
var request=''
var owner=''
var action=''
var current_run=''
var message=''
var deadline=0
var test_plugin
func _init(g:Node):
	game_ref=weakref(g);config=JSON.parse_string(FileAccess.get_file_as_string('res://data/network/play_games.json'))
	if Engine.has_singleton('RFPlayGames'):plugin=Engine.get_singleton('RFPlayGames');plugin.event.connect(receive)
func configured() -> bool:return config.get('provider')=='google_play' and str(config.get('project_id','')).is_valid_int() and int(config.project_id)>0 and not boards().is_empty()
func boards() -> Dictionary:
	var result={}
	if not config.get('boards') is Dictionary:return result
	for key in config.boards:
		var id=config.boards[key]
		if Scores.valid_key(key) and id is String and id.begins_with('Cgk') and id.length()>=8 and id.length()<=128:result[key]=id
	return result
func bridge():return test_plugin if test_plugin!=null else plugin
func ready() -> bool:return configured() and bridge()!=null
func bound() -> bool:return game.saved.online_scores.enabled and connected!='' and connected==game.saved.online_scores.player_id
func allowed() -> bool:return is_instance_valid(game) and game.state in [game.State.MAIN_MENU,game.State.CHARACTER_SELECT,game.State.VICTORY,game.State.GAME_OVER] and not game.practice.active
func dispose():
	cancel()
	if plugin!=null and plugin.event.is_connected(receive):plugin.event.disconnect(receive)
func refresh():
	if is_instance_valid(game) and game.leaderboards_view:game.leaderboards_view.refresh()
func cancel():request='';owner='';action='';current_run=''
func profile_changed():cancel();connected='';display_name='';message=''
func token(kind:String) -> String:
	request=Crypto.new().generate_random_bytes(16).hex_encode();owner=game.profiles.index.active;action=kind;deadline=Time.get_ticks_msec()+20000;return request
func connect_player():
	if not allowed() or not ready() or request!='':return
	message='Google Play Games wird geöffnet …';bridge().authenticate(true,token('auth'))
func disable_profile():
	if not allowed():return
	cancel();connected='';display_name='';var before=game.saved.online_scores.duplicate(true);game.saved.online_scores=Scores.defaults()
	if not game.save_game():game.saved.online_scores=before;message=game.save_error
	else:message='Veröffentlichung für dieses lokale Profil ausgeschaltet.'
func receive(kind:String,text:String):
	var payload=JSON.parse_string(text)
	if not is_instance_valid(game) or not payload is Dictionary or payload.get('token')!=request or request=='' or owner!=game.profiles.index.active:return
	var previous=action;var run=current_run;cancel()
	call_deferred('refresh')
	if kind=='authenticated' and previous=='auth':
		if not payload.get('player') is String or payload.player.is_empty() or payload.player.length()>128:message='Google Play hat kein gültiges Spielerprofil geliefert.';return
		var before=game.saved.online_scores.duplicate(true)
		if before.player_id!=payload.player and not before.player_id.is_empty():message='Anderes Google-Play-Konto. Veröffentlichung zuerst ausschalten und neu verbinden.';connected='';return
		game.saved.online_scores.player_id=payload.player;game.saved.online_scores.enabled=true
		if not game.save_game():game.saved.online_scores=before;message=game.save_error;return
		connected=payload.player;display_name=str(payload.get('name','Google-Play-Spieler')).left(64);message='Verbunden als '+display_name+'. Neue passende Runs können veröffentlicht werden.'
	elif kind=='score_saved' and previous=='score':
		var before=game.saved.online_scores.duplicate(true);Scores.acknowledge(game.saved,run)
		if not game.save_game():game.saved.online_scores=before;message=game.save_error
		else:message='Ergebnis übermittelt. Google Play behält deinen besten Wert.'
	elif kind=='dialog_opened' and previous=='show':message='Bestenliste in Google Play Games geöffnet.'
	else:connected='';message='Keine Verbindung zu Google Play Games. Dein Spielstand bleibt lokal; ausstehende Ergebnisse bleiben erhalten.'
func tick():
	if request!='' and Time.get_ticks_msec()>deadline:cancel();connected='';message='Verbindung hat zu lange gedauert. Du kannst später erneut verbinden.';call_deferred('refresh')
	if not allowed() or not ready() or request!='' or not game.saved.online_scores.enabled or connected!=game.saved.online_scores.player_id:return
	var queue=game.saved.online_scores.outbox
	if queue.is_empty():return
	var e=queue[0];var ids=boards()
	if not ids.has(e.board) or e.player!=connected:return
	var t=token('score');current_run=e.run;bridge().submit_score(ids[e.board],int(e.score),e.run,connected,t);call_deferred('refresh')
func show_board(key:String):
	if not allowed() or not ready() or request!='' or connected!=game.saved.online_scores.player_id or connected=='' or not boards().has(key):return
	bridge().show_board(boards()[key],connected,token('show'));call_deferred('refresh')
func begin():
	if game.run_mode not in ['campaign','endless']:return
	Scores.begin(game.saved,game.run_session.run_id,game.run_mode,game.arena_id,game.run_difficulty,game.characters[game.selected].id,boards() if ready() else {})
func finish(won:bool):
	Scores.finish(game.saved,game.run_session.run_id,game.run_mode,game.arena_id,game.run_difficulty,game.characters[game.selected].id,won,game.run_time,game.run_waves)

extends RefCounted
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var active=false
var original:Dictionary={}
var previous:Dictionary={}
var hero=0
var arena='scrapyard'
var wave=2
var phase=1
var damage_taken=0.0
var hits=0
var ending=false
func _init(g:Node):game_ref=weakref(g)
func button(value:String,rect:Rect2,action:Callable):return game.button(value,rect.position,rect.size,func():game.queue_ui_action(action))
func show():
	if active or game.state not in [game.State.MAIN_MENU,game.State.CHARACTER_SELECT,game.State.VICTORY,game.State.GAME_OVER]:return
	game.change_state(game.State.CHARACTER_SELECT)
	if game.characters[hero].id not in game.saved.collection.heroes:hero=0
	if not game.Arenas.unlocked(game.saved,arena):arena='scrapyard'
	game.backdrop('BOSS-TRAINING','Echte Angriffe / keine Belohnungen / dein gesicherter Run bleibt erhalten')
	game.UISkin.panel(game,Rect2(100,250,1720,655),game.TEAL)
	game.portrait(Vector2(150,275),hero,1.3,'wardrobe')
	button('FIGHTER: '+game.characters[hero].name,Rect2(825,300,900,90),cycle_hero)
	button('ARENA: '+game.Arenas.definition(arena).name,Rect2(825,420,900,90),cycle_arena)
	button('BOSSWELLE: %d' % wave,Rect2(825,540,900,90),func():wave={2:4,4:6,6:8,8:10,10:2}[wave];show())
	button('STARTPHASE: %d' % phase,Rect2(825,660,900,90),func():phase=phase%3+1;show())
	game.label_at('Trainings-Build: Startwaffe Lv.5 / Lv.15 / Schaden ×2,2 / Angriffstempo ×1,3',Vector2(825,795),26,game.GOLD)
	button('ZURÜCK',Rect2(100,965,530,90),func():game.extras.show())
	button('TRAINING STARTEN',Rect2(1230,965,590,90),func():start(hero,arena,wave,phase))
	game.ui_back_action=func():game.extras.show();game.ui_back_priority=3
func cycle_hero():
	for i in range(1,16):
		var next=(hero+i)%15
		if game.characters[next].id in game.saved.collection.heroes:hero=next;break
	show()
func cycle_arena():
	var all=game.Arenas.IDS
	for i in range(1,11):
		var next=all[(all.find(arena)+i)%10]
		if game.Arenas.unlocked(game.saved,next):arena=next;break
	show()
func start(fighter:int,world:String,boss_wave:int,start_phase:int) -> bool:
	if active or fighter<0 or fighter>=15 or game.characters[fighter].id not in game.saved.collection.heroes or not game.Arenas.unlocked(game.saved,world) or boss_wave not in [2,4,6,8,10] or start_phase not in [1,2,3]:return false
	if game.state not in [game.State.MAIN_MENU,game.State.CHARACTER_SELECT]:return false
	if not game.save_game():return false
	hero=fighter;arena=world;wave=boss_wave;phase=start_phase
	original=game.saved;previous={'selected':game.selected,'arena':game.arena_id,'mode':game.run_mode,'difficulty':game.selected_difficulty}
	game.run_session.wait_for_worker();game.play_games.cancel();game.saved=original.duplicate(true);active=true;ending=false;hits=0;damage_taken=0
	game.change_state(game.State.CHARACTER_SELECT);game.selected=hero;game.arena_id=arena;game.run_mode='practice'
	game.start_run(true);game.wave_number=wave;game.level=15;game.damage_mult=2.2;game.attack_mult*=1.3;game.weapons[0].level=5
	game.prepare_wave();return true
func began():
	if not active:return
	for e in game.enemies:
		if e.kind in ['boss','champion','breaker_axel']:e.hp=e.max_hp*[1.0,.68,.34][phase-1];e.pos=game.player.position+Vector2(330,0)
func save_settings() -> bool:
	if original.settings==game.saved.settings:return true
	var before=original.settings;original.settings=game.saved.settings.duplicate(true)
	if not game.profiles.save_active(original):original.settings=before;game.save_error=game.profiles.error;return false
	game.save_error='';return true
func finish(won:bool):
	if not active or ending:return
	ending=true;game.result_recorded=true;game.recap.close('practice');game.cleanup();game.change_state(game.State.VICTORY if won else game.State.GAME_OVER)
	game.backdrop('TRAINING GESCHAFFT!' if won else 'TRAINING BEENDET','Keine Coins, Rekorde oder Freischaltungen / dein normaler Run bleibt erhalten')
	game.portrait(Vector2(180,290),hero,1.6,'wardrobe')
	game.label_at('BOSSWELLE %d / STARTPHASE %d\n\nZeit %s\nTreffer erhalten %d\nSchaden erhalten %.0f\nSchaden verursacht %.0f' % [wave,phase,game.duration_text(game.run_time),hits,damage_taken,game.dealt],Vector2(825,340),38,game.GOLD)
	button('NOCH EIN VERSUCH',Rect2(825,740,900,110),retry)
	button('TRAINING VERLASSEN',Rect2(825,900,900,100),leave)
	game.ui_back_action=leave;game.ui_back_priority=3;game.sound('victory' if won else 'defeat')
func retry():
	var h=hero;var a=arena;var w=wave;var ph=phase;leave();start(h,a,w,ph)
func leave():
	if not active:return
	save_settings();active=false;ending=false;game.run_session.live=false;game.cleanup()
	game.saved=original;original={};game.apply_profile(game.saved)
	game.selected=previous.selected;game.arena_id=previous.arena;game.run_mode=previous.mode;game.selected_difficulty=previous.difficulty
	game.main_menu()

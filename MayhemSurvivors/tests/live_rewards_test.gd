extends SceneTree
const R=preload('res://scripts/progression/daily_rewards.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func fresh(arena:String='scrapyard',wave:int=6):
	g.test_mode=true;g.selected=1;g.run_mode='campaign';g.selected_difficulty='normal';g.arena_id=arena;g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func actor(kind:String) -> Dictionary:
	g.spawn_enemy(kind);var e=g.enemies.back();e.pos=g.player.position+Vector2(120,0);e.pack_clock=0;return e
func touch(index:int,pos:Vector2,pressed:bool):
	var e=InputEventScreenTouch.new();e.index=index;e.position=g.ui_root.get_global_transform()*pos;e.pressed=pressed;g._input(e)
func drag(index:int,pos:Vector2):
	var e=InputEventScreenDrag.new();e.index=index;e.position=g.ui_root.get_global_transform()*pos;g._input(e)
func run():
	var now=1763337600;var meta=R.defaults(now)
	check(meta.coins==0 and meta.owned.is_empty(),'New wallet empty')
	R.record(meta,{'mode':'tutorial','kills':1000,'waves':10,'skills':9,'arena':'scrapyard','won':true},now)
	check(meta.daily.kills==0,'Training never farms challenges')
	var weekly=R.defaults(now)
	check(not R.claim(weekly,'weekly','explorer',now),'Incomplete weekly cannot pay')
	for arena in ['scrapyard','reactor','docks']:
		R.record(weekly,{'mode':'endless','kills':500,'waves':1,'skills':0,'arena':arena,'won':false},now)
	check(weekly.weekly.arenas.size()==3 and R.claim(weekly,'weekly','explorer',now),'Three distinct arenas unlock explorer')
	check(R.claim(weekly,'weekly','army',now) and weekly.coins==200,'Weekly kill reward pays actual coins')
	check(not R.claim(weekly,'weekly','champion',now),'Endless never counts as campaign victory')
	R.record(weekly,{'mode':'campaign','kills':0,'waves':10,'skills':0,'arena':'docks','won':true},now)
	check(R.claim(weekly,'weekly','champion',now) and weekly.coins==350 and weekly.pass.xp==350,'Campaign weekly victory funds free pass')
	check(not R.claim(weekly,'weekly','champion',now),'Weekly reward only once')
	R.record(weekly,{'mode':'campaign','kills':0,'waves':0,'skills':0,'arena':'foundry','won':false},now)
	check(weekly.weekly.arenas.size()==3,'No exploration credit without surviving a wave')
	R.record(meta,{'mode':'campaign','kills':100,'waves':3,'skills':3,'arena':'scrapyard','won':true},now)
	check(R.claim(meta,'daily','hunt',now) and meta.coins==30 and meta.pass.xp==40,'Earn and claim daily reward')
	check(not R.claim(meta,'daily','hunt',now) and meta.coins==30,'Daily claim once')
	check(R.claim(meta,'daily','waves',now) and R.claim(meta,'daily','skills',now) and meta.pass.xp==100,'Other actual goals fund pass')
	check(R.claim_pass(meta,0) and meta.coins==115 and not R.claim_pass(meta,0),'Pass coins exactly once')
	check(not R.claim_pass(meta,1) and not R.renew_pass(meta),'Locked tiers and premature renewal rejected')
	var coins=meta.coins;R.refresh(meta,now+86400)
	check(meta.daily.kills==0 and meta.daily.claimed.is_empty() and meta.coins==coins and meta.pass.xp==100,'New UTC day resets quests only')
	R.refresh(meta,now+7*86400);check(meta.weekly.kills==0 and meta.weekly.arenas.is_empty(),'New week resets weekly goals')
	meta.pass.xp=850
	for i in range(1,7):check(R.claim_pass(meta,i),'Claim pass tier '+str(i+1))
	check(R.renew_pass(meta) and meta.pass.cycle==2 and meta.pass.xp==150 and meta.pass.claimed.is_empty(),'Renew free pass without losing overflow')
	check(R.claim_pass(meta,0),'New pass has independent claims')
	meta.coins=1000;check(R.buy(meta,'mini_bot') and meta.coins==550 and meta.equipped.buddy=='mini_bot','Permanent item purchase and equip')
	check(not R.buy(meta,'mini_bot') and meta.coins==550,'No duplicate charge')
	check(R.buy(meta,'flame') and meta.coins==230 and meta.equipped.ring=='flame','Independent cosmetic groups')
	check(not R.buy(meta,'bomb_buddy') and meta.coins==230 and not R.equip(meta,'bomb_buddy'),'No negative wallet or locked equip')
	check(not R.buy(meta,'forged'),'Unknown purchase rejected')
	var path='user://live_rewards_test.json';var saved=Save.defaults();saved.meta=meta;Save.save_local(saved,path);var loaded=Save.load_local(path)
	check(loaded.meta.coins==230 and loaded.meta.owned.has('mini_bot') and loaded.meta.equipped.ring=='flame','Actual save preserves wallet and permanent cosmetics')
	var dirty={'coins':-10,'owned':['forged','mini_bot','mini_bot'],'equipped':{'ring':'flame','buddy':'mini_bot'}};var clean=R.clean(dirty,now)
	check(clean.coins==0 and clean.owned==['mini_bot'] and clean.equipped.ring=='' and clean.equipped.buddy=='mini_bot','Corrupt and unowned values sanitized')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	g.character_select(0);touch(1,Vector2(1100,450),true);drag(1,Vector2(850,460));await process_frame;touch(1,Vector2(850,460),false)
	check(g.hero_cursor==1 and g.state==g.State.CHARACTER_SELECT,'Real horizontal hero swipe')
	g.character_select(0)
	var gesture=InputEventScreenTouch.new();gesture.index=8;gesture.position=g.ui_root.get_global_transform()*Vector2(1200,860);gesture.pressed=true;Input.parse_input_event(gesture);await process_frame
	var motion=InputEventScreenDrag.new();motion.index=8;motion.position=g.ui_root.get_global_transform()*Vector2(1230,875);Input.parse_input_event(motion);await process_frame
	gesture=gesture.duplicate();gesture.pressed=false;gesture.position=motion.position;Input.parse_input_event(gesture);await process_frame
	check(g.state==g.State.CHARACTER_SELECT and g.hero_cursor==0,'Actual GUI touch drag inside select button cannot select')
	touch(4,Vector2(1100,450),true);touch(5,Vector2(1200,450),true);drag(4,Vector2(850,450));await process_frame;touch(4,Vector2(850,450),false);touch(5,Vector2(1200,450),false)
	check(g.hero_cursor==0 and g.selection_swipe.blocked.is_empty(),'Multitouch cancels selection gesture and consumes both releases')
	g.character_select(1)
	touch(2,Vector2(1100,450),true);drag(2,Vector2(1110,650));await process_frame;touch(2,Vector2(1110,650),false);check(g.hero_cursor==1,'Vertical drag never selects or advances')
	g.arena_select(0);touch(3,Vector2(1100,450),true);drag(3,Vector2(850,460));await process_frame;touch(3,Vector2(850,460),false)
	check(g.arena_cursor==1 and g.state==g.State.ARENA_SELECT,'Real arena swipe')
	g.selection_shift('arena',-1);check(g.arena_cursor==0,'Accessible arrow alternative')
	for kind in ['bombling','longshot','hexling']:
		fresh();var e=actor(kind);var origin=e.pos;var aim=g.player.position
		g.enemy_pack.velocity(e,Vector2.LEFT,3)
		check(e.pack_stage=='windup' and e.pack_clock==g.enemy_pack.CONFIG[kind].warm,'Full telegraph '+kind)
		g.player.position+=Vector2(0,200);g.enemy_pack.velocity(e,Vector2.LEFT,.5)
		check(e.pack_aim==aim and e.pos==origin,'Locked aim '+kind)
		g.enemy_pack.interrupt(e);check(e.pack_stage=='chase','Interrupt '+kind)
		for i in range(g.enemy_pack.CONFIG[kind].cap-1):g.spawn_enemy(kind)
		check(not g.spawn_enemy(kind),'Enemy cap '+kind)
	fresh();var probe=RandomNumberGenerator.new();var seed_value=0
	for seed in range(1000):
		probe.seed=seed;var roll=probe.randf()
		if roll>=.55 and roll<.63:seed_value=seed;break
	g.rng.seed=seed_value;g.spawn_clock=0;g._physics_process(.01)
	check(g.enemies.any(func(enemy):return enemy.kind=='bombling'),'Actual wave spawner integrates new pack without extra RNG')
	fresh();var e=actor('bombling');g.enemy_pack.velocity(e,Vector2.LEFT,.01);g.enemy_pack.velocity(e,Vector2.LEFT,2);var hp=g.hp;var kills=g.kills;g.enemy_pack.resolve(e)
	check(g.hp<hp and g.kills==kills and not g.enemies.has(e),'Bombling explodes once without free kill rewards')
	g.enemy_pack.resolve(e);check(g.kills==kills,'Already removed suicide cannot duplicate')
	fresh();e=actor('longshot');g.enemy_pack.velocity(e,Vector2.LEFT,.01);g.enemy_pack.velocity(e,Vector2.LEFT,2);g.enemy_pack.resolve(e)
	check(g.shots.filter(func(s):return s.active and s.hostile).size()==1,'Longshot fires actual hostile projectile')
	fresh();e=actor('hexling');g.enemy_pack.velocity(e,Vector2.LEFT,.01);g.enemy_pack.velocity(e,Vector2.LEFT,2);g.enemy_pack.resolve(e)
	check(g.arena_hazards.items.size()==1 and g.arena_hazards.items[0].warm==.8,'Hexling creates real second-stage warning')
	fresh();e=actor('longshot');g.enemy_pack.velocity(e,Vector2.LEFT,.01);g.enemy_pack.velocity(e,Vector2.LEFT,2);e.suds_stun=1.0;g.enemy_pack.resolve(e)
	check(e.pack_stage=='chase' and g.shots.filter(func(s):return s.active and s.hostile).is_empty(),'Stun cancels a release before projectile creation')
	fresh();e=actor('hexling');g.enemy_pack.velocity(e,Vector2.LEFT,.01);g.enemy_pack.velocity(e,Vector2.LEFT,2);g.enemy_pack.interrupt(e);g.enemy_pack.resolve(e)
	check(g.arena_hazards.items.is_empty(),'Knockback interrupts ready-to-release spell')
	fresh();e=actor('longshot');g.enemy_pack.velocity(e,Vector2.LEFT,.01);g.state=g.State.PAUSED;var clock=e.pack_clock;g._physics_process(2);check(e.pack_clock==clock,'New AI freezes during pause')
	for arena in g.Arenas.IDS:
		fresh(arena);g.arena_hazards.items.clear();g.remaining=35;g.arena_events.update(.01)
		check(g.arena_events.active and not g.arena_hazards.items.is_empty(),'Actual arena event '+arena)
		var amount=g.arena_hazards.items.size();g.state=g.State.SHOP;g.arena_events.update(10);check(g.arena_events.age==0,'Event paused in shop '+arena)
		g.state=g.State.COMBAT;g.arena_events.update(4);check(g.arena_hazards.items.size()>amount,'Second announced pulse '+arena)
		g.arena_events.update(4);check(not g.arena_events.active and g.run_events==1,'Event completes once '+arena)
	fresh();g.wave_number=10;g.arena_events.update(60);check(not g.arena_events.active,'No extra event during boss')
	fresh();g.remaining=.001;g._physics_process(.01);check(g.run_waves==1,'Actual wave completion increments quest count')
	g.state=g.State.COMBAT
	for i in range(3):g.hero_ability.clear();g.hero_ability.activate()
	g.kills=100;g.finish(false)
	check(g.saved.meta.daily.kills==100 and g.saved.meta.daily.skills==3 and g.saved.meta.daily.waves==1,'Finished run records real mission counters')
	var before=g.saved.meta.daily.kills;g.finish(false);check(g.saved.meta.daily.kills==before,'Duplicate result never duplicates mission progress')
	var wallet_before=g.saved.meta.coins;g.main_menu();g.reward_hub.show();g.reward_hub.action('claim','hunt');check(g.saved.meta.coins==wallet_before+30,'Real claim button backend saves wallet')
	g.saved.meta.coins=500;g.reward_hub.action('buy','comet');check(g.saved.meta.coins==220 and g.saved.meta.equipped.ring=='comet' and g.coins>=0,'Shop uses separate currency')
	g.reward_hub.show('pass');g.reward_hub.show('weekly');g.reward_hub.show('shop');check(g.ui_root.get_child_count()>10,'All reward tabs are populated')
	g.saved=original;g.save_game();g.queue_free();await process_frame;DirAccess.remove_absolute(path)
	print('LIVE REWARDS RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

extends SceneTree
const C=preload('res://scripts/progression/collection.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const Unlocks=preload('res://scripts/progression/hero_unlocks.gd')
var g
var passed=0
var failed=0
var path='user://garage_integration_test.json'
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.001
func fresh(hero:int=0,spell:String='',rank:int=1):
	g.test_mode=true;g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	g.run_mode='campaign';g.arena_id='scrapyard';g.selected_difficulty='normal';g.selected=hero
	if spell!='':g.saved.collection.levels[spell]=rank;C.equip(g.saved,g.characters[hero].id,spell)
	g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0;g.saved.settings.shop_help_seen=true
func touch(index:int,pos:Vector2,down:bool):
	var event=InputEventScreenTouch.new();event.index=index;event.position=g.ui_root.get_global_transform()*pos;event.pressed=down;g._input(event)
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save();g.garage.save_path=path
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(g.saved.unlocked==['bruiser'],'Only Bruiser in real new profile')
	for id in C.HEROES:check(Unlocks.available(g.saved,id)==(id=='bruiser'),'Real roster gate '+id)
	g.selected=5;g.start_run();check(g.state==g.State.CHARACTER_SELECT,'Locked fighter cannot bypass selection')
	g.main_menu();g.tutorial.start();check(g.state==g.State.COMBAT and g.selected==1 and g.tutorial.active,'Locked Sparky is a training-only loan')
	g.tutorial.stop(true);check(not Unlocks.available(g.saved,'sparky') and not Unlocks.available(g.saved,'kicksy'),'Tutorial does not unlock case fighters')
	g.garage.cases();check(not g.garage.open_case('crew'),'New player has no unearned case');g.saved.collection.tickets.crew=1;g.saved.collection.tickets.style=1;g.saved.collection.seed=18018
	check(g.garage.open_case('crew'),'Real free crew opening succeeds')
	var receipt=g.saved.collection.pending.duplicate(true);var drawn=receipt.id
	check(Unlocks.available(g.saved,drawn) and g.saved.collection.levels.has(C.STARTERS[drawn]),'Case unlocks actual fighter and starter')
	var loaded=Save.load_local(path)
	check(loaded.collection.pending.serial==receipt.serial and loaded.collection.heroes.has(drawn) and loaded.collection.tickets.crew==0,'Result saved before reveal')
	check(not g.garage.open_case('crew') and g.saved.collection.opened==1,'Second opening blocked by outstanding receipt')
	g.saved=loaded;g.garage.cases();check(g.saved.collection.opened==1,'Reopening saved reveal never grants twice')
	check(g.garage.transact('ack','',receipt.serial) and g.saved.collection.pending.is_empty(),'Actual acknowledge transaction')
	check(not g.garage.transact('ack','',receipt.serial),'Duplicate acknowledge rejected')
	var before=g.saved.duplicate(true);g.garage.save_path='user://missing_garage_test_directory_018/state.json'
	check(not g.garage.open_case('style') and g.saved==before,'Failed save restores tickets, ownership, seed, history and wallet')
	g.garage.save_path=path;g.garage.error='';g.saved.meta.coins=60
	g.saved.collection.tickets.arsenal=0;check(g.garage.open_case('arsenal') and g.saved.meta.coins==0,'Paid arsenal spends permanent coins exactly')
	receipt=g.saved.collection.pending.duplicate(true);g.garage.transact('ack','',receipt.serial)
	var legacy=Save.defaults();legacy.erase('collection');legacy.meta.coins=123;legacy.kills=900;legacy.records.sparky.games=2;legacy.records.sparky.kills=100
	Save.save_local(legacy,path);loaded=Save.load_local(path)
	check(loaded.collection.heroes==['bruiser'] and loaded.meta.coins==123 and loaded.records.sparky.kills==100,'Old profile migrates roster but preserves coins and attributed stats')
	check(FileAccess.file_exists(Save.sidecar(path,'pre_garage')),'Pre-garage profile backed up')
	fresh();var state=g.saved.duplicate(true)
	check(not g.garage.transact('open','style') and g.saved==state,'Combat cannot spend or mutate inventory')
	for paused in [g.State.PAUSED,g.State.SHOP,g.State.LEVEL_UP]:
		g.state=paused;check(not g.garage.transact('open','style') and g.saved==state,'Inventory transaction blocked in '+str(paused))
	fresh();g.saved.collection.levels.reactor_plate=3;g.saved.collection.levels.neon_soles=2;g.saved.collection.levels.heart_module=4;g.saved.collection.levels.hard_hat=1;g.saved.collection.levels.hammer=5
	for id in ['reactor_plate','neon_soles','heart_module','hard_hat']:C.equip(g.saved,'bruiser',id)
	g.start_run();g.begin_wave();check(g.max_hp==140 and g.hp==140 and g.armor==3 and g.magnet==102 and near(g.speed,183.6),'Actual combat applies equipped gear once')
	check(near(g.gear_weapon_multiplier('hammer'),1.08),'Actual equipped weapon rank snapshot')
	g.saved.collection.levels.reactor_plate=5;g.saved.collection.loadouts.bruiser.body='';check(g.armor==3 and g.run_loadout.body=='reactor_plate','Run freezes both stats and appearance')
	g.cleanup();g.open_shop();g.wave_number+=1;g.begin_wave();check(g.max_hp==140 and g.armor==3,'Wave change cannot apply gear twice')
	for i in range(8):
		var weapon=['hammer','blaster','splitgun','arc','orbit','mop','bomb','tools'][i];var hero=[0,1,1,1,2,3,4,5][i]
		fresh(hero);g.saved.collection.levels[weapon]=5;C.equip(g.saved,g.characters[hero].id,weapon);g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0
		g.spawn_enemy('grunt');var enemy=g.enemies.back();enemy.pos=g.player.position+Vector2(80,0);enemy.hp=1000;enemy.max_hp=1000;enemy.speed=0
		g.update_weapons(.01)
		if weapon=='bomb':g.bombs.update(.7)
		for j in range(20):g.update_shots(.016)
		var expected=float(g.weapon_data[weapon].damage)*1.08
		if weapon=='splitgun':expected*=3
		if weapon=='hammer':expected*=1.1
		if weapon=='mop':expected*=1.15
		if weapon=='tools':expected*=1.25
		check(near(1000-enemy.hp,expected),'Rank5 adds exactly8 percent to '+weapon)
	fresh(0,'heal_pulse',3);g.hp=60
	check(g.equipped_spell.activate() and near(g.hp,75.6) and g.equipped_spell.cooldown==45,'Heal spell has actual rank-scaled healing and cooldown')
	check(not g.equipped_spell.activate() and near(g.hp,75.6),'Cooldown blocks heal repeat')
	g.equipped_spell.cooldown=0;g.hp=g.max_hp;check(not g.equipped_spell.activate(),'Full-health heal does not spend cooldown')
	fresh(0,'frost_nova',2);g.weapons=[];g.spawn_enemy('tank');var e=g.enemies.back();e.pos=g.player.position+Vector2(100,0);e.hp=1000;e.max_hp=1000;e.speed=100
	check(g.equipped_spell.activate() and e.hp==982 and e.ability_slow_time==2,'Frost has real area damage and slow')
	var at=e.pos;g.update_enemies(.5);check(near(e.pos.distance_to(at),20),'Frost slow changes actual movement')
	for paused in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		g.state=paused;var cd=g.equipped_spell.cooldown;g._physics_process(10);g.equipped_spell.update(10);check(g.equipped_spell.cooldown==cd,'Spell cooldown freezes in '+str(paused))
	fresh(0,'phase_blink',5);g.player.position=Vector2(2350,800);g.move_input=Vector2.RIGHT;var hp=g.hp
	check(g.equipped_spell.activate() and g.player.position.x==2355 and g.equipped_spell.cooldown==32,'Blink clamps to arena and scales cooldown')
	g.hurt(10000);check(g.hp==hp,'Blink grants brief actual invulnerability')
	g.equipped_spell.update(.21);g.hurt(10000);check(g.state==g.State.GAME_OVER,'Blink invulnerability ends')
	fresh(0,'heal_pulse',1);g.hp=50
	touch(3,g.joystick_rest(),true);touch(4,g.equipped_spell.rect().get_center(),true)
	check(g.stick_id==3 and g.equipped_spell.cooldown==45 and g.hp>50,'Multitouch joystick plus separate spell button')
	touch(4,g.equipped_spell.rect().get_center(),false);touch(3,g.joystick_rest(),false);check(g.equipped_spell.touch_ids.is_empty() and g.stick_id==-1,'Both touch captures release cleanly')
	fresh();g.run_waves=3;g.kills=150;g.finish(false);var wallet=g.saved.meta.coins
	check(wallet==18 and g.studio_reward==18,'Actual result grants earned studio coins')
	g.finish(false);check(g.saved.meta.coins==wallet,'Duplicate finish cannot duplicate permanent payout')
	g.main_menu();g.saved.collection.parts=190
	check(g.garage.transact('upgrade','hammer') and g.saved.collection.levels.hammer==2 and g.saved.collection.parts==170,'Actual workshop upgrade transaction')
	loaded=Save.load_local(path);check(loaded.collection.levels.hammer==2 and loaded.collection.parts==170,'Upgrade survives restart')
	g.saved.collection.levels.scrap_vest=1;g.garage.hero=0;check(g.garage.transact('equip','scrap_vest'),'Actual equipment transaction')
	loaded=Save.load_local(path);check(loaded.collection.loadouts.bruiser.body=='scrap_vest','Equipped outfit survives restart')
	for slot in g.garage.SLOT_NAMES:
		g.garage.show(0,slot);check(g.ui_root.get_child_count()>15,'Populated inventory category '+slot)
	for id in ['crew','arsenal','style']:g.garage.chances(id);check(g.ui_root.get_child_count()>8,'Real chance screen '+id)
	g.garage.history();check(g.state==g.State.CHARACTER_SELECT,'Journal remains usable')
	for id in ['head','body','feet','skin','item','spell']:
		for key in C.catalog().items:
			if C.catalog().items[key].slot==id:check(g.GearArt.icon(key)!=null,'Real visible item asset '+key)
	g.saved=original;g.save_game();g.queue_free();await process_frame;DirAccess.remove_absolute(path);DirAccess.remove_absolute(Save.sidecar(path,'pre_garage'))
	print('GARAGE RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

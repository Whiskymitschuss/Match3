extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Unlocks=preload('res://scripts/progression/hero_unlocks.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,text:String):
	if ok:passed+=1;print('PASS ',text)
	else:failed+=1;push_error('FAIL '+text)
func near(a:float,b:float) -> bool:return absf(a-b)<.01
func fresh(spec:String=''):
	g.test_mode=true;g.saved.settings.tutorial_complete=true;g.saved.kills=500;g.selected=4;g.run_mode='campaign';g.arena_id='scrapyard';g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0
	if spec!='':g.weapons[0].level=5;g.weapons[0].spec=spec
func enemy(offset:Vector2) -> Dictionary:
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+offset;e.hp=1000;e.max_hp=1000;e.speed=0;return e
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save()
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(not Unlocks.available(g.saved,'kicksy'),'New profile starts locked')
	g.saved.kills=500;check(not Unlocks.available(g.saved,'kicksy'),'Kills alone insufficient')
	g.saved.settings.tutorial_complete=true;g.saved.kills=499;check(not Unlocks.available(g.saved,'kicksy'),'499 kills insufficient')
	g.saved.endless_records.docks.kills=1;check(Unlocks.available(g.saved,'kicksy'),'Campaign and endless kills combine')
	check(Unlocks.sync(g.saved) and not Unlocks.sync(g.saved),'Unlock once without duplicate ID')
	var path='user://kicksy_test.json';Save.save_local(g.saved,path);var loaded=Save.load_local(path)
	check(loaded.unlocked.has('kicksy') and Unlocks.available(loaded,'kicksy'),'Unlocked hero survives restart')
	g.saved=g.default_save();g.saved.unlocked.append('kicksy');Save.save_local(g.saved,path);loaded=Save.load_local(path)
	check(not loaded.unlocked.has('kicksy'),'Stored ID without earned criteria rejected')
	g.selected=4;g.start_run();check(g.state==g.State.CHARACTER_SELECT,'Direct start cannot bypass lock')
	fresh();check(g.max_hp==100 and near(g.speed,242) and g.weapons[0].id=='bomb','Actual stats include ten percent passive over base220')
	check(g.allowed_weapon_ids()==['bomb'] and g.has_projectile_weapon() and g.valid_upgrade('multi'),'Bomb class and supported upgrades')
	var a=enemy(Vector2(200,0));var b=enemy(Vector2(200,90));var far=enemy(Vector2(200,300));var hp=g.hp
	g.update_weapons(.01);check(g.bombs.pool.filter(func(x):return x.active).size()==1,'Automatic bomb allocated from pool')
	g.bombs.update(.64);check(a.hp==1000,'No hit before actual fuse')
	g.bombs.update(.02);check(a.hp==980 and b.hp==980 and far.hp==1000 and g.hp==hp,'One explosion hits area without self damage')
	check(g.bombs.pool.size()==16 and g.bombs.pool.filter(func(x):return x.active).is_empty(),'Pool slots released after explosion')
	for i in range(20):g.bombs.spawn(g.player.position,g.player.position,1,50)
	check(g.bombs.pool.filter(func(x):return x.active).size()==16 and not g.bombs.spawn(g.player.position,g.player.position,1,50),'Hard pool cap independent of effects quality')
	g.bombs.clear();g.multishot=2;g.weapons[0].clock=0;g.update_weapons(.01)
	check(g.bombs.pool.filter(func(x):return x.active).size()==3,'Multishot produces three real bombs')
	fresh('bombard');a=enemy(Vector2(200,0));g.update_weapons(.01);g.bombs.update(.7)
	check(near(a.hp,956) and g.bombs.queued.size()==3,'Streubombe primary strike plus three delayed events')
	g.bombs.update(.4);check(near(a.hp,916.4) and g.bombs.queued.is_empty(),'Three secondary hits with no recursive explosion')
	fresh('fireball');a=enemy(Vector2(200,0));g.update_weapons(.01);g.bombs.update(.7)
	check(near(a.hp,956) and g.bombs.fields.size()==1 and g.bombs.fields[0].life==3,'Brand field created at detonation, never aged before birth')
	g.bombs.update(.25);check(near(a.hp,952.15),'Brand DPS exact')
	g.bombs.fields.append(g.bombs.fields[0].duplicate());var before:float=a.hp;g.bombs.update(.25)
	check(near(before-a.hp,3.85),'Overlapping fire does not stack')
	g.bombs.update(10);check(g.bombs.fields.is_empty(),'Fields expire even after long frames')
	fresh();a=enemy(Vector2(100,0));b=enemy(Vector2(280,0));var c=enemy(Vector2(450,0));g.hero_ability.activate()
	check(g.hero_ability.cooldown==28 and g.bombs.queued.size()==3,'Real chain ability starts three explosions and cooldown')
	g.bombs.update(.5);check(a.hp==970 and b.hp==970 and c.hp==970,'Chain jumps between three real targets')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		fresh();a=enemy(Vector2(200,0));g.update_weapons(.01);g.state=state;g.bombs.update(2)
		check(g.bombs.pool.filter(func(x):return x.active)[0].age==0 and a.hp==1000,'Bombs frozen in '+str(state))
	for arena in g.Arenas.IDS:
		fresh();g.arena_id=arena;g.start_run();g.wave_number=10;g.begin_wave();var boss=g.enemies[0];boss.pos=g.player.position+Vector2(150,0);boss.hp=1;g.update_weapons(.01);g.bombs.update(1)
		check(g.state==g.State.VICTORY and g.bombs.pool.filter(func(x):return x.active).is_empty(),'Kicksy wins and cleans pool '+arena)
	fresh();g.coins=1000;g.weapons[0].level=4;g.open_shop();check(g.run_items.upgrade('bomb') and g.pending_specialization().id=='bomb','Shop reaches actual development')
	check(g.choose_specialization('bomb','fireball') and g.pending_specialization().is_empty(),'Development selection completes')
	g.saved=g.default_save();g.saved.kills=500;g.main_menu();g.tutorial.start();g.tutorial.step=12;g.tutorial.done=true;g.tutorial.next()
	check(g.saved.unlocked.has('kicksy') and not g.tutorial.active,'Tutorial completion immediately unlocks earned hero')
	g.saved=original;g.save_game();g.queue_free();await process_frame;DirAccess.remove_absolute(path)
	print('KICKSY RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

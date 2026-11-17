extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Records=preload('res://scripts/progression/run_records.gd')
var g
var passed=0
var failed=0
func check(ok:bool,name:String):
	if ok:passed+=1;print('PASS ',name)
	else:failed+=1;push_error('FAIL '+name)
func near(a:float,b:float) -> bool:return absf(a-b)<.01
func _initialize():call_deferred('run')
func fresh(arena:String='scrapyard'):
	g.test_mode=true;g.selected=3;g.arena_id=arena;g.saved.wins=1;g.start_run();g.begin_wave();g.cleanup();g.spawn_clock=999;g.crit=0;g.attack_mult=1;g.player.position=Vector2(1200,800)
func enemy(offset:Vector2,kind:String='grunt') -> Dictionary:
	g.spawn_enemy(kind);var e=g.enemies.back();e.pos=g.player.position+offset;e.hp=1000.0;e.max_hp=1000.0;return e
func button(text:String):
	for child in g.ui_root.get_children():
		if child is Button and child.text==text:return child
	return null
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save()
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(g.characters.size()==6 and g.characters[3].id=='twinkle','Fourth real character')
	fresh();check(g.max_hp==100 and g.speed==210 and g.weapons[0].id=='mop','Specified HP speed and start weapon')
	check(g.allowed_weapon_ids()==['mop'] and not g.can_equip_weapon('hammer') and not g.has_projectile_weapon(),'Exclusive mop class binding')
	check(not g.valid_upgrade('multi') and not g.valid_upgrade('projectile'),'No unsuitable projectile upgrades')
	var front=enemy(Vector2(100,0));var side=enemy(Vector2(70,70));var back=enemy(Vector2(-100,0));var far=enemy(Vector2(350,0))
	g.update_weapons(.01)
	check(near(front.hp,979.3) and near(side.hp,979.3) and back.hp==1000 and far.hp==1000,'Half circle hits multiple front enemies with exact 15 percent bonus')
	check(front.suds_stun==1 and not back.has('suds_stun'),'One second soap stun only on hit targets')
	check(g.twinkle.puddles.size()==1 and g.twinkle.sweeps.size()==1 and g.shots.filter(func(s):return s.active).is_empty(),'Actual spray field and mop sweep without fake bullet')
	var frozen:Vector2=front.pos;g.update_enemies(.5);check(front.pos==frozen and near(front.suds_stun,.5),'Stunned enemy does not move')
	g.player.position=front.pos;g.hurt_clock=0;var hp=g.hp;g.update_enemies(.5);check(g.hp==hp,'Stunned contact cannot deal damage')
	g.twinkle.apply_stun(front,1);check(front.suds_stun==0,'Resistance prevents permanent restun')
	g.update_enemies(.1);check(g.hp<hp,'Contact resumes after stun expires')
	fresh();front=enemy(Vector2(100,0));g.update_weapons(.01);var before:float=front.hp
	g.twinkle.update(.25);check(near(before-front.hp,2.3),'Poison deals eight DPS plus exact area bonus')
	g.twinkle.puddles.append(g.twinkle.puddles[0].duplicate());before=front.hp;g.twinkle.update(.25)
	check(near(before-front.hp,2.3),'Overlapping identical fields never stack poison')
	g.twinkle.puddles[0].power=18.4;before=front.hp;g.twinkle.update(.25)
	check(near(before-front.hp,4.6),'Strongest field wins')
	front.pos+=Vector2(500,0);before=front.hp;g.twinkle.update(.25);check(front.hp==before,'Leaving field avoids poison')
	fresh();front=enemy(Vector2(100,0));g.update_weapons(.01);before=front.hp;g.twinkle.update(8)
	check(near(before-front.hp,27.6) and g.twinkle.puddles.is_empty(),'Long frame clips poison to actual three second lifetime')
	fresh();front=enemy(Vector2(100,0));front.hp=1;g.hp=90;g.kills=18;g.damage_enemy(front,100)
	check(g.kills==19 and g.hp==90,'Nineteenth kill does not heal')
	front=enemy(Vector2(100,0));front.hp=1;g.damage_enemy(front,100);check(g.kills==20 and g.hp==92,'Twentieth kill heals exactly two HP')
	g.damage_enemy(front,100);check(g.hp==92 and g.kills==20,'Duplicate death cannot heal twice')
	g.kills=39;g.hp=99;front=enemy(Vector2(100,0));front.hp=1;g.damage_enemy(front,100);check(g.hp==100,'Heal clamps to maximum HP')
	fresh();var boss=enemy(Vector2(100,0),'boss');g.twinkle.apply_stun(boss,1);check(not boss.has('suds_stun'),'Boss immune to stun')
	var at:Vector2=boss.pos;check(g.hero_ability.activate() and near(g.hero_ability.cooldown,45) and g.twinkle.tornado_left==5,'Real ability activation starts five second tornado and 45 second cooldown')
	check(not g.hero_ability.activate() and not g.hero_ability.invulnerable(),'Tornado cannot spam and grants no invulnerability')
	before=boss.hp;g.twinkle.update(5);check(near(before-boss.hp,138) and boss.pos==at and g.twinkle.tornado_left==0,'Five seconds exact tornado damage; boss never pushed')
	g.hero_ability.update(5);check(near(g.hero_ability.cooldown,40),'Cooldown counts from activation')
	fresh();front=enemy(Vector2(40,0));at=front.pos;g.hero_ability.activate();g.twinkle.update(.25)
	check(front.pos.x>at.x and g.twinkle.tornado_left==4.75,'Normal enemy knocked back by moving tornado')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP,g.State.WAVE_PREPARATION]:
		fresh();front=enemy(Vector2(100,0));g.update_weapons(.01);g.hero_ability.activate();g.state=state
		var life:float=g.twinkle.puddles[0].life;before=front.hp;var time=g.run_time;var cooldown:float=g.hero_ability.cooldown
		g._physics_process(1);g.twinkle.update(1);g.twinkle.attack(g.weapons[0],1)
		check(g.twinkle.tornado_left==5 and g.twinkle.puddles[0].life==life and front.hp==before and g.run_time==time and g.hero_ability.cooldown==cooldown,'All new simulation frozen in '+str(state))
	for quality in ['LOW','MEDIUM','HIGH']:
		fresh();g.saved.settings.quality=quality;boss=enemy(Vector2(100,0),'boss');g.hero_ability.activate();before=boss.hp;g.twinkle.update(1)
		check(near(before-boss.hp,27.6),'Quality does not change damage '+quality)
	for arena in ['scrapyard','reactor']:
		for spec in ['', 'soap_storm','chemical_flood']:
			fresh(arena);g.weapons[0].level=5
			if spec!='':g.weapons[0].spec=spec
			front=enemy(Vector2(100,0));g.update_weapons(.01)
			check(near(front.hp,954.46),'Level five actual mop strike '+arena+spec)
			check(g.twinkle.puddles.size()==1,'Field generated by evolved weapon '+spec)
			if spec=='soap_storm':check(near(front.suds_stun,1.25),'Seifensturm longer stun')
			if spec=='chemical_flood':check(near(g.twinkle.puddles[0].power,32.384) and g.twinkle.puddles[0].life==4,'Chemieflut poison scaling and duration')
		fresh(arena);g.wave_number=10;g.begin_wave();boss=g.enemies[0];boss.pos=g.player.position+Vector2(100,0);boss.hp=1
		g.hero_ability.activate();g.twinkle.update(.25)
		check(g.state==g.State.VICTORY and g.twinkle.puddles.is_empty() and g.twinkle.tornado_left==0,'Real boss victory clears effects '+arena)
		check(g.saved.recent_runs[0].character=='twinkle' and g.saved.recent_runs[0].weapons[0].id=='mop','Result keeps new hero and weapon '+arena)
	fresh();g.hp=1;g.hurt_clock=0;g.hero_ability.activate();g.hurt(100)
	check(g.state==g.State.GAME_OVER and g.twinkle.tornado_left==0,'Death cleans tornado and supports game over')
	fresh();check(g.kills==0 and g.twinkle.puddles.is_empty() and g.hero_ability.cooldown==0,'Restart resets passive and transient state')
	g.weapons[0].level=4;g.coins=1000;g.open_shop();check(g.run_items.upgrade('mop') and g.pending_specialization().id=='mop','Real shop upgrade reaches mandatory evolution')
	check(g.choose_specialization('mop','soap_storm') and g.pending_specialization().is_empty(),'Evolution selection cannot trap shop')
	g.offers=[{'type':'weapon','id':'blaster','price':1}];check(not g.buy_offer(0),'Foreign weapon purchase rejected')
	g.main_menu();g.test_mode=false;g.character_select(3)
	check(button('AUSWÄHLEN')!=null,'Page two exposes real fourth hero card')
	button('AUSWÄHLEN').pressed.emit();check(g.selected==3 and g.state==g.State.ARENA_SELECT,'Fourth selection enters arena menu')
	g.choose_arena('scrapyard');g.begin_wave();g.ability_button.pressed.emit()
	check(g.twinkle.tornado_left==5 and g.state==g.State.COMBAT,'Production state machine and real touch ability button')
	g.test_mode=true;g.character_select(3);g.mastery_screen(3);check(button('TWINKLE')!=null,'Mastery has fourth hero tab')
	g.statistics(3);g.recent_runs_screen(3);check(g.state==g.State.CHARACTER_SELECT,'Statistics and history open without unknown IDs')
	var old=Save.defaults();old.records.erase('twinkle');old.hero_styles.erase('twinkle');old.arena_records.scrapyard.records.erase('twinkle');var path='user://twinkle_migration_test.json'
	Save.save_local(old,path);var loaded=Save.load_local(path)
	check(loaded.records.has('twinkle') and loaded.records.twinkle.games==0 and loaded.arena_records.scrapyard.records.has('twinkle'),'Existing schema three migrates fourth record safely')
	check(loaded.unlocked.has('twinkle') and loaded.hero_styles.twinkle=='classic','Twinkle available with default skin on existing saves')
	g.saved=original;g.save_game()
	g.audio_director.stop()
	for voice in g.sfx_players:voice.stop();voice.stream=null
	g.alert_audio.stop();g.alert_audio.stream=null
	await process_frame;OS.delay_msec(120)
	g.queue_free();await process_frame;OS.delay_msec(120);await process_frame;DirAccess.remove_absolute(path)
	print('TWINKLE RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

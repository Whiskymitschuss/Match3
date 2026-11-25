extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Unlocks=preload('res://scripts/progression/hero_unlocks.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.001
func fresh(spec:String=''):
	g.test_mode=true;g.selected=5;g.run_mode='campaign';g.selected_difficulty='normal';g.arena_id='scrapyard';g.start_run();g.begin_wave();g.spawn_clock=999;g.crit=0
	if spec!='':g.weapons[0].level=5;g.weapons[0].spec=spec
func actor(offset:Vector2,kind:String='grunt') -> Dictionary:
	g.spawn_enemy(kind);var e=g.enemies.back();e.pos=g.player.position+offset;e.hp=1000;e.max_hp=1000;return e
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false);var original=g.saved.duplicate(true);g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	check(g.characters.size()==15 and g.characters[5].id=='steelfist','Sixth hero preserves all previous indices')
	check(Unlocks.available(g.saved,'steelfist') and g.saved.unlocked.has('steelfist'),'Legacy combat fixture has owned Steelfist')
	g.character_select(5)
	for node in g.ui_root.get_children():
		if node is Button and node.text=='AUSWÄHLEN':node.pressed.emit();break
	check(g.selected==5 and g.state==g.State.ARENA_SELECT,'Real selection button selects Steelfist')
	g.character_select(g.characters.size()-1);g.selection_shift('hero',1);check(g.hero_cursor==0,'Swipe carousel wraps after the last of fifteen fighters')
	fresh();g.crit=.05
	check(g.max_hp==208 and g.hp==208 and g.speed==165,'160 base HP plus30 percent produces208, speed165')
	check(near(g.crit,.05) and near(g.attack_mult,1) and g.weapons[0].id=='tools','Crit5 percent and one tool-duo slot')
	check(g.allowed_weapon_ids()==['tools'] and not g.can_equip_weapon('hammer') and not g.can_equip_weapon('blaster'),'Class cannot acquire unrelated weapons')
	check(not g.has_projectile_weapon() and not g.valid_upgrade('multi') and not g.valid_upgrade('projectile'),'Unsupported projectile upgrades excluded')
	check(near(g.steelfist.power(g.weapons[0]),31.25) and near(g.steelfist.cooldown(g.weapons[0]),1.25),'25 base damage plus25 percent, 0.8 attacks per second')
	g.update_weapons(.01);check(g.steelfist.attacks==0,'No attack counter advance without valid target')
	fresh();var a=actor(Vector2(80,0));var rear=actor(Vector2(-80,0));var far=actor(Vector2(400,0))
	for i in range(4):
		g.weapons[0].clock=0;g.update_weapons(.01)
		check(near(a.hp,1000-31.25*(i+1 if i<3 else 4.5)),'Attack damage sequence '+str(i+1))
	check(rear.hp==1000 and far.hp==1000,'Front half-circle ignores rear and distant enemies')
	check(near(a.pos.x,g.player.position.x+135) and g.combat_visuals.rig('tools').double_hit,'Fourth hit displaces and drives two-tool animation')
	check(g.combat_visuals.hand_positions().size()==2 and g.combat_visuals.shoulder_positions().size()==2,'Exactly two animated hands and shoulders')
	fresh();a=actor(Vector2(70,0));a.hp=1;g.steelfist.attacks=3;g.update_weapons(.01)
	check(g.kills==1 and g.loot.size()==1 and not g.enemies.has(a),'Double hit resolves one death and one reward')
	g.damage_enemy(a,999);check(g.kills==1,'Removed double-hit target cannot reward twice')
	fresh();g.hurt(100);check(near(g.hp,118),'All incoming damage reduced by10 percent')
	g.hurt(100);check(near(g.hp,118),'Tank still obeys shared contact-damage cooldown')
	g.hurt_clock=0;g.armor=10;g.hurt(100);check(near(g.hp,37),'Armor then percentage reduction applied once')
	fresh();g.hp=100;g.steelfist.update(4.99);check(g.hp==100,'No regeneration before five combat seconds')
	g.steelfist.update(.01);check(near(g.hp,104.16),'Two percent of current maximum regenerated at five seconds')
	g.steelfist.update(10);check(near(g.hp,112.48),'Long frame processes both regeneration ticks')
	g.apply_upgrade('vital');g.hp=100;g.steelfist.update(5);check(near(g.hp,104.56),'Regen uses upgraded228 max HP')
	g.hp=g.max_hp-1;g.steelfist.update(5);check(g.hp==g.max_hp,'Regen cannot overheal')
	g.hp=0;g.steelfist.update(10);check(g.hp==0,'Regen cannot revive a dead hero')
	fresh();a=actor(Vector2(100,0));far=actor(Vector2(600,0));g.steelfist.attacks=2
	check(g.hero_ability.activate() and g.hero_ability.cooldown==35,'Actual ultimate starts35 second cooldown')
	check(near(a.hp,906.25) and far.hp==1000 and a.steel_stun==2,'300 percent melee damage, two-second area stun')
	check(near(a.pos.x,g.player.position.x+250) and g.steelfist.pressure.size()==1,'Pressure wave has actual knockback and effect')
	check(near(g.steelfist.speed_multiplier(),1.5) and near(g.attack_mult,1) and near(g.steelfist.cooldown(g.weapons[0]),1.25/1.5),'Temporary buff changes attack timing without mutating permanent stats')
	check(not g.hero_ability.activate() and g.run_abilities==1,'Ultimate cannot double-activate')
	for i in range(30):g.steelfist.on_kill()
	check(near(g.steelfist.buff_extension,5) and near(g.steelfist.buff_left,10),'Kill extension capped at five extra seconds')
	g.steelfist.update(10);g.steelfist.on_kill();check(g.steelfist.buff_left==0 and near(g.steelfist.speed_multiplier(),1),'Expired buff cannot be revived by kill')
	fresh();a=actor(Vector2(100,0));a.hp=1;g.hero_ability.activate();check(near(g.steelfist.buff_left,5.2),'Actual ultimate kill extends newly active buff')
	for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
		fresh();a=actor(Vector2(100,0));g.hp=100;g.hero_ability.activate();g.steelfist.regen_clock=4;g.state=state
		var hp=g.hp;var left=g.steelfist.buff_left;var cd=g.hero_ability.cooldown;var at=a.pos
		g._physics_process(3);g.steelfist.update(3)
		check(g.hp==hp and g.steelfist.regen_clock==4 and g.steelfist.buff_left==left and g.hero_ability.cooldown==cd and a.pos==at,'All Steelfist simulation frozen in '+str(state))
	for kind in ['ravox','longshot','spitter']:
		fresh();g.wave_number=6;a=actor(Vector2(100,0),kind)
		if kind=='ravox':a.ravox_stage='dash'
		elif kind=='longshot':a.pack_stage='windup'
		else:a.windup=.2
		g.hero_ability.activate();g.weapons=[];var at=a.pos;g.update_enemies(1)
		check(a.pos==at and near(a.steel_stun,1),'Pressure interrupts and stuns '+kind)
		check(g.shots.filter(func(s):return s.active and s.hostile).is_empty(),'No release during stun '+kind)
	for arena in g.Arenas.IDS:
		fresh();g.arena_id=arena;g.start_run();g.wave_number=10;g.begin_wave();a=g.enemies[0];a.pos=g.player.position+Vector2(150,0);a.hp=2000;a.max_hp=2000;g.crit=0;g.hero_ability.activate();g.weapons=[]
		var at=a.pos;var cd=g.boss_clock;var guardian=g.reactor_guardian.clock
		g.update_enemies(1);g.encounters.update(1)
		check(a.pos==at and g.boss_clock==cd and g.reactor_guardian.clock==guardian and a.steel_stun==1,'Boss movement and attack controllers freeze '+arena)
		g.update_enemies(1);g.update_enemies(.1);check(a.steel_stun==0,'Boss recovers from finite stun '+arena)
		g.enemies[0].hp=1;g.damage_enemy(g.enemies[0],1)
		check(g.state==g.State.VICTORY and g.steelfist.buff_left==0,'Victory cleans buffs and effects '+arena)
	for spec in ['pressure_breaker','ratchet_rush']:
		fresh(spec);a=actor(Vector2(100,0));var expected=g.steelfist.power(g.weapons[0]);g.update_weapons(.01)
		check(near(1000-a.hp,expected),'Real evolved weapon damage '+spec)
		check(near(g.weapons[0].clock,g.steelfist.cooldown(g.weapons[0])),'Real evolved cooldown '+spec)
	fresh();g.saved.settings.shop_help_seen=true;g.coins=2000;g.weapons[0].level=4;g.open_shop()
	check(g.run_items.upgrade('tools') and g.pending_specialization().id=='tools','Actual shop reaches weapon level5')
	check(g.choose_specialization('tools','pressure_breaker') and g.pending_specialization().is_empty(),'Actual development closes and shop remains usable')
	g.shop_view.weapon_details('tools');g.shop_view.stats();check(g.state==g.State.SHOP,'New weapon details and build screen populated')
	g.start_run();check(g.steelfist.attacks==0 and g.steelfist.buff_left==0 and g.steelfist.regen_clock==0 and g.max_hp==208,'Restart resets all hero runtime counters')
	g.begin_wave();g.kills=23;g.finish(false)
	check(g.saved.records.steelfist.games>=1 and g.saved.recent_runs[0].character=='steelfist' and g.saved.recent_runs[0].weapons[0].id=='tools','Result records hero and tool weapon')
	var path='user://steelfist_test.json';Save.save_local(g.saved,path);var loaded=Save.load_local(path)
	check(loaded.records.steelfist.games==g.saved.records.steelfist.games and loaded.hero_styles.steelfist=='classic','Hero records and styles survive JSON roundtrip')
	var legacy=g.saved.duplicate(true);legacy.records.erase('steelfist');legacy.hero_styles.erase('steelfist');legacy.meta.coins=77;Save.save_local(legacy,path);loaded=Save.load_local(path)
	check(loaded.records.steelfist.games==0 and loaded.meta.coins==77 and loaded.records.sparky==g.saved.records.sparky,'0.16 migration adds empty hero record and preserves wallet and old stats')
	g.mastery_screen(5);g.statistics(5)
	var buttons_fit=true
	for node in g.ui_root.get_children():
		if node is Button and node.position.y==235 and node.position.x+node.size.x>1820:buttons_fit=false
	check(buttons_fit,'Seven statistics tabs fit inside touch layout')
	for name in ['steel_swing','ability_pipe_burst','steel_regen']:check(g.audio_director.stream(name).get_length()>.2,'Own audible cue '+name)
	g.saved=original;g.save_game();g.queue_free();await process_frame;DirAccess.remove_absolute(path)
	print('STEELFIST RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

extends SceneTree
var g
var passed=0
var failed=0
var native_touch=false
const IDS=['fault_core','ion_relay','umbra_spool']
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.02
func start(hero:int=0,wave:int=1):
	g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.run_mode='campaign';g.selected_difficulty='normal';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func enemy(offset:Vector2=Vector2(70,0),health:float=10000) -> Dictionary:
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+offset;e.hp=health;e.max_hp=health;e.speed=0;return e
func control(text:String):
	for b in g.ui_root.get_children():
		if b is Button and b.text==text:return b
	return null
func tap(b:Button):
	if not b:check(false,'Expected real touch control');return
	await process_frame;await process_frame
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native_touch:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=9;e.position=at;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var motion=InputEventMouseMotion.new();motion.position=at;root.push_input(motion,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch')
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved);g.saved.settings.shop_help_seen=true;g.saved.settings.reduced_motion=true;g.saved.settings.master=0
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for hero in range(g.characters.size()):
		start(hero)
		for id in IDS:check(g.run_items.valid(id)==(hero==IDS.find(id)),'Class and starting-weapon eligibility '+str(hero)+' '+id)
		g.cleanup();g.open_shop()
		for roll in range(5):
			var mods=g.offers.filter(func(o):return o.type=='item' and IDS.has(o.id))
			check(mods.size()==(1 if hero<3 else 0) and (mods.is_empty() or mods[0].id==IDS[hero]),'Guaranteed relevant module only '+str(hero)+' '+str(roll));g.generate_offers()
	for hero in range(3):
		start(hero);g.cleanup();g.open_shop();var index=-1
		for i in range(g.offers.size()):
			if g.offers[i].type=='item' and g.offers[i].id==IDS[hero]:index=i
		var cost=g.offers[index].price;g.coins=cost-1;check(not g.buy_offer(index),'Cannot buy module without coins')
		g.coins=cost;check(g.buy_offer(index) and g.coins==0 and g.run_items.owned.has(IDS[hero]),'Exact-price real module purchase')
		check(not g.buy_offer(index) and not g.run_items.valid(IDS[hero]),'No double purchase or duplicate')
		g.generate_offers();check(g.offers.all(func(o):return o.id!=IDS[hero]),'Owned class module leaves offer pool')
		g.next_shop_wave();check(g.run_items.owned.has(IDS[hero]) and g.synergies.procs==0,'Module retained, transient effects cleared at next wave')
		g.start_run();check(g.run_items.owned.is_empty() and not g.synergies.active(),'Run restart removes modules')
	for quality in ['LOW','MEDIUM','HIGH']:
		start();g.saved.settings.quality=quality;var a=enemy();var seed=g.rng.state;g.damage_enemy(a,10,'weapon','hammer')
		check(a.hp==9990 and g.synergies.procs==0 and g.rng.state!=seed,'Unowned module leaves original hit/RNG behavior '+quality)
		g.run_items.add('fault_core');check(g.hero_ability.activate(),'Actual shockwave activation '+quality)
		check(g.synergies.tagged(a) and near(a.synergy_ttl,6),'Shockwave prepares surviving targets '+quality)
		a.pos=g.player.position+Vector2(70,0);var hp=a.hp;g.update_weapons(.01)
		check(near(hp-a.hp,24*1.1*1.6) and not g.synergies.tagged(a) and g.synergies.procs==1,'Actual hammer consumes exactly +60 percent '+quality)
		hp=a.hp;g.weapons[0].clock=0;g.update_weapons(.01);check(near(hp-a.hp,24*1.1),'Following hammer returns to normal '+quality)
		g.synergies.mark(a);g.synergies.update(6.01);check(not g.synergies.tagged(a),'Marks expire in combat '+quality)
		for spec in ['quake','crusher']:
			g.weapons=[{'id':'hammer','level':5,'clock':0.0,'spec':spec}];g.synergies.mark(a);hp=a.hp;g.update_weapons(.01)
			check(near(hp-a.hp,24*2.2*1.1*g.Specs.all()[spec].power*1.6),'Hammer development uses same bonus '+spec+' '+quality)
		start(1);g.saved.settings.quality=quality;g.run_items.add('ion_relay');a=enemy(Vector2(150,0));var b=enemy(Vector2(250,0));var c=enemy(Vector2(350,0));var far=enemy(Vector2(560,0))
		g.hero_ability.activate();g.hero_ability.update(.66);check(g.synergies.tagged(a) and g.synergies.tagged(b),'Actual impulse grenade charges surviving targets '+quality)
		var hp_b=b.hp;var hp_c=c.hp;var hp_far=far.hp;hp=a.hp;g.update_weapons(.01);g.update_shots(.2)
		check(near(hp-a.hp,12) and near(hp_b-b.hp,6.6) and near(hp_c-c.hp,6.6) and far.hp==hp_far,'Actual blaster collision chains to exactly two reachable neighbors '+quality)
		check(g.synergies.procs==1 and near(g.synergies.cooldown,.75) and not g.synergies.tagged(a),'Discharge consumes mark and starts global cooldown '+quality)
		g.damage_enemy(b,12,'weapon','blaster');check(g.synergies.procs==1 and g.synergies.tagged(b),'Cooldown prevents a second proc and preserves its mark '+quality)
		g.synergies.update(.76);hp=c.hp;g.damage_enemy(b,12,'weapon','blaster');check(g.synergies.procs==2 and near(hp-c.hp,6.6),'Relay recovers after combat cooldown '+quality)
		g.synergies.clear();g.synergies.mark(a);g.synergies.mark(b);seed=g.rng.state;hp=a.hp;g.damage_enemy(a,10,'synergy','blaster')
		check(near(hp-a.hp,10) and g.synergies.procs==0 and g.rng.state==seed and g.synergies.tagged(a),'Secondary damage cannot crit, consume a mark or re-trigger '+quality)
		g.synergies.clear();g.weapons=[{'id':'arc','level':1,'clock':0.0},{'id':'blaster','level':1,'clock':99.0}];g.update_weapons(.01)
		check(g.synergies.tagged(a) and g.synergies.tagged(b) and g.synergies.procs==0,'Arc primary chains charge targets without triggering the relay '+quality)
		for spec in ['conductor','overcharge']:
			g.synergies.clear();g.weapons[0]={'id':'arc','level':5,'clock':0.0,'spec':spec};g.update_weapons(.01);check(g.synergies.tagged(a),'Arc evolution charges relay '+spec+' '+quality)
		for spec in ['piercer','blast']:
			g.synergies.clear();g.synergies.mark(a);g.synergies.mark(b);g.weapons=[{'id':'blaster','level':5,'clock':0.0,'spec':spec}];g.projectile_pool.clear();hp_b=b.hp;g.update_weapons(.01);g.update_shots(.65)
			check(g.synergies.procs==1 and b.hp<hp_b,'Blaster evolution procs once; pierce and splash cannot loop '+spec+' '+quality)
		start(2);g.saved.settings.quality=quality;g.run_items.add('umbra_spool');a=enemy(Vector2(110,0));b=enemy(Vector2(111,0));g.hero_ability.activate()
		check(near(g.synergies.armed,4),'Actual shadow step arms next blade '+quality)
		hp=a.hp;hp_b=b.hp;g.update_weapons(.01)
		check(near(hp-a.hp,18) and near(hp_b-b.hp,10) and g.synergies.procs==1 and g.synergies.armed==0,'Only first actual orbit contact amplified +80 percent '+quality)
		for spec in ['wide','swift']:
			g.synergies.clear();g.synergies.ability_started('shadow_step');g.weapons=[{'id':'orbit','level':5,'clock':0.0,'spec':spec}];a.orbit_cd=0;a.pos=g.player.position+Vector2(g.Specs.all()[spec].radius,0);b.pos=g.player.position+Vector2(500,0);hp=a.hp;g.update_weapons(.01)
			check(near(hp-a.hp,10*2.2*g.Specs.all()[spec].power*1.8),'Orbit evolution consumes one charged hit '+spec+' '+quality)
		g.synergies.ability_started('shadow_step');g.synergies.update(4.01);check(g.synergies.armed==0,'Unused shadow charge expires '+quality)
		for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			g.state=g.State.COMBAT;g.synergies.ability_started('shadow_step');g.synergies.cooldown=.75;g.state=state;g.synergies.update(9);g._physics_process(9)
			check(g.synergies.armed==4 and g.synergies.cooldown==.75 and g.synergies.before_hit(a,'orbit').is_empty(),'All proc clocks and actions freeze '+str(state)+' '+quality)
		g.state=g.State.COMBAT;g.cleanup();check(g.synergies.armed==0 and g.synergies.cooldown==0 and g.synergies.fx.is_empty(),'Cleanup cancels charge, cooldown and effects '+quality)
	for hero in range(3):
		start(hero);g.run_items.add(IDS[hero]);var a=enemy();g.synergies.mark(a)
		if hero==2:g.synergies.ability_started('shadow_step')
		var hp=a.hp;var expected=g.synergies.armed;g.damage_enemy(a,10,'weapon','splitgun')
		check(near(hp-a.hp,10) and g.synergies.procs==0 and g.synergies.armed==expected,'Wrong weapon cannot consume a combo '+str(hero))
		var weapon=g.weapons[0].id;g.weapons.clear();check(not g.synergies.active(),'Selling required weapon disables module '+str(hero))
		g.weapons=[{'id':weapon,'level':1,'clock':0.0}];check(g.synergies.active(),'Reacquired required weapon re-enables owned module '+str(hero))
		g.cleanup();g.enemies.clear();a=enemy();g.synergies.mark(a);g.synergies.ability_started('shadow_step');g.remaining=0;g._physics_process(.01)
		check(g.state==g.State.SHOP and g.synergies.armed==0 and g.enemies.is_empty(),'Actual timed wave-end clears marks and charge '+str(hero))
	for hero in range(3):
		start(hero,10);g.run_items.add(IDS[hero]);var boss=g.enemies[0];var hp=boss.hp
		if hero==2:g.synergies.ability_started('shadow_step')
		else:g.synergies.mark(boss)
		g.damage_enemy(boss,20,'weapon',g.weapons[0].id)
		var expected=32 if hero==0 else (20 if hero==1 else 36)
		check(near(hp-boss.hp,expected) and g.state==g.State.COMBAT,'Bosses receive bounded combo with existing resistance rules '+str(hero))
	# Death resolution is shared: one XP/coin reward and no second kill from a proc.
	start(1);g.run_items.add('ion_relay');var a=enemy(Vector2(100,0),1);var b=enemy(Vector2(170,0),1);var c=enemy(Vector2(240,0),1);g.synergies.mark(a);var kills=g.kills;var coins=g.coins;var reward=a.coin_reward+b.coin_reward+c.coin_reward
	g.damage_enemy(a,12,'weapon','blaster');check(g.kills==kills+3 and wallet_and_drops()==coins+reward and g.loot.size()==3 and g.enemies.is_empty(),'Proc kills grant each enemy exactly one normal reward')
	g.damage_enemy(a,12,'weapon','blaster');check(g.kills==kills+3 and wallet_and_drops()==coins+reward,'Removed enemy cannot award another proc or reward')
	# Killing a wave boss must exit before any chain damages the next state.
	for wave in [2,10]:
		start(1,wave);g.run_items.add('ion_relay');a=g.enemies[0];a.pos=g.player.position+Vector2(100,0);a.hp=1;b=enemy(Vector2(170,0));g.synergies.mark(a);var hp_b=b.hp;g.damage_enemy(a,12,'weapon','blaster')
		check(g.state in [g.State.SHOP,g.State.LEVEL_UP,g.State.VICTORY] and b.hp==hp_b and g.synergies.fx.is_empty(),'Boss death blocks late chain damage '+str(wave))
	start(2);g.run_items.add('umbra_spool');g.hero_ability.activate();g.hero_ability.dash.clear();g.hp=1;g.hurt_clock=0;g.hurt(1000)
	check(g.state==g.State.GAME_OVER and g.synergies.armed==0,'Player death clears pending combo');g.start_run();check(g.state==g.State.WAVE_PREPARATION and g.synergies.armed==0,'Restart after loss remains usable')
	var record=g.RunRecords.clean_run({'character':'bruiser','items':['fault_core','ion_relay','umbra_spool','fault_core','bad']})
	check(record.items==IDS,'Run-history sanitizer preserves all new IDs once')
	for hero in range(3):
		start(hero);g.run_items.add(IDS[hero]);g.test_mode=false;g.make_hud();g.refresh_hud();await tap(g.synergy_button)
		check(g.state==g.State.PAUSED and control('ZURÜCK')!=null,'Native HUD module opens rules in paused state '+str(hero))
		await tap(control('ZURÜCK'));check(g.state==g.State.COMBAT and is_instance_valid(g.synergy_button),'Rules return resumes combat and restores usable HUD '+str(hero))
		g.test_mode=true;g.cleanup();g.open_shop();g.test_mode=false;await tap(control('KLASSENMODUL / REGELN'))
		check(g.state==g.State.SHOP and control('ZURÜCK')!=null,'Shop module rules use actual control '+str(hero));await tap(control('ZURÜCK'));check(control('KLASSENMODUL / REGELN')!=null and g.state==g.State.SHOP,'Shop rules return restores shop '+str(hero));g.test_mode=true
	for hero in range(3):
		start(hero);g.cleanup();g.coins=500;g.open_shop();var index=g.offers.find(g.offers.filter(func(o):return o.id==IDS[hero])[0]);var price=g.offers[index].price
		var purchase:Button=null
		for node in g.ui_root.get_children():
			if node is Button and node.position.is_equal_approx(Vector2(120+index*435,640)):purchase=node
		g.test_mode=false;await tap(purchase);check(g.run_items.owned.has(IDS[hero]) and g.coins==500-price and g.state==g.State.SHOP,'Actual touch purchases displayed class module once '+str(hero))
		await tap(control('GEGENSTÄNDE (1)'));var entry:Button=null
		for node in g.ui_root.get_children():
			if node is Button and node.position.is_equal_approx(Vector2(100,865)):entry=node
		await tap(entry);check(control('ZURÜCK')!=null and g.state==g.State.SHOP,'Actual inventory touch opens owned module rules '+str(hero));await tap(control('ZURÜCK'));check(control('GEGENSTÄNDE (1)')!=null,'Module details return to usable inventory '+str(hero));g.test_mode=true
	for id in ['combo_fault','combo_ion','combo_umbra']:check(load('res://assets/audio/'+id+'.wav') is AudioStreamWAV,'Own imported combo sound '+id)
	for id in IDS:check(g.run_items.icon(id) is Texture2D,'Own imported module icon '+id)
	g.saved=original;g.save_game();var weak=weakref(g.synergies);g.free();await process_frame;await process_frame;await process_frame;check(weak.get_ref()==null,'Synergy manager has no reference cycle')
	print('SYNERGIES RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)

func wallet_and_drops() -> int:
	var value=int(g.coins)
	for packet in g.loot:value+=int(packet.get('coin',0))
	return value

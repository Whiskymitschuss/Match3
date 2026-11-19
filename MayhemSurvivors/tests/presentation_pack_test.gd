extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const PATH='user://presentation_pack_test.json'
var g
var passed=0
var failed=0
var native_touch=false
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func near(a:float,b:float) -> bool:return absf(a-b)<.02
func start(hero:int,wave:int=1):
	g.main_menu();g.selected=hero;g.arena_id='scrapyard';g.run_mode='campaign';g.start_run();g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0;g.orbit_angle=0
func enemy(at:Vector2=Vector2(120,0),health:float=1000) -> Dictionary:
	g.spawn_enemy('grunt');var e=g.enemies.back();e.pos=g.player.position+at;e.hp=health;e.max_hp=health;e.speed=0;return e
func control(text:String,index:int=0):
	var nodes=g.ui_root.get_children().filter(func(n):return n is Button and n.text==text)
	return nodes[index] if index<nodes.size() else null
func tap(b:Control):
	if not b:check(false,'Expected touch control');return
	await process_frame;await process_frame
	var at:Vector2=b.get_global_transform_with_canvas()*(b.size*.5)
	if native_touch:
		at=root.get_final_transform()*at
		for down in [true,false]:
			var e=InputEventScreenTouch.new();e.index=9;e.position=at;e.pressed=down;Input.parse_input_event(e);await process_frame
	else:
		var m=InputEventMouseMotion.new();m.position=at;root.push_input(m,true);await process_frame
		for down in [true,false]:
			var e=InputEventMouseButton.new();e.position=at;e.global_position=at;e.button_index=MOUSE_BUTTON_LEFT;e.pressed=down;root.push_input(e,true);await process_frame
	await process_frame;await process_frame
func run():
	native_touch=OS.get_cmdline_user_args().has('--native-touch');g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	g.saved=g.default_save();g.saved.settings.master=0;g.saved.settings.reduced_motion=true;g.garage.save_path=PATH;g.world_map.save_path=PATH
	check(AudioServer.get_bus_effect_count(0)==1 and AudioServer.get_bus_effect(0,0) is AudioEffectHardLimiter,'Actual master bus protects music and layered effects from clipping')
	check(g.characters.size()==15 and g.Collection.HEROES.size()==15 and g.hero_ability.data.size()==15,'Fifteen complete data-driven fighters')
	check(g.saved.collection.heroes==['bruiser'],'Only Bruiser starts unlocked')
	preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	for hero in range(11,15):
		start(hero);var c=g.characters[hero]
		check(g.weapon_level(c.weapon)==1 and g.allowed_weapon_ids()==c.allowed_weapons,'Actual class starter and binding '+c.id)
		check(g.CharacterArt.texture(c.id)!=g.CharacterArt.hand_texture() and g.CharacterArt.texture(c.id).get_width()==1254 and g.CharacterArt.shoulders(c.id).size()==2,'Own consistent body and two-hand rig '+c.id)
		check(not g.hero_ability.data[c.id].description.is_empty() and g.hero_ability.activate() and not g.hero_ability.activate(),'Real ability and cooldown '+c.id)
		for state in [g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP]:
			g.state=state;var left=g.crew.active_left();g.crew.update(20);check(near(g.crew.active_left(),left),'New class clocks freeze '+c.id+' '+str(state))
		g.state=g.State.COMBAT;g.cleanup();check(g.crew.cloud.is_empty() and g.crew.drone_left==0 and g.crew.shield==0,'Wave cleanup removes new combat objects '+c.id)
	for quality in ['LOW','MEDIUM','HIGH']:
		start(11);g.saved.settings.quality=quality;var e=enemy();g.damage_enemy(e,10,'weapon','blaster');check(e.hp==990 and e.toxin_left==3,'Viper primary hit applies poison '+quality)
		g.crit=1;var seed=g.rng.state
		for i in range(6):g.crew.update(.5)
		check(near(e.hp,984) and g.rng.state==seed and e.toxin_left==0,'Exactly six poison damage, no secondary crit/RNG '+quality)
		g.crit=0;g.hero_ability.activate();var far=enemy(Vector2(600,0));var hp=e.hp
		g.crew.update(.49);check(e.hp==hp,'Toxin cloud uses bounded half-second ticks '+quality)
		g.crew.update(.01);g.crew.update(3.5);check(near(hp-e.hp,32) and far.hp==1000 and g.crew.cloud.is_empty(),'Cloud actual area, duration and exact damage '+quality)
		start(12);e=enemy();g.update_weapons(.01);var shots=g.shots.filter(func(s):return s.active)
		check(shots.size()==3 and near(shots[0].damage,7*1.12) and near(g.gear_weapon_multiplier('splitgun'),1.12),'Echo real weapon passive and preview use same multiplier '+quality)
		g.hero_ability.activate();check(near(e.hp,964) and near(e.steel_stun,1) and e.pos.distance_to(g.player.position)>240,'Sonic burst deals damage, interrupts and pushes normal enemy '+quality)
		start(12,10);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(120,0);var pos=boss.pos;hp=boss.hp;g.hero_ability.activate()
		check(near(hp-boss.hp,36) and boss.pos==pos and float(boss.get('steel_stun',0))==0,'Boss resists sonic control but takes actual damage '+quality)
		start(13);g.hp=30;g.hero_ability.activate();check(g.hp==50 and g.crew.shield==35,'Nova light pulse heals and creates real shield '+quality)
		g.hurt(40);check(g.hp==45 and g.crew.shield==0 and g.recap.current.received==5,'Shield absorbs before actual HP-loss measurement '+quality)
		g.crew.update(6);check(g.crew.shield_left==0,'Medic barrier expires '+quality)
		start(13);g.hp=30
		for i in range(50):e=enemy(Vector2(300,0),1);g.damage_enemy(e,10)
		check(g.kills==50 and g.hp==36,'Medic passive heals exactly once per twenty-five kills '+quality)
		start(14);g.hp=50;e=enemy();check(near(g.projectile_speed,1.2),'Rivet data-driven projectile bonus '+quality)
		g.hero_ability.activate();g.crew.update(.01);check(g.shots.any(func(s):return s.active and s.weapon=='blaster'),'Drone uses existing projectile pool '+quality)
		g.update_shots(.3);check(e.hp==992,'Drone projectile deals actual collision damage '+quality)
		g.crew.update(5.99);check(near(g.crew.drone_left,0) and g.hp==54,'Drone heals four HP during its finite duration '+quality)
		g.cleanup();check(g.shots.all(func(s):return not s.active),'Drone shots clear at wave end '+quality)
	# Cosmetic finishes have a real purchase/equip path and never alter battle outcomes.
	g.main_menu();g.saved.meta.coins=1000
	for id in ['cyan_core','ember_edge','void_steel','arctic_chrome','toxic_stripe']:
		g.saved.collection.levels.erase(id);g.garage.hero=11;var cost=int(g.Collection.catalog().items[id].price);var balance=g.saved.meta.coins;g.saved.meta.coins=cost-1
		check(not g.garage.transact('skin_buy',id),'Skin cannot spend unavailable coins '+id);g.saved.meta.coins=cost
		check(g.garage.transact('skin_buy',id) and g.saved.meta.coins==0 and g.saved.collection.levels[id]==1,'Exact cosmetic purchase '+id)
		check(not g.garage.transact('skin_buy',id),'Owned skin cannot be charged twice '+id)
		check(g.Collection.equip(g.saved,'viper',id) and g.saved.collection.loadouts.viper.skin==id,'Real compatible finish equip '+id);g.saved.meta.coins=balance
	var baseline=[]
	for id in ['', 'cyan_core','ember_edge','void_steel','arctic_chrome','toxic_stripe']:
		g.saved.collection.loadouts.viper.skin=id;start(11);var target=enemy(Vector2(140,0),1000);g.rng.seed=2611;g.crit=.25;g.update_weapons(.01);g.update_shots(.3);g.crew.update(1)
		var result=[g.dealt,target.hp,g.rng.state,g.kills,g.coins]
		if id=='':baseline=result
		else:check(result==baseline,'Weapon skin leaves damage, RNG, XP and rewards unchanged '+id)
	Save.save_local(g.saved,PATH);var loaded=Save.load_local(PATH);check(loaded.collection.heroes.size()==15 and loaded.collection.loadouts.viper.skin=='toxic_stripe','Old schema safely retains new fighters and equipped skins')
	start(11,2);check(g.audio_director.track=='boss_theme' and g.audio_director.cache.boss_theme.loop,'Actual boss selects new looping boss score');g.pause_game();check(g.audio_director.track=='boss_theme','Pause preserves boss track while ducking')
	for id in ['menu_theme','combat_theme','boss_theme']:check(g.audio_director.cache[id].get_length()>25,'Original arranged score length '+id)
	for id in ['ability_toxin_cloud','ability_sonic_burst','ability_light_pulse','ability_repair_drone','crew_heal','drone_pulse','skin_equip']:check(g.audio_director.stream(id) is AudioStreamWAV,'New imported original effect '+id)
	g.main_menu();g.test_mode=false;await tap(control('EINSTELLUNGEN'));check(control('AUDIO')!=null and control('GRAFIK')!=null and control('STEUERUNG')!=null,'Home touch opens coherent settings tabs')
	var sliders=g.ui_root.get_children().filter(func(n):return n is HSlider);check(sliders.size()==3,'Three independent audio sliders');sliders[1].value=.65;check(near(g.saved.settings.music,.65),'Music slider applies immediately and saves')
	await tap(control('GRAFIK'));await tap(control('CARTOON-SPLATTER: AN'));check(not g.saved.settings.splatter,'Native graphics toggle updates saved setting')
	await tap(control('STEUERUNG'));await tap(control('NEIGUNG: AN'));check(not g.saved.settings.tilt,'Native controls toggle changes only menu movement');await tap(control('HANDBUCH'));await tap(control('ZURÜCK'));check(control('STEUERUNG')!=null and control('TUTORIAL')!=null,'Native handbook returns to the active settings category');await tap(control('ZURÜCK'));check(control('SPIELEN')!=null and control('SAMMLUNG')!=null,'Settings returns to clean usable home')
	await tap(control('SAMMLUNG'));await tap(control('WAFFEN-SKINS'));check(g.garage.slot=='skin' and g.state==g.State.CHARACTER_SELECT,'Native collection exposes actual weapon skin inventory')
	g.saved.collection.levels.erase('arctic_chrome');g.saved.meta.coins=300;g.garage.show(11,'skin',1);await tap(control('KAUFEN / 300 COINS'));check(g.saved.meta.coins==0 and g.saved.collection.levels.has('arctic_chrome'),'Native cosmetic purchase consumes exactly displayed price');await tap(control('AUSRÜSTEN'));check(g.saved.collection.loadouts.viper.skin=='arctic_chrome','Native skin equip updates actual per-fighter loadout')
	g.test_mode=true;start(14);g.pause_game();g.settings(g.pause_menu);g.test_mode=false;await tap(control('STEUERUNG'));check(control('TUTORIAL').disabled and g.state==g.State.PAUSED,'Tutorial cannot interrupt a paused run');await tap(control('ZURÜCK'));await tap(control('FORTSETZEN'));check(g.state==g.State.COMBAT,'Settings back path preserves paused gameplay and resumes safely');g.test_mode=true
	g.saved=original;g.save_game();var refs=[weakref(g.crew),weakref(g.settings_view)];g.free();DirAccess.remove_absolute(PATH);call_deferred('verify_lifetime',refs)
func verify_lifetime(refs:Array):
	await process_frame;await process_frame;await process_frame
	check(refs[0].get_ref()==null and refs[1].get_ref()==null,'New managers release after complete UI lifecycle')
	print('PRESENTATION PACK RESULT ',passed,' passed, ',failed,' failed; native_touch=',native_touch);quit(1 if failed else 0)

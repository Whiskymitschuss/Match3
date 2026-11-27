extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
const Coins=preload('res://scripts/economy/coin_pickups.gd')
const CP=preload('res://scripts/progression/run_checkpoint.gd')
const Collection=preload('res://scripts/progression/collection.gd')
var g
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
 if ok:passed+=1;print('PASS ',label)
 else:failed+=1;push_error('FAIL '+label)
func fresh(arena:String='scrapyard',wave:int=1):
 g.main_menu();g.selected=0;g.arena_id=arena;g.run_mode='campaign';g.start_run(true);g.wave_number=wave;g.begin_wave();g.spawn_clock=999;g.crit=0
func run():
 var path='user://beta_test_identity';Files.clear(path);DirAccess.make_dir_recursive_absolute(path)
 g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=path;root.add_child(g);g.set_physics_process(false)
 preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
 fresh()
 for amount in [1,4,8,25]:check(Coins.tier(amount)==[1,4,8,25].find(amount),'Value-based rarity '+str(amount))
 g.spawn_enemy('grunt');var foe=g.enemies.back();foe.pos=g.player.position+Vector2(200,0);var reward=foe.coin_reward;g.damage_enemy(foe,99999)
 check(g.coins==0 and g.loot.size()==1 and g.loot[0].coin==reward,'Coins really drop before collection')
 g.damage_enemy(foe,99999);check(g.loot.size()==1,'Death cannot duplicate coin packet')
 var packet=g.loot[0];Coins.collect(g,packet);Coins.collect(g,packet)
 check(g.coins==reward and g.earned==reward and packet.coin==0,'Collection idempotently awards exact packet value')
 g.loot=[{'pos':g.player.position+Vector2(300,0),'xp':3,'coin':25}]
 var cp=CP.capture(g,g.profiles.index.active,'identity-coin')
 check(not CP.unpack(cp).is_empty(),'Physical coin packet survives checkpoint validation')
 g.run_session.test_enabled=true
 var persisted=g.save_game();var loaded=preload('res://scripts/autoload/save_manager.gd').load_local(g.active_save_path())
 g.saved=loaded;var resumed=g.run_session.resume_saved()
 check(persisted and resumed and g.state==g.State.PAUSED and g.loot.size()==1 and g.loot[0].coin==25 and g.loot[0].xp==3 and g.coins==reward,'Physical coin state really persists and resumes from local profile')
 g.resume()
 g.remaining=.001;g._physics_process(.01)
 check(g.state==g.State.SHOP and g.coins==reward+25,'Wave completion banks remaining real coins before cleanup')
 for id in ['grunt','runner','tank']:
  fresh();g.spawn_enemy(id);foe=g.enemies.back();foe.pos=g.player.position+Vector2(65,0);foe.core_clock=0;var hp=g.hp
  g.core_attacks.velocity(foe,Vector2.ZERO,.01)
  check(foe.core_stage=='windup' and g.hp==hp,'No immediate damage during warning '+id)
  g.pause_game();var clock=foe.core_clock;g._physics_process(2);check(foe.core_clock==clock,'Warning clock freezes on pause '+id);g.resume()
  if id=='grunt':
   g.player.position+=Vector2(0,180);g.core_attacks.velocity(foe,Vector2.ZERO,1)
   check(g.hp==hp and foe.core_stage=='recovery','Bite can be dodged and creates recovery window')
  elif id=='runner':
   g.core_attacks.velocity(foe,Vector2.ZERO,1);check(foe.core_stage=='pounce','Runner releases a real directed pounce')
   var from:Vector2=foe.pos;foe.pos=g.player.position;g.core_attacks.after_move(foe,from);var after=g.hp;g.hurt_clock=0;g.core_attacks.after_move(foe,from)
   check(after<hp and g.hp==after,'Pounce can hit only once per attack')
  else:
   g.core_attacks.velocity(foe,Vector2.ZERO,2);check(g.united.enemies.hazards.size()==1,'Tank releases a real ground hazard')
 var final_orders=[]
 for arena in g.Arenas.IDS:
  fresh(arena,10);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(230,0);var b=g.united.bosses
  var pair=b.attack_order(boss);check(pair.size()==4 and pair[0]!=pair[1] and not final_orders.has(pair),'Distinct final-boss repertoire '+arena);final_orders.append(pair)
  for id in [pair[0],pair[1]]:
   b.clear();b.clock=0;b.pattern=0 if id==pair[0] else 1;b.update(.01)
   check(b.stage=='windup' and b.attack==id and b.clock>=1.5 and g.boss_warning==b.signatures.NAMES[id],'Full named telegraph '+id)
   var rays=b.signatures.rays(id);b.update(b.clock+.01)
   if id=='storm_spiral':
    check(b.stage=='salvo','Spiral is a timed volley state');b.update(.02)
    var saved=CP.capture(g,g.profiles.index.active,'identity-salvo');check(not CP.unpack(saved).is_empty() and boss.sig_left==4,'Spiral counters serialize mid-salvo')
   elif not rays.is_empty():
    var shots=g.shots.filter(func(s):return s.active and s.weapon=='sig_'+id)
    check(shots.size()==rays.size(),'Telegraphed ray count equals actual projectiles '+id)
    for i in range(shots.size()):check(shots[i].vel.normalized().is_equal_approx(rays[i].dir),'Warning direction matches shot '+id+' '+str(i))
   else:check((not g.united.enemies.hazards.is_empty() or not g.arena_mechanics.hazards.is_empty()),'Ground signature has actual hazard '+id)
   g.united.enemies.clear()
 for wave in [2,4,8]:
  fresh('scrapyard',wave);var boss=g.enemies[0];boss.pos=g.player.position+Vector2(240,0);var b=g.united.bosses
  for id in b.attack_order(boss):check(b.signatures.owns(id),'Intermediate boss owns specialised pattern '+str(wave)+' '+id)
 for hero in range(15):
  fresh();g.selected=hero;g.vfx.clear();g.vfx.ability(g.hero_ability.definition().id,g.player.position)
  check(g.vfx.events.any(func(e):return e.kind=='hero_signature' and e.hero==g.characters[hero].id),'Hero-specific motif '+str(hero))
 for id in ['coin_epic','crit_punch','signature_blast']:check(g.audio_director.cache.has(id) and g.audio_director.cache[id].get_length()>0,'Original audible asset '+id)
 for i in range(100):g.hit_feedback.damage(g.player.position,500,true)
 check(g.hit_feedback.numbers.filter(func(n):return n.get('critical',false)).size()==6,'Critical readouts remain capped under heavy multishot')
 var seen={}
 for seed_value in range(1,61):
  var save=g.default_save();save.collection.seed=seed_value;save.collection.tickets.crew=1
  var receipt=Collection.open_case(save,'crew');seen[receipt.id]=true
  check(not receipt.is_empty() and save.collection.tickets.crew==0 and Collection.open_case(save,'crew').is_empty(),'Case transaction cannot charge twice '+str(seed_value))
 check(seen.size()>5,'Different seeds yield varied weighted case results')
 g.free();await process_frame;Files.clear(path);print('COMBAT IDENTITY RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

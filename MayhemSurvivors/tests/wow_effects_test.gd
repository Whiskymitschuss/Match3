extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
var g
var passed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
 if not ok:push_error(label);quit(1);return
 passed+=1;print('PASS ',label)
func run():
 var path='user://beta_test_wow';Files.clear(path);DirAccess.make_dir_recursive_absolute(path)
 g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=path;root.add_child(g);g.set_physics_process(false)
 g.start_run(true);g.begin_wave();var state=g.rng.state;var hp=g.hp;var clock=g.remaining
 for hero in range(15):
  g.selected=hero;g.vfx.clear();g.vfx.ability(g.hero_ability.definition().id,g.player.position)
  check(g.vfx.events.any(func(e):return e.kind=='power_burst' and e.color==Color(g.hero_ability.definition().color)),'Hero burst uses real palette '+str(hero))
 g.selected=0;g.vfx.clear();g.vfx.explosion(g.player.position,120,Color.ORANGE)
 check(g.vfx.events.any(func(e):return e.kind=='impact_wave') and g.vfx.events.any(func(e):return e.kind=='explosion'),'Explosion combines blast and pressure ring')
 for quality in ['LOW','MEDIUM','HIGH']:
  g.saved.settings.quality=quality;g.vfx.clear();g.vfx.shot('blaster',Vector2.RIGHT)
  check(g.vfx.events.any(func(e):return e.kind=='speed_slice')==(quality!='LOW'),'Gunfire quality gate '+quality)
  for i in range(100):g.vfx.ability('shockwave',g.player.position)
  check(g.vfx.events.size()<=g.vfx.limits().events and g.vfx.particles.size()<=g.vfx.limits().particles,'Effect budget holds '+quality)
 check(g.hp==hp and g.remaining==clock and g.rng.state==state,'Cosmetics preserve health, timers and gameplay RNG')
 g.vfx.update(2);check(g.vfx.events.is_empty(),'Transient accents expire')
 g.free();await process_frame;Files.clear(path);print('WOW EFFECTS RESULT ',passed,' passed, 0 failed');quit()

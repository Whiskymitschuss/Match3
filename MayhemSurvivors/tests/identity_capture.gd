extends SceneTree
const Files=preload('res://tests/beta_test_files.gd')
var g
func _initialize():call_deferred('run')
func capture(name:String):
 g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
 root.get_texture().get_image().save_png('res://tests/'+name+'.png')
func start(hero:int=0,arena:String='scrapyard',wave:int=1):
 g.main_menu();g.selected=hero;g.arena_id=arena;g.run_mode='campaign';g.start_run(true);g.wave_number=wave;g.begin_wave();g.camera.reset_smoothing();g.camera.force_update_scroll();g.set_physics_process(false)
func run():
 var path='user://beta_test_identity_capture';Files.clear(path);DirAccess.make_dir_recursive_absolute(path)
 g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;g.profile_root=path;root.add_child(g);g.set_physics_process(false);g.saved.settings.master=0
 preload('res://tests/legacy_collection.gd').unlock_all(g.saved);preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
 start()
 for i in range(3):
  g.spawn_enemy(['grunt','runner','tank'][i]);var e=g.enemies.back();e.pos=g.player.position+Vector2(-180+i*180,-100);e.core_clock=0;g.core_attacks.velocity(e,Vector2.ZERO,.01)
 for i in range(4):g.loot.append({'pos':g.player.position+Vector2(-130+i*90,125),'xp':0,'coin':[1,4,8,25][i]})
 g.hit_feedback.damage(g.player.position+Vector2(120,-90),248,true);g.hero_ability.activate();g.vfx.update(.13);g.combat_visuals.update(.016);g.refresh_hud()
 await capture('identity_combat')
 for arena in ['crystal','storm']:
  start(8,arena,10);var b=g.united.bosses;var boss=g.enemies[0];boss.pos=g.player.position+Vector2(280,-40);b.clock=0;b.update(.01);g.refresh_hud()
  await capture('identity_'+arena+'_warning')
  b.update(b.clock+.01)
  if b.stage=='salvo':b.update(.02)
  g.update_shots(.4);g.vfx.update(.08)
  await capture('identity_'+arena+'_attack')
 g.united.bosses.intro();await capture('identity_boss_intro')
 for hero in range(15):
  start(hero);g.vfx.ability(g.hero_ability.definition().id,g.player.position);g.vfx.update(.15);g.queue_redraw();await process_frame;await process_frame;await RenderingServer.frame_post_draw
  if hero==3:root.get_texture().get_image().save_png('res://tests/identity_twinkle.png')
 g.saved.collection.tickets.crew=1;g.garage.cases();g.garage.open_case('crew');await process_frame
 # test_mode skips animation; render a real committed receipt with production painter.
 g.backdrop('DEIN FUND WARTET','Dein gespeicherter Fund wird geöffnet.')
 var fx=Control.new();fx.set_script(preload('res://scripts/ui/case_opening.gd'));fx.garage=g.garage;fx.case_id='crew';fx.revision=g.ui_revision;fx.age=1.05;fx.set_process(false);fx.mouse_filter=Control.MOUSE_FILTER_IGNORE;g.ui_root.add_child(fx)
 await capture('identity_case')
 g.free();await process_frame;Files.clear(path);quit()

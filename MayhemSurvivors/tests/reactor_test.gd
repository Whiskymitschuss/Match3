extends SceneTree
const Save=preload('res://scripts/autoload/save_manager.gd')
const Arenas=preload('res://scripts/core/arena_catalog.gd')
const Records=preload('res://scripts/progression/run_records.gd')
var passed=0
var failed=0
var g
func check(ok: bool, message: String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate()
	g.test_mode=true
	root.add_child(g)
	preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	g.saved=Save.defaults();preload('res://tests/legacy_collection.gd').unlock_all(g.saved)
	check(not g.choose_arena('reactor') and g.arena_id=='scrapyard','Fresh profile cannot enter locked reactor')
	check(not g.choose_arena('invalid'),'Unknown arena rejected')
	g.character_select()
	g.arena_select()
	check(g.state==g.State.ARENA_SELECT,'Character to arena selection connected')
	g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
	g.saved.kills=1000
	Arenas.sync(g.saved)
	check(Arenas.unlocked(g.saved,'reactor') and g.saved.unlocked_styles.has('gold') and g.saved.unlocked_styles.has('mayhem'),'Existing win and kills unlock arena and cosmetic rewards')
	check(g.choose_arena('reactor') and g.waves.size()==10 and g.state==g.State.WAVE_PREPARATION,'Reactor selection starts full ten-wave configuration')
	g.wave_number=3
	g.begin_wave()
	g.player.position=Vector2(600,800)
	g.hurt_clock=0
	var hp=g.hp
	g.arena_hazards.update(8)
	check(g.arena_hazards.items.size()==1,'Reactor wave generates bounded timed lane')
	# Newly scheduled hazard must retain its entire warning, independent of frame duration.
	check(g.hp==hp,'A newly spawned lane never deals immediate damage')
	g.arena_hazards.clear()
	g.arena_hazards.lane(true,600,52,1.6,.65,10)
	g.arena_hazards.update(1.59)
	check(g.hp==hp,'Lane warning causes no damage')
	g.arena_hazards.update(.02)
	check(g.hp==hp-10,'Active lane damages player on announced geometry')
	g.arena_hazards.update(.1)
	check(g.hp==hp-10,'Hazard obeys shared damage invulnerability')
	var age=g.arena_hazards.items[0].age
	var time=g.run_time
	g.pause_game()
	g._physics_process(.5)
	check(g.run_time==time and g.arena_hazards.items[0].age==age,'Pause freezes reactor warning and run timer')
	g.resume()
	g.level_up()
	g._physics_process(.5)
	check(g.arena_hazards.items[0].age==age,'Level-up freezes hazards')
	g.change_state(g.State.COMBAT)
	g.open_shop()
	g._physics_process(.5)
	check(g.arena_hazards.items[0].age==age,'Shop freezes hazards')
	g.start_run()
	check(g.arena_hazards.items.is_empty(),'Restart clears active reactor hazards')
	g.wave_number=10
	g.begin_wave()
	var boss=g.enemies[0]
	check(boss.max_hp==7560 and boss.speed==62,'Reactor boss uses strengthened HP and unchanged movement')
	boss.pos=Vector2(1500,800)
	g.reactor_guardian.update(3.01)
	check(g.reactor_guardian.stage=='cross' and g.arena_hazards.items.size()==2,'Cross laser announces both actual damage lanes')
	check(g.arena_hazards.items[0].age==0 and g.reactor_guardian.stationary(),'Cross windup starts at zero and guardian holds warning origin')
	var origin=boss.pos
	g.update_enemies(.1)
	check(boss.pos==origin,'Guardian does not chase during fixed laser warning')
	g.reactor_guardian.update(2.2)
	g.arena_hazards.clear()
	g.reactor_guardian.update(2.01)
	check(g.reactor_guardian.stage=='bombs' and g.arena_hazards.items.size()==3,'Next attack creates three preannounced ground bombs')
	var locked=g.arena_hazards.items[1].pos
	g.player.position+=Vector2(100,100)
	check(g.arena_hazards.items[1].pos==locked,'Mortar targets remain fixed after player moves')
	g.reactor_guardian.update(2)
	g.reactor_guardian.update(2.01)
	check(g.reactor_guardian.stage=='fan_warning','Third attack has its own directed fan warning')
	var before=active_shots()
	g.reactor_guardian.update(1.11)
	for i in range(3):g.reactor_guardian.update(.19)
	check(active_shots()-before==12 and g.reactor_guardian.stage=='recovery','Directed fan emits four bursts and returns to recovery')
	g.damage_enemy(boss,100000)
	check(g.state==g.State.VICTORY and g.enemies.is_empty() and active_shots()==0 and g.arena_hazards.items.is_empty(),'Boss victory cleans enemies, projectiles and hazards')
	check(g.saved.arena_records.reactor.wins==1 and g.saved.recent_runs[0].arena=='reactor','Result records actual arena once')
	check(g.saved.unlocked_styles.has('reactor'),'Reactor victory unlocks cosmetic seal')
	g.finish(true)
	check(g.saved.arena_records.reactor.wins==1,'Duplicate finish cannot duplicate arena records')
	g.start_run()
	g.wave_number=10
	g.begin_wave()
	g.remaining=.001
	g._physics_process(.01)
	check(g.state==g.State.GAME_OVER,'Reactor boss timeout loses run')
	g.start_run()
	g.begin_wave()
	g.hurt_clock=0
	g.hurt(10000)
	check(g.state==g.State.GAME_OVER,'Reactor lethal damage loses run')
	for arena in Arenas.IDS:
		for hero in range(3):
			g.arena_id=arena
			g.selected=hero
			g.start_run()
			for wave in range(1,11):
				g.begin_wave()
				check(g.state==g.State.COMBAT and g.wave_number==wave,arena+' hero %d wave %d starts' % [hero,wave])
				if wave<10:
					g.spawn_clock=100
					if g.breaker.scheduled():
						g.damage_enemy(g.breaker.actor(),100000)
						while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
					else:g.remaining=.001;g._physics_process(.01)
					check(g.state==g.State.SHOP and g.offers.size()==4,arena+' wave %d connects to shop' % wave)
					g.wave_number+=1
					g.prepare_wave()
				else:g.damage_enemy(g.enemies[0],100000)
			check(g.state==g.State.VICTORY and g.saved.recent_runs[0].arena==arena,arena+' hero %d completes connected flow' % hero)
	g.arena_id='scrapyard'
	g.start_run()
	g.wave_number=3
	g.begin_wave()
	g.arena_hazards.update(100)
	check(g.arena_hazards.items.is_empty(),'Classic arena never creates reactor hazards')
	g.wave_number=10
	g.begin_wave()
	check(g.enemies[0].max_hp==6000,'Classic Overlord receives the requested stronger boss HP')
	g.main_menu()
	for arena in ['all','scrapyard','reactor']:
		g.statistics(1,arena)
		g.recent_runs_screen(1,99,arena)
	g.challenges_screen()
	check(true,'All arena statistics, history filters and cosmetic screen render without exceptions')
	var path='user://reactor_migration_test.json'
	var legacy=Save.defaults()
	legacy.version=2
	legacy.games=15
	legacy.wins=1
	legacy.kills=602
	legacy.records.sparky.games=15
	legacy.records.sparky.wins=1
	legacy.recent_runs=[{'character':'sparky','won':true,'wave':10}]
	legacy.erase('arena_records')
	legacy.erase('unlocked_arenas')
	legacy.erase('unlocked_styles')
	Save.save_local(legacy,path)
	var loaded=Save.load_local(path)
	check(loaded.version==3 and loaded.games==15 and loaded.wins==1,'Schema-2 save upgrades without erasing totals')
	check(loaded.arena_records.scrapyard.games==15 and loaded.arena_records.scrapyard.records.sparky.wins==1 and loaded.arena_records.reactor.games==0,'Legacy records attributed only to original arena')
	check(loaded.recent_runs[0].arena=='scrapyard' and Arenas.unlocked(loaded,'reactor'),'Legacy history defaults to classic and past victory grants unlock')
	check(FileAccess.file_exists(Save.sidecar(path,'v2.backup')),'Schema-2 original backup written')
	loaded.settings.aura='gold'
	Save.save_local(loaded,path)
	loaded=Save.load_local(path)
	check(loaded.settings.aura=='gold' and loaded.arena_records.scrapyard.games==15,'Arena records and equipped reward survive restart')
	check(Records.clean_run({'character':'sparky','arena':'broken'}).is_empty(),'Invalid arena history rejected')
	for target in [path,Save.sidecar(path,'v2.backup')]:DirAccess.remove_absolute(target)
	g.queue_free()
	await process_frame
	print('REACTOR RESULT ',passed,' passed, ',failed,' failed')
	quit(0 if failed==0 else 1)
func active_shots() -> int:
	var count=0
	for s in g.shots:
		if s.active:count+=1
	return count

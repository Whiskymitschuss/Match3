extends SceneTree
const W=preload('res://scripts/progression/world_progress.gd')
const S=preload('res://scripts/autoload/save_manager.gd')
var g
var passed=0
var failed=0
const PATH='user://world_map_test_020.json'
func _initialize():call_deferred('run')
func check(value:bool,what:String):
	if value:passed+=1;print('PASS ',what)
	else:failed+=1;push_error('FAIL '+what)
func clean_profile():
	g.test_mode=true;g.saved=S.defaults();g.selected=0;g.hero_cursor=0;g.arena_id='scrapyard';g.run_mode='campaign';g.selected_difficulty='normal';g.world_map.error='';g.world_map.notice='';g.world_map.save_path=PATH;g.garage.save_path=PATH;g.main_menu();g.character_select()
func final_boss_victory(arena:String,difficulty:String='normal'):
	g.arena_id=arena;g.selected_difficulty=difficulty;g.run_mode='campaign';g.start_run();g.wave_number=10;g.begin_wave();g.crit=0;g.damage_enemy(g.enemies[0],1000000000)
func button_named(id:String) -> Button:
	for n in g.ui_root.get_children():
		if n is Button and n.name==id:return n
	return null
func touch(index:int,at:Vector2,pressed:bool):
	var event=InputEventScreenTouch.new();event.index=index;event.pressed=pressed;event.position=g.ui_root.get_global_transform()*at;g._input(event)
func generic_upgrade(saved:Dictionary) -> bool:return preload('res://scripts/progression/collection.gd').upgrade(saved,'hammer')
func run():
	var saved=S.defaults()
	check(saved.world_progress.unlocked==['scrapyard'] and saved.world_progress.cleared.is_empty() and saved.world_progress.claimed.is_empty(),'Fresh profile opens only first world')
	for id in W.ORDER:check(W.available(saved,id)==(id=='scrapyard'),'Fresh access '+id)
	check(not W.available(saved,'forged') and W.next_world('forged')=='' and W.previous_world('scrapyard')=='','Unknown ids and route edges rejected')
	check(not W.claim(saved,'scrapyard'),'Cannot claim before campaign win')
	for args in [['scrapyard','campaign',false,10],['scrapyard','campaign',true,9],['scrapyard','endless',true,10],['scrapyard','tutorial',true,10],['reactor','campaign',true,10],['forged','campaign',true,10]]:
		check(not W.complete(saved,args[0],args[1],args[2],args[3]),'Invalid completion has no effect '+str(args))
	S.save_local(saved,PATH);var loaded=S.load_local(PATH)
	check(loaded.world_progress==saved.world_progress and not W.available(loaded,'docks'),'New save roundtrip stays locked, never mistaken for legacy')
	for i in range(4):
		var id:String=W.ORDER[i]
		check(W.complete(saved,id,'campaign',true,10),'First real campaign completion '+id)
		check(W.available(saved,id) and (i==3 or W.available(saved,W.ORDER[i+1])),'Completion opens immediate next world '+id)
		check(saved.world_progress.unlocked.size()==mini(4,i+2),'No further world skipped '+id)
		check(W.eligible(saved,id) and not W.complete(saved,id,'campaign',true,10),'One global first-clear across difficulties '+id)
		var seed=saved.collection.seed
		check(W.claim(saved,id) and saved.collection.seed==seed,'Exact claim without consuming case RNG '+id)
		var before=saved.duplicate(true);check(not W.claim(saved,id) and saved==before,'Repeated claim cannot duplicate '+id)
	S.save_local(saved,PATH);loaded=S.load_local(PATH)
	check(loaded.world_progress.claimed.size()==4 and loaded.meta.coins==280 and loaded.meta.earned==280 and loaded.collection.parts==175,'All once-only rewards survive reload exactly')
	check(loaded.collection.tickets=={'crew':3,'arsenal':3,'style':2},'All five reward tickets added to existing starter tickets')
	var workshop=S.defaults();workshop.collection.parts=loaded.collection.parts
	for i in range(3):check(generic_upgrade(workshop),'Earned first-clear parts fund permanent hammer upgrade '+str(i+1))
	check(workshop.collection.levels.hammer==4 and workshop.collection.parts==65 and not generic_upgrade(workshop),'Rewards fund rank four without skipping final workshop cost')
	var first_reward=S.defaults();preload('res://scripts/progression/collection.gd').run_reward(first_reward,'campaign',10,0,true);W.complete(first_reward,'scrapyard','campaign',true,10);W.claim(first_reward,'scrapyard')
	check(first_reward.meta.coins>=preload('res://scripts/progression/collection.gd').catalog().cases.crew.price and first_reward.collection.parts==20,'First victory affords a crew case and first weapon rank even without kill bonus')
	for field in ['coins','earned','parts','ticket']:

		var capped=S.defaults();W.complete(capped,'scrapyard','campaign',true,10)
		if field=='parts':capped.collection.parts=1000000000
		elif field=='ticket':capped.collection.tickets.crew=1000000000
		else:capped.meta[field]=1000000000
		var before=capped.duplicate(true);check(not W.claim(capped,'scrapyard') and capped==before,'Full reward is never truncated at '+field+' cap')
	var malformed=W.migrate(S.defaults(),{'version':1,'unlocked':['nope','reactor','reactor',4],'cleared':['reactor','reactor','nope'],'claimed':['foundry','reactor','reactor']})
	check(malformed.cleared==['reactor'] and malformed.claimed==['reactor'] and malformed.unlocked.has('docks'),'Invalid world ids, duplicates and unearned claims sanitized')
	var old=S.defaults();old.erase('world_progress');old.meta.coins=133;old.collection.parts=77;old.collection.heroes.append('sparky');old.collection.levels.blaster=4;old.collection.loadouts.sparky.weapon='blaster';old.wins=2;old.games=4;old.arena_records.reactor.games=1;old.arena_records.reactor.wins=1;old.arena_records.reactor.highest_wave=10;old.arena_records.foundry.games=1;old.arena_records.scrapyard.games=3;old.arena_records.scrapyard.wins=1
	S.save_local(old,PATH);var raw=FileAccess.get_file_as_string(PATH);loaded=S.load_local(PATH)
	check(W.ORDER.all(func(id):return W.available(loaded,id)),'Pre-map visited arenas and explicit reactor access remain available')
	check(loaded.world_progress.cleared.has('reactor') and loaded.world_progress.cleared.has('scrapyard') and not loaded.world_progress.cleared.has('foundry'),'Only genuine attributed old victories count as clears')
	check(loaded.meta.coins==133 and loaded.collection.parts==77 and loaded.collection.levels.blaster==4 and loaded.collection.heroes.has('sparky'),'Migration preserves wallet, parts, hero and ranks without auto-awarding gifts')
	check(FileAccess.file_exists(S.sidecar(PATH,'pre_world_map')) and FileAccess.get_file_as_string(S.sidecar(PATH,'pre_world_map'))==raw,'Exact pre-map profile backup created')
	check(W.eligible(loaded,'reactor') and W.claim(loaded,'reactor'),'Past arena winners may claim first-clear reward once')
	S.save_local(loaded,PATH);loaded=S.load_local(PATH);check(not W.eligible(loaded,'reactor') and loaded.meta.coins==193,'Migrated claim does not return after reboot')
	var empty_old=S.defaults();empty_old.erase('world_progress');var migrated=W.migrate(empty_old,null)
	check(migrated.unlocked==['scrapyard'] and migrated.cleared.is_empty(),'Unused legacy arenas follow new route without invented progress')
	var endless_only=S.defaults();endless_only.endless_records.docks.runs=3;endless_only.endless_records.docks.highest_wave=40
	check(W.migrate(endless_only,null).cleared.is_empty() and W.migrate(endless_only,null).unlocked.has('docks'),'Visited endless arena retained without inventing campaign win')
	for version in [1,2]:
		var legacy=S.defaults();legacy.erase('world_progress');legacy.version=version;legacy.games=2;legacy.wins=1;S.save_local(legacy,PATH);loaded=S.load_local(PATH)
		check(loaded.world_progress.cleared.has('scrapyard') and W.available(loaded,'reactor'),'Historic global-only win attribution v'+str(version))
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original=g.saved.duplicate(true)
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area();clean_profile()
	g.arena_select(1);await process_frame
	check(g.state==g.State.ARENA_SELECT and button_named('EnterWorld').disabled,'Actual locked world CTA disabled')
	check(g.ui_root.get_children().filter(func(n):return n is Button and str(n.name).begins_with('WorldCard_')).size()==4,'Four real world navigation cards')
	var state=g.saved.duplicate(true);check(not g.choose_arena('reactor') and g.saved==state,'Direct start cannot bypass world lock even in test mode')
	g.arena_select(0);touch(7,Vector2(1200,600),true)
	var drag=InputEventScreenDrag.new();drag.index=7;drag.position=g.ui_root.get_global_transform()*Vector2(1000,605);g._input(drag);await process_frame;touch(7,Vector2(1000,605),false)
	check(g.arena_cursor==1 and button_named('EnterWorld').disabled,'Real swipe reaches locked preview safely')
	button_named('WorldCard_scrapyard').pressed.emit();check(g.arena_cursor==0,'Real world card selects first arena')
	g.world_map.wallet_help();check(g.ui_root.get_children().filter(func(n):return n is Label and n.text in ['RUN-COINS','STUDIO-COINS','WERKSTATTTEILE']).size()==3,'Currency help explains three separate wallets')
	g.world_map.show();check(not button_named('EnterWorld').disabled,'Currency help returns to map with valid start')
	g.saved.settings.master=0;g.test_mode=false
	button_named('EnterWorld').pressed.emit();check(g.state==g.State.WAVE_PREPARATION and g.arena_id=='scrapyard','Production state machine accepts map-to-run CTA')
	g.begin_wave();g.wave_number=10;g.begin_wave();var before_wallet:int=g.saved.meta.coins;g.damage_enemy(g.enemies[0],1000000000)
	check(g.state==g.State.VICTORY and g.saved.world_progress.cleared==['scrapyard'] and W.available(g.saved,'reactor') and not W.available(g.saved,'docks'),'Actual final boss unlocks only next world')
	check(g.saved.world_progress.claimed.is_empty() and g.saved.collection.parts==0,'First-clear gift awaits deliberate claim')
	var map_cta=g.ui_root.get_children().filter(func(n):return n is Button and n.text=='WELTKARTE / BELOHNUNG')
	check(map_cta.size()==1,'Result has real world-map and reward route')
	map_cta[0].pressed.emit();check(g.state==g.State.ARENA_SELECT and g.arena_cursor==0,'Result opens the earned reward directly through production state machine')
	g.test_mode=true;g.arena_select(0);check(not button_named('ClaimWorldReward').disabled,'Completed world advertises unclaimed reward')
	var coins:int=g.saved.meta.coins;button_named('ClaimWorldReward').pressed.emit()
	check(g.saved.meta.coins==coins+40 and g.saved.collection.parts==20 and g.saved.collection.tickets.crew==2,'Real claim button grants all currencies exactly')
	check(button_named('ClaimWorldReward').disabled and S.load_local(PATH).world_progress.claimed==['scrapyard'],'Claim flag and currencies committed together')
	check(not g.world_map.claim('scrapyard'),'Second live claim rejected')
	g.saved=S.load_local(PATH);g.arena_select(0);check(button_named('ClaimWorldReward').disabled,'Reloaded claim remains disabled')
	var seed=g.saved.collection.seed;g.garage.open_case('crew');var receipt=g.saved.collection.pending.duplicate(true)
	check(not receipt.is_empty() and g.saved.collection.heroes.size()==2 and g.saved.collection.tickets.crew==1,'Reward ticket opens a real permanent fighter')
	check(S.load_local(PATH).collection.pending==receipt and not W.eligible(S.load_local(PATH),'scrapyard'),'Case opening preserves earned world claim and restart receipt')
	g.garage.transact('ack','',receipt.serial)
	g.main_menu();g.character_select();final_boss_victory('reactor','veteran')
	check(W.available(g.saved,'docks') and not W.available(g.saved,'foundry') and W.eligible(g.saved,'reactor'),'Second actual arena victory advances route')
	g.main_menu();g.arena_select(1);g.world_map.save_path='user://missing_world_map_test_020/state.json';state=g.saved.duplicate(true)
	check(not g.world_map.claim('reactor') and g.saved==state and g.world_map.error!='','Failed claim rolls back all currencies, tickets and claim flag')
	var directory='user://world_map_rename_target_020';DirAccess.make_dir_absolute(directory);g.world_map.save_path=directory
	check(not g.world_map.claim('reactor') and g.saved==state,'Rename failure rolls back entire reward transaction too')
	DirAccess.remove_absolute(directory+'.tmp');DirAccess.remove_absolute(directory)
	g.world_map.save_path=PATH;check(g.world_map.claim('reactor') and S.load_local(PATH).world_progress.claimed.has('reactor'),'Retry persists one complete reward')
	for blocked in [g.State.COMBAT,g.State.PAUSED,g.State.LEVEL_UP,g.State.SHOP,g.State.WAVE_PREPARATION]:
		g.state=blocked;state=g.saved.duplicate(true);check(not g.world_map.claim('docks') and g.saved==state,'World transaction blocked during gameplay state '+str(blocked))
	g.state=g.State.MAIN_MENU;g.arena_select(2);g.run_mode='endless';check(g.choose_arena('docks'),'Unlocked arena playable in endless')
	g.wave_number=10;g.begin_wave();g.damage_enemy(g.enemies[0],1000000000)
	check(g.state==g.State.SHOP and not W.available(g.saved,'foundry') and not g.saved.world_progress.cleared.has('docks'),'Endless boss does not clear campaign world')
	g.finish(false);g.main_menu();g.character_select();final_boss_victory('docks','mayhem');check(W.available(g.saved,'foundry'),'Any campaign difficulty may open next world')
	g.main_menu();g.character_select();final_boss_victory('foundry');check(g.saved.world_progress.cleared.size()==4 and not W.eligible(g.saved,'unknown'),'All four actual worlds connected')
	g.main_menu();g.character_select();g.arena_id='foundry';g.start_run();g.wave_number=10;g.begin_wave();g.finish(false)
	check(g.saved.world_progress.cleared.size()==4,'Later defeat preserves previous completions')
	for resolution in [Vector2i(1280,720),Vector2i(2340,1080),Vector2i(1920,1440)]:
		root.size=resolution;await process_frame;g.update_safe_area();g.arena_select(3);await process_frame
		check(button_named('EnterWorld').size.x>=690 and button_named('EnterWorld').position.y+button_named('EnterWorld').size.y<=1050,'Touch-sized bounded CTA at '+str(resolution))
		check(g.ui_root.get_children().filter(func(n):return n is Button and not n.disabled).all(func(b):return b.position.x>=90 and b.position.x+b.size.x<=1830),'All map buttons inside safe logical layout '+str(resolution))
	var route=g.ui_root.get_children().filter(func(n):return n.name=='WorldRoute')[0];g.saved.settings.reduced_motion=true;var clock:float=route.clock;route._process(1);check(route.clock==clock,'Reduced motion freezes route animation')
	for id in W.ORDER:check(ResourceLoader.exists('res://assets/ui/worlds/'+id+'.svg'),'Original emblem '+id)
	clean_profile();g.start_run();g.wave_number=5;g.begin_wave();g.crit=0;g.damage_enemy(g.breaker.actor(),1000000000)
	while g.state==g.State.LEVEL_UP:g.apply_upgrade('damage');g.if_more_levels()
	check(g.state==g.State.SHOP and g.saved.world_progress.cleared.is_empty() and not W.available(g.saved,'reactor'),'Actual Axel victory never grants full-world completion')
	g.wave_number=10;g.begin_wave();g.spawn_clock=999;g.remaining=.001;g._physics_process(.02)
	check(g.state==g.State.GAME_OVER and g.saved.world_progress.cleared.is_empty(),'Actual final-boss timeout never unlocks next world')
	clean_profile();S.save_local(g.saved,PATH);g.world_map.save_path='user://missing_world_finish_test_020/state.json';final_boss_victory('scrapyard')
	check(g.state==g.State.VICTORY and g.world_map.error!='' and W.eligible(g.saved,'scrapyard'),'Failed finish save retains earned progression in memory and reports failure')
	check(S.load_local(PATH).world_progress.cleared.is_empty(),'Failed finish cannot claim successful persistence')
	g.arena_select(1);g.world_map.save_path=PATH
	var retry=g.ui_root.get_children().filter(func(n):return n is Button and n.text=='ERNEUT SPEICHERN')
	check(retry.size()==1,'Real retry control available after failed finish save')
	retry[0].pressed.emit();var retried=S.load_local(PATH)
	check(retried.world_progress.cleared==['scrapyard'] and retried.games==1 and retried.wins==1 and g.world_map.error=='','Retry atomically saves first clear and original run stats once')
	g.world_map.persist();check(S.load_local(PATH).wins==1,'Repeated save retry never repeats run result')
	g.saved=S.load_local(PATH);check(g.world_map.claim('scrapyard') and not g.world_map.claim('scrapyard'),'Recovered first-clear reward remains exactly once')
	g.saved=original;g.save_game();g.queue_free();await process_frame
	for file in [PATH,S.sidecar(PATH,'pre_world_map'),S.sidecar(PATH,'v1.backup'),S.sidecar(PATH,'v2.backup')]:DirAccess.remove_absolute(file)
	print('WORLD MAP RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

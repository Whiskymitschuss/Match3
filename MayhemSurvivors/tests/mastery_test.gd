extends SceneTree
const M=preload('res://scripts/progression/character_mastery.gd')
const Save=preload('res://scripts/autoload/save_manager.gd')
const Records=preload('res://scripts/progression/run_records.gd')
var passed=0
var failed=0
func check(ok:bool,message:String):
	if ok:passed+=1;print('PASS ',message)
	else:failed+=1;push_error('FAIL '+message)
func _initialize():call_deferred('run')
func find_button(g,text:String):
	for child in g.ui_root.get_children():
		if child is Button and child.text==text:return child
	return null
func run():
	var saved=Save.defaults()
	for hero in M.HEROES:
		check(M.completed(saved,hero)==0 and M.selected(saved,hero)=='classic','Fresh '+hero)
		check(not M.equip(saved,hero,'neon') and not M.equip(saved,hero,'champion'),'Locked '+hero)
		saved.records[hero].best_wave=4
		check(not M.unlocked(saved,hero,'neon'),'Below wave threshold '+hero)
		saved.records[hero].best_wave=5
		check(M.unlocked(saved,hero,'neon') and M.completed(saved,hero)==1,'Wave threshold '+hero)
		check(M.equip(saved,hero,'neon') and M.selected(saved,hero)=='neon','Equip earned neon '+hero)
		saved.records[hero].kills=249
		check(not M.rewards(saved,hero).has('JÄGERABZEICHEN'),'Below kills threshold '+hero)
		saved.records[hero].kills=250
		check(M.rewards(saved,hero).has('JÄGERABZEICHEN') and M.completed(saved,hero)==2,'Cumulative kills '+hero)
		saved.records[hero].games=1;saved.records[hero].wins=1
		check(M.completed(saved,hero)==3 and M.rewards(saved,hero).has(M.TITLES[hero]),'Full mastery title '+hero)
		check(M.equip(saved,hero,'champion') and M.selected(saved,hero)=='champion','Equip earned gold '+hero)
	check(not M.equip(saved,'unknown','classic') and not M.equip(saved,'shade','cheat'),'Reject unknown IDs')
	var path='user://mastery_test.json'
	check(Save.save_local(saved,path)==OK,'Save real styles')
	var loaded=Save.load_local(path)
	check(loaded.hero_styles==saved.hero_styles and M.completed(loaded,'shade')==3,'Reload all progress and selections')
	var old=Save.defaults();old.erase('hero_styles');old.records.sparky.best_wave=7;old.records.sparky.kills=310;old.records.sparky.games=2;old.records.sparky.wins=1
	Save.save_local(old,path);loaded=Save.load_local(path)
	check(M.completed(loaded,'sparky')==3 and M.selected(loaded,'sparky')=='classic','Existing v0.10 profile earns goals without forcing outfit')
	check(M.completed(loaded,'bruiser')==0,'Never attribute another hero progress')
	old.hero_styles={'sparky':'forged','bruiser':'champion','shade':23};Save.save_local(old,path);loaded=Save.load_local(path)
	check(loaded.hero_styles==Save.defaults().hero_styles,'Invalid and locked stored selections sanitized')
	old.version=1;old.erase('records');old.wins=100;old.kills=10000;Save.save_local(old,path);loaded=Save.load_local(path)
	check(M.completed(loaded,'sparky')==0,'Legacy aggregate totals never invent hero mastery')
	var g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);g.set_physics_process(false);var original_save=g.saved.duplicate(true);g.saved=Save.defaults()
	root.size=Vector2i(1280,720);await process_frame;await process_frame;g.update_safe_area()
	g.character_select();find_button(g,'MEISTERSCHAFTEN & SKINS').pressed.emit()
	check(find_button(g,'NEON CREW / GESPERRT')!=null,'Actual character navigation opens mastery')
	find_button(g,'NEON CREW / GESPERRT').pressed.emit()
	check(find_button(g,'NOCH GESPERRT').disabled and M.selected(g.saved,'bruiser')=='classic','Locked preview never equips')
	g.saved.records.bruiser.best_wave=5;g.mastery_screen(0,'neon');find_button(g,'AUSRÜSTEN').pressed.emit()
	check(M.selected(g.saved,'bruiser')=='neon' and find_button(g,'AKTIV').disabled,'Real equip button persists unlocked selection')
	check(M.selected(Save.load_local(),'bruiser')=='neon','Equip writes actual local save')
	find_button(g,'ZURÜCK').pressed.emit()
	var portrait_neon=false
	for child in g.ui_root.get_children():
		if child.get_script()==load('res://scripts/ui/portrait.gd') and child.kind=='bruiser':portrait_neon=child.outfit=='neon'
	check(portrait_neon,'Character card reflects saved skin')
	g.selected=0;g.start_run();var original=[g.max_hp,g.speed,g.damage_mult,g.attack_mult,g.crit,g.armor]
	g.saved.hero_styles.bruiser='classic';g.start_run()
	check(original==[g.max_hp,g.speed,g.damage_mult,g.attack_mult,g.crit,g.armor],'Cosmetic skin changes no combat stats')
	g.wave_number=5;g.kills=250;g.finish(false)
	check(M.completed(g.saved,'bruiser')==2,'Real defeat awards reached wave and cumulative kills')
	var games=g.saved.records.bruiser.games;g.finish(false)
	check(g.saved.records.bruiser.games==games,'Duplicate result never duplicates progress')
	g.start_run();g.wave_number=10;g.finish(true)
	check(M.completed(g.saved,'bruiser')==3 and M.unlocked(g.saved,'bruiser','champion'),'Real victory unlocks gold and master title')
	var announced=false
	for child in g.ui_root.get_children():
		if child is Label and child.text.contains('GOLD CHAMPION'):announced=true
	check(announced,'Result announces newly earned reward')
	g.saved=original_save;g.save_game();g.queue_free();await process_frame
	for file in [path,Save.sidecar(path,'v1.backup')]:
		if FileAccess.file_exists(file):DirAccess.remove_absolute(file)
	print('MASTERY RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

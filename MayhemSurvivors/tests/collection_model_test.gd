extends SceneTree
# Standalone collection, economy, ownership and opening receipt checks.
const C=preload('res://scripts/progression/collection.gd')
const R=preload('res://scripts/progression/daily_rewards.gd')
var passed=0
var failed=0
func _initialize():call_deferred('run')
func check(ok:bool,label:String):
	if ok:passed+=1;print('PASS ',label)
	else:failed+=1;push_error('FAIL '+label)
func fresh() -> Dictionary:return {'collection':C.defaults(),'meta':R.defaults(),'unlocked':['bruiser']}
func run():
	var s=fresh();s.collection.seed=17018
	check(s.collection.heroes==['bruiser'] and s.collection.levels=={'hammer':1},'Bruiser and hammer only')
	check(C.catalog().heroes.size()==10 and C.catalog().items.size()==32,'Catalog has five additional heroes and32 items')
	for id in ['crew','arsenal','style']:
		var sum=0.0
		for item in C.candidates(s,id):sum+=item.chance
		check(absf(sum-1)<.000001,'Real chances normalized '+id)
	var same=s.duplicate(true);var first=C.open_case(s,'crew');var second=C.open_case(same,'crew')
	check(first==second and s.collection.seed==same.collection.seed,'Persisted seed gives same result on same state')
	check(first.hero and not first.duplicate and s.collection.heroes.has(first.id),'First crew ticket unlocks real hero')
	check(s.collection.levels.has(C.STARTERS[first.id]),'Hero includes its starter blueprint')
	check(s.collection.tickets.crew==0 and s.meta.coins==0,'Free ticket consumed without charging coins')
	check(C.open_case(s,'crew').is_empty() and s.collection.opened==1,'Pending reveal blocks another draw')
	check(not C.acknowledge(s,999) and C.acknowledge(s,first.serial),'Only matching receipt can be acknowledged')
	check(not C.acknowledge(s,first.serial),'Receipt cannot be acknowledged twice')
	check(C.open_case(s,'crew').is_empty(),'Insufficient wallet cannot pay for next case')
	s.meta.coins=100;var paid=C.open_case(s,'crew')
	check(not paid.is_empty() and s.meta.coins==0,'Exact paid case debit')
	C.acknowledge(s,paid.serial)
	check(C.open_case(s,'forged').is_empty() and s.meta.coins==0,'Unknown case rejected')
	s=fresh();s.collection.heroes=['bruiser','sparky','shade','twinkle','kicksy'];s.collection.pity=2
	var pool=C.candidates(s,'crew')
	check(pool.size()==1 and pool[0].id=='steelfist' and pool[0].chance==1,'Third-case guarantee targets only missing hero')
	var reveal=C.open_case(s,'crew')
	check(reveal.id=='steelfist' and s.collection.pity==0,'Guaranteed hero resets pity')
	C.acknowledge(s,reveal.serial);s.collection.tickets.crew=1;var old=s.collection.heroes.size();var dup=C.open_case(s,'crew')
	check(dup.duplicate and dup.parts>0 and s.collection.parts==dup.parts and s.collection.heroes.size()==old,'Duplicate becomes parts without duplicate roster entry')
	s=fresh();s.collection.seed=18018;s.collection.tickets.crew=15
	for i in range(30):
		reveal=C.open_case(s,'crew');check(not reveal.is_empty(),'Crew progression draw '+str(i+1));C.acknowledge(s,reveal.serial)
	check(s.collection.heroes.size()==11,'All fighters obtained within thirty crew openings')
	check(s.collection.history.size()==15,'Opening journal retained')
	s=fresh();s.collection.parts=190
	for i in range(4):check(C.upgrade(s,'hammer'),'Actual weapon rank upgrade '+str(i+1))
	check(s.collection.levels.hammer==5 and s.collection.parts==0,'Four upgrades reach rank5 with exact cost')
	check(not C.upgrade(s,'hammer') and s.collection.parts==0,'Maximum rank cannot consume more parts')
	check(absf(C.snapshot(s,'bruiser').weapon_bonus.hammer-.08)<.000001,'Rank5 gives8 percent weapon damage')
	check(not C.upgrade(s,'neon_visor') and not C.upgrade(s,'forged'),'Unowned and unknown upgrades rejected')
	s=fresh();s.collection.levels.blaster=1
	check(not C.equip(s,'bruiser','blaster'),'Weapon class binding enforced')
	check(not C.equip(s,'sparky','blaster'),'Locked fighter cannot equip')
	s.collection.heroes.append('sparky')
	check(C.equip(s,'sparky','blaster'),'Unlocked compatible fighter can equip')
	s.collection.levels.splitgun=1
	check(C.equip(s,'sparky','splitgun') and C.starter(s,'sparky')=='splitgun','Alternative starter selection')
	s.collection.levels.reactor_plate=3;s.collection.levels.neon_soles=2;s.collection.levels.heart_module=4;s.collection.levels.frost_nova=2
	for id in ['reactor_plate','neon_soles','heart_module','frost_nova']:check(C.equip(s,'sparky',id),'Equip slot '+id)
	var snap=C.snapshot(s,'sparky')
	check(snap.hp==20 and snap.armor==3 and absf(snap.speed-.02)<.000001 and snap.spell=='frost_nova' and snap.spell_rank==2,'Combat snapshot records actual gear modifiers')
	s.collection.levels.reactor_plate=5
	check(snap.armor==3,'Snapshot detached from later inventory changes')
	s.collection.levels.comet=1;s.meta.owned.append('comet')
	check(C.equip(s,'sparky','comet') and s.meta.equipped.ring=='comet','Decoration interoperates with existing cosmetic wallet')
	var dirty={'heroes':['forged','sparky','sparky'],'levels':{'hammer':999,'forged':5},'parts':-7,'pity':999,'seed':0,'tickets':{'crew':-1},'pending':{'id':'forged','case':'crew','hero':true}}
	var clean=C.clean(dirty)
	check(clean.heroes==['bruiser','sparky'] and clean.levels.hammer==5 and not clean.levels.has('forged'),'Corrupt and duplicate IDs sanitized')
	check(clean.parts==0 and clean.pity==2 and clean.seed==1 and clean.tickets.crew==0 and clean.pending.is_empty(),'Invalid counters and pending receipt sanitized')
	var before=s.meta.coins
	check(C.run_reward(s,'tutorial',10,1000,true)==0 and s.meta.coins==before,'Training cannot fund cases')
	check(C.run_reward(s,'campaign',10,600,true)==80 and s.meta.coins==before+80,'Completed run funds permanent wallet')
	check(C.run_reward(s,'campaign',0,0,false)==0,'Empty abandoned run gives no reward')
	check(C.run_reward(s,'endless',10000,100000,false)==500,'Run reward has defined cap')
	print('COLLECTION MODEL RESULT ',passed,' passed, ',failed,' failed');quit(1 if failed else 0)

extends RefCounted
const Data=preload('res://scripts/progression/recap_data.gd')
var owner_ref:WeakRef
var game:Node2D:
	get:return owner_ref.get_ref()
var rows:Array=[]
var current:Dictionary={}
var baseline:Dictionary={}
var totals:Dictionary=Data.empty_totals()
var omitted=0
func _init(g:Node2D):owner_ref=weakref(g)
func reset():rows.clear();current.clear();baseline.clear();totals=Data.empty_totals();omitted=0
func begin():
	if game.run_mode=='tutorial':return
	current=Data.empty_totals();current.wave=game.wave_number;current.boss=game.rules.boss_wave();current.boss_name='';current.outcome='interrupted'
	for e in game.enemies:
		if e.kind in ['boss','breaker_axel','champion']:current.boss_name=str(e.get('boss_name',game.arena_definition.boss_name));break
	baseline={'kills':game.kills,'damage':game.dealt,'coins':game.earned,'abilities':game.run_abilities}
func live() -> bool:
	return not current.is_empty() and game.state==game.State.COMBAT and not (game.tutorial and game.tutorial.active and game.tutorial.frozen())
func tick(dt:float):
	if live():current.seconds+=maxf(0,dt)
func hurt(amount:float):
	if not live() or amount<=0:return
	current.received+=amount;current.hits+=1
func proc():
	if live():current.procs+=1
func bonus(amount:float):
	if live() and amount>0:current.combo_damage+=amount
func close(outcome:String='interrupted'):
	if current.is_empty():return
	for key in ['kills','damage','coins','abilities']:
		current[key]=maxf(0,float(game.get({'damage':'dealt','coins':'earned','abilities':'run_abilities'}.get(key,key)))-float(baseline[key]))
	current.outcome=outcome if outcome in Data.OUTCOMES else 'interrupted'
	for key in Data.KEYS:totals[key]+=current[key]
	rows.append(current.duplicate(true));current.clear();baseline.clear()
	if rows.size()>Data.MAX_WAVES:rows.pop_front();omitted+=1
func snapshot() -> Dictionary:
	return Data.clean({'version':1,'waves':rows.duplicate(true),'totals':totals.duplicate(true),'omitted':omitted})

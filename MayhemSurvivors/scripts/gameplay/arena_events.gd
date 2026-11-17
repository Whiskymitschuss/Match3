extends RefCounted
var game:Node2D
var enabled=true
var active=false
var triggered=false
var age=0.0
var pulse=0
const NAMES={'scrapyard':'SCHROTTREGEN','reactor':'REAKTOR-ÜBERLAST','docks':'FLUTALARM','foundry':'SCHMELZSTURM'}
func _init(g:Node2D):game=g
func clear():active=false;triggered=false;age=0;pulse=0
func update(dt:float):
	if not enabled or game.state!=game.State.COMBAT or game.run_mode=='tutorial' or game.rules.boss_wave() or game.wave_number<3:return
	if not triggered:
		if float(game.rules.current_wave().duration)-game.remaining<24 or not game.arena_hazards.items.is_empty() or not game.encounters.hazards.is_empty():return
		triggered=true;active=true;age=0;pulse=0;game.encounters.warn(NAMES[game.arena_id]+' / GOLDENE WARNFLÄCHEN VERLASSEN');game.sound('elite_warning');spawn_pattern()
		return
	if not active:return
	age+=dt
	if age>=4 and pulse==1:spawn_pattern()
	if age>=8:active=false;game.run_events+=1;game.encounters.warn('EREIGNIS ÜBERSTANDEN')
func spawn_pattern():
	var at:Vector2=game.player.position
	if game.arena_id in ['scrapyard','foundry']:
		for offset in [Vector2.ZERO,Vector2(-230,140),Vector2(230,-140)]:
			game.arena_hazards.bomb((at+offset).clamp(Vector2(120,120),Vector2(2280,1480)),95 if game.arena_id=='scrapyard' else 110,1.8 if game.arena_id=='scrapyard' else 2.0)
			game.arena_hazards.items.back().damage=12 if game.arena_id=='scrapyard' else 14
	elif game.arena_id=='docks':
		for y in [clampf(at.y-180,90,1510),clampf(at.y+180,90,1510)]:game.arena_hazards.lane(false,y,70,1.8,.6,10)
	else:
		game.arena_hazards.lane(true,clampf(at.x+150,100,2300),80,2.0,.5,12)
		game.arena_hazards.lane(false,clampf(at.y-150,100,1500),80,2.0,.5,12)
	pulse+=1

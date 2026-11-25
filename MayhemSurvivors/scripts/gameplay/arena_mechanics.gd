extends RefCounted
# Shared immutable hazard snapshots drive warnings, collision and one-shot resolution.
const CORE=preload('res://assets/environments/energy_core.svg')
const CONTAINER=preload('res://assets/environments/neon_container.svg')
var game:Node2D
var data:Dictionary
var enabled=true
var hazards:Array=[]
var cores:Array=[]
var charge=0
var killed_for_cores=0
var dropped=0
var terminal=Vector2.ZERO
var stage='idle'
var held=0.0
var drop_index=0
var groups:Dictionary={}
var serial=0
var total_coins=0
var arena_kills=0
var maneuvers=0
func _init(g:Node2D):game=g;data=game.read_data('arenas/mechanics')
func supported() -> bool:return enabled and game.united.enabled and game.arena_events.enabled and game.run_mode!='tutorial' and game.arena_id in ['reactor','docks']
func normal_wave() -> bool:return supported() and not game.rules.boss_wave() and ((game.wave_number-1)%10)+1>=3
func clear():
	hazards.clear();cores.clear();charge=0;killed_for_cores=0;dropped=0;stage='idle';held=0;drop_index=0;groups.clear()
func reset_run():clear();serial=0;total_coins=0;arena_kills=0;maneuvers=0
func begin_wave():
	if not normal_wave():return
	stage='collect' if game.arena_id=='reactor' else 'watch'
	var offset=Vector2(-300 if game.player.position.x>1200 else 300,120 if game.player.position.y<300 else -120)
	terminal=(game.player.position+offset).clamp(Vector2(150,180),Vector2(2250,1420))
func wave_slot() -> int:return ((game.wave_number-1)%10)+1
func bonus(arena:String) -> int:return int(data[arena].bonus_base)+int(data[arena].bonus_per_wave)*wave_slot()
func defeated(e:Dictionary,source:String):
	if source=='arena':arena_kills+=1;return
	if not normal_wave() or game.arena_id!='reactor' or stage!='collect' or e.kind in game.united.R.BOSS_KINDS:return
	killed_for_cores+=1
	if killed_for_cores%int(data.reactor.kills_per_core)==0 and dropped<int(data.reactor.cores_required):
		cores.append({'pos':e.pos});dropped+=1
func add_hazard(kind:String,pos:Vector2,warm:float,owner:Dictionary={},group:int=-1) -> bool:
	if hazards.size()>=int(data.limits.hazards):return false
	var d=data.reactor if kind=='core' else data.docks
	var boss=not owner.is_empty()
	var h={'kind':kind,'pos':pos,'warm':warm,'age':0.0,'resolved':false,'owner':owner,'group':group,'boss':boss,'radius':float(d.boss_radius if boss and kind=='core' else d.get('radius',0)), 'enemy_damage':float(d.enemy_damage)+wave_slot()*float(d.damage_per_wave),'player_damage':float(owner.damage)*.7 if boss else float(d.player_damage)}
	if kind=='container':h.rect=Rect2(pos-Vector2(d.size[0],d.size[1])*.5,Vector2(d.size[0],d.size[1]))
	if boss:h.owner_start=owner.pos
	hazards.append(h);return true
func remove_owner(owner:Dictionary):
	for i in range(hazards.size()-1,-1,-1):
		if not hazards[i].owner.is_empty() and is_same(hazards[i].owner,owner):hazards.remove_at(i)
func contains(h:Dictionary,pos:Vector2,radius:float) -> bool:
	if h.kind=='container':return h.rect.grow(radius).has_point(pos)
	return pos.distance_to(h.pos)<=float(h.radius)+radius
func update(dt:float):
	if game.state!=game.State.COMBAT or not supported():return
	# Existing hazards advance first. Newly announced ones always get their full warning.
	for h in hazards.duplicate():
		if not hazards.has(h):continue
		if h.boss and (not game.enemies.has(h.owner) or not game.enemy_roles.visible(h.owner.pos) or (game.united.bosses.stage=='windup' and h.owner.pos.distance_to(h.owner_start)>8)):
			hazards.erase(h);continue
		h.age+=dt
		if not h.resolved and h.age>=h.warm:
			h.resolved=true;resolve(h)
			if game.state!=game.State.COMBAT:return
		if hazards.has(h) and h.age>=h.warm+.8:hazards.erase(h)
	if not normal_wave():return
	if game.arena_id=='reactor':update_reactor(dt)
	else:
		var elapsed=float(game.rules.current_wave().duration)-game.remaining
		if drop_index<data.docks.drop_times.size() and elapsed>=float(data.docks.drop_times[drop_index]) and game.remaining>4 and hazards.is_empty():
			drop_index+=1;drop_pair()
func update_reactor(dt:float):
	for core in cores.duplicate():
		if core.pos.distance_to(game.player.position)<maxf(110,game.magnet):core.pos=core.pos.move_toward(game.player.position,600*dt)
		if core.pos.distance_to(game.player.position)<34:
			cores.erase(core);charge+=1;game.sound('core_collect')
	if stage!='collect':return
	if game.remaining<7:stage='expired';held=0;return
	var d=data.reactor
	if charge<int(d.cores_required):return
	held=minf(float(d.hold),held+dt) if game.player.position.distance_to(terminal)<75 and game.move_input.length_squared()<.04 else 0.0
	if held>=float(d.hold):
		charge-=int(d.cores_required);stage='overload';game.arena_events.active=true
		add_hazard('core',terminal,float(d.warm));game.encounters.warn('ÜBERLADUNG / RAUS AUS GELB / GEGNER HINEINLOCKEN');game.sound('core_warning')
func drop_pair():
	serial+=1;var group=serial
	groups[group]={'resolved':0,'kills':0,'paid':false}
	var at:Vector2=game.player.position
	for offset in [Vector2.ZERO,Vector2(-210 if at.x>1200 else 210,110 if at.y<300 else -110)]:
		add_hazard('container',(at+offset).clamp(Vector2(130,120),Vector2(2270,1480)),float(data.docks.warm),{},group)
	game.encounters.warn('CONTAINER / AUSWEICHEN / 2 GEGNER = +%d RUN-COINS' % bonus('docks'));game.sound('container_warning')
func resolve(h:Dictionary):
	game.sound('container_impact' if h.kind=='container' else 'core_blast')
	game.vfx.explosion(h.pos,100 if h.kind=='container' else h.radius,Color('#FFAF43') if h.kind=='container' else Color('#68EC86'))
	# Player damage resolves first, so a lethal mistake cannot grant a posthumous reward.
	if contains(h,game.player.position,27):
		game.hurt(h.player_damage)
		if game.state!=game.State.COMBAT:return
	var kills=0
	for enemy in game.enemies.duplicate():
		if not contains(h,enemy.pos,enemy.radius):continue
		var power=float(h.enemy_damage)
		if enemy.kind in game.united.R.BOSS_KINDS:power=minf(power,float(enemy.max_hp)*float(data.limits.boss_fraction_cap))
		game.damage_enemy(enemy,power,'arena')
		if enemy.hp<=0:kills+=1
		if game.state!=game.State.COMBAT:return
	if h.boss:return
	if h.kind=='core':
		stage='complete';game.arena_events.active=false;game.run_events+=1;maneuvers+=1
		if kills>0:award('reactor')
		else:game.encounters.warn('ÜBERLADUNG BEENDET / KEIN GEGNER BESEITIGT / KEIN BONUS')
	elif groups.has(h.group):
		var group:Dictionary=groups[h.group];group.resolved+=1;group.kills+=kills
		if group.resolved==2 and not group.paid:
			group.paid=true;game.run_events+=1;maneuvers+=1
			if group.kills>=int(data.docks.bonus_kills):award('docks')
func award(arena:String):
	var value=bonus(arena);total_coins+=value;game.coins+=value;game.earned+=value
	game.sound('salvage_complete');game.encounters.warn('MANÖVER GELUNGEN / +%d RUN-COINS' % value)
func boss_zones(owner:Dictionary,at:Vector2) -> float:
	if not supported() or not game.rules.final_boss_wave():return 0.0
	var kind='core' if game.arena_id=='reactor' else 'container'
	var warm=float(data[game.arena_id].boss_warm)
	for offset in [Vector2.ZERO,Vector2(-230,140),Vector2(230,-140)]:add_hazard(kind,(at+offset).clamp(Vector2(150,160),Vector2(2250,1440)),warm,owner)
	return warm
func status() -> String:
	if not normal_wave():return ''
	if game.arena_id=='docks':return 'CONTAINER: 2 GEGNER PRO DOPPELLADUNG\nMANÖVER-BONUS +%d RUN-COINS' % bonus('docks')
	if stage=='expired':return 'REAKTOR / ZEITFENSTER GESCHLOSSEN'
	if stage=='complete':return 'REAKTOR / ÜBERLADUNG ABGESCHLOSSEN'
	if stage=='overload':return 'REAKTOR / ENTLADUNG LÄUFT / ABSTAND!'
	return 'ENERGIEKERNE %d / %d\n%s' % [charge,int(data.reactor.cores_required),'AM TERMINAL 1,2 s ANHALTEN' if charge>=int(data.reactor.cores_required) else 'JEDER 4. GEGNER LÄSST EINEN KERN FALLEN']
func draw():
	if not supported():return
	for core in cores:
		game.draw_circle(core.pos,24,Color(.35,1,.5,.14));game.draw_texture_rect(CORE,Rect2(core.pos-Vector2(19,23),Vector2(38,46)),false)
	if normal_wave() and game.arena_id=='reactor' and stage!='idle':
		var color=Color('#68EC86') if charge>=int(data.reactor.cores_required) else Color('#65C7D9')
		game.draw_circle(terminal,75,Color(color,.08));game.draw_arc(terminal,75,0,TAU,40,color,3,true)
		game.draw_texture_rect(CORE,Rect2(terminal-Vector2(27,39),Vector2(54,66)),false,Color.WHITE if stage=='collect' else Color(.5,.5,.5))
		if held>0 and stage=='collect':game.draw_arc(terminal,82,-PI/2,-PI/2+TAU*held/float(data.reactor.hold),32,Color.WHITE,5,true)
		game.draw_string(game.UISkin.HEADING,terminal+Vector2(-65,108),'ÜBERLADUNG',HORIZONTAL_ALIGNMENT_LEFT,-1,23,color)
	for h in hazards:
		var active:bool=h.resolved;var color=Color('#FF4757') if active else Color('#FFD166')
		if h.kind=='container':
			game.draw_rect(h.rect,Color(color,.28 if active else .12));game.draw_rect(h.rect,color,false,4,true)
			game.draw_line(h.rect.position,h.rect.end,color,2,true);game.draw_line(Vector2(h.rect.end.x,h.rect.position.y),Vector2(h.rect.position.x,h.rect.end.y),color,2,true)
			var t=clampf((float(h.age)/float(h.warm)-.75)/.25,0,1)
			if t>0:game.draw_texture_rect(CONTAINER,Rect2(h.rect.position-Vector2(0,(1-t)*160),h.rect.size),false,Color(1,1,1,t))
		else:
			game.draw_circle(h.pos,h.radius,Color(color,.28 if active else .1));game.draw_arc(h.pos,h.radius,0,TAU,48,color,4,true)
			game.draw_texture_rect(CORE,Rect2(h.pos-Vector2(20,26),Vector2(40,52)),false)
		var text='GEFAHR' if active else ('CONTAINER %.1f s' if h.kind=='container' else 'ENTLADUNG %.1f s') % maxf(0,float(h.warm)-float(h.age))
		var width=game.UISkin.HEADING.get_string_size(text,HORIZONTAL_ALIGNMENT_LEFT,-1,22).x
		var at:Vector2=h.pos+Vector2(-width*.5,-(h.rect.size.y*.5 if h.kind=='container' else h.radius)-18)
		game.draw_rect(Rect2(at-Vector2(7,24),Vector2(width+14,32)),Color('#111324'));game.draw_string(game.UISkin.HEADING,at,text,HORIZONTAL_ALIGNMENT_LEFT,-1,22,color)

extends RefCounted
# All encounter simulation is COMBAT-gated. No random draws or extra normal spawn nodes.
var game:Node2D
var data:Dictionary
var enabled=true
var promoted=false
var run_serial=0
var elite_kills=0
var rewards:Array=[]
var hazards:Array=[]
var boss_tier=1
var special_clock=0.0
var recovery=0.0
var boss_lock=false
var special_number=0
var first_special=false
var notice=''
var notice_time=0.0
func _init(g:Node2D):
	game=g;data=game.read_data('encounters/encounters')
	# JSON numbers are floats; Array.has compares numeric Variant types strictly.
	data.elite_waves=data.elite_waves.map(func(value):return int(value))
func reset_run():
	clear_combat();rewards.clear();elite_kills=0;run_serial+=1
func clear_combat():
	promoted=false;hazards.clear();boss_tier=1;special_clock=0;recovery=0;boss_lock=false;special_number=0;first_special=false;notice='';notice_time=0
func visible(pos:Vector2) -> bool:
	return game.enemy_roles.visible(pos)
func eligible() -> bool:
	return enabled and game.state==game.State.COMBAT and not promoted and data.elite_waves.has(game.wave_number) and float(game.waves[game.wave_number-1].duration)-game.remaining>=float(data.elite_at)
func promote(e:Dictionary):
	if not eligible() or not e.kind in ['grunt','runner','tank']:return
	var definition=game.enemy_data.tank
	var wave=game.waves[game.wave_number-1]
	var stats=game.WaveBalance.stats(definition,wave,game.wave_number)
	e.kind='tank';e.elite='pulse' if game.is_reactor() else 'ram'
	e.hp=stats.hp*float(data.elite_hp_factor);e.max_hp=e.hp
	e.speed=stats.speed*float(data.elite_speed_factor);e.damage=stats.damage*float(data.elite_damage_factor);e.radius=float(definition.radius)+7
	e.coin_reward=game.WaveBalance.reward(int(definition.coins),wave)+int(data.elite_extra_coins)
	e.xp_reward=game.WaveBalance.reward(int(definition.xp),wave)+int(data.elite_extra_xp)
	e.elite_stage='idle';e.elite_clock=2.0;e.elite_origin=e.pos;e.elite_target=e.pos;e.elite_gap=0.0;e.elite_noticed=false
	promoted=true
func warn(text:String):
	notice=text;notice_time=2.6
func movement(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if game.state!=game.State.COMBAT:return Vector2.ZERO
	if not enabled or not e.has('elite'):return normal
	var config=data[e.elite]
	if not e.elite_noticed and visible(e.pos):
		e.elite_noticed=true;warn('ELITE: '+str(config.name));game.sound('elite_warning')
	if e.elite_stage=='windup':
		# Knockback is a deliberate counter: moving the origin cancels a locked telegraph.
		if e.pos.distance_to(e.elite_origin)>6:
			e.elite_stage='idle';e.elite_clock=1.5;return Vector2.ZERO
		e.elite_clock=maxf(0,e.elite_clock-dt)
		if e.elite_clock<=0:
			if not visible(e.pos):e.elite_stage='idle';e.elite_clock=config.cooldown;return Vector2.ZERO
			if e.elite=='ram':e.elite_stage='dash'
			else:
				game.vfx.burst(e.elite_origin,Color('#41F4DE'),game.vfx.limits().burst,'spark',130);game.sound('ability_impulse')
				add_ring(e.elite_origin,config.radius,config.width,e.elite_gap,config.gap,0,.30,config.damage,'elite',e)
				e.elite_stage='idle';e.elite_clock=config.cooldown
		return Vector2.ZERO
	if e.elite_stage=='dash':
		var offset:Vector2=e.elite_target-e.pos
		if offset.length()<1:
			e.elite_stage='idle';e.elite_clock=config.cooldown;return Vector2.ZERO
		var step:Vector2=offset.limit_length(float(config.dash_speed)*dt)
		return step/maxf(.0001,dt)
	if not visible(e.pos):return normal
	e.elite_clock=maxf(0,e.elite_clock-dt)
	if e.elite_clock<=0 and e.pos.distance_to(game.player.position)<=420:
		e.elite_origin=e.pos
		var direction:Vector2=(game.player.position-e.pos).normalized()
		if direction.length_squared()<.01:direction=Vector2.RIGHT
		e.elite_target=(e.pos+direction*minf(float(config.get('dash_range',360)),maxf(160,e.pos.distance_to(game.player.position)))).clamp(Vector2(55,55),Vector2(2345,1545))
		e.elite_gap=direction.angle()+PI*.5;e.elite_stage='windup';e.elite_clock=config.windup;game.sound('elite_warning')
		return Vector2.ZERO
	return normal
func after_move(e:Dictionary,old:Vector2,current:Vector2):
	if not enabled or game.state!=game.State.COMBAT or not e.has('elite') or e.elite_stage!='dash':return
	# Use the final clamped/slowed movement segment, never an unmodified prediction.
	if Geometry2D.get_closest_point_to_segment(game.player.position,old,current).distance_to(game.player.position)<e.radius+27:game.hurt(e.damage)
func interrupt_elite(e:Dictionary):
	if e.has('elite') and e.elite_stage in ['windup','dash']:
		e.elite_stage='idle';e.elite_clock=1.5
func removed(e:Dictionary):
	if not e.has('elite') or e.get('elite_rewarded',false):return
	e.elite_rewarded=true
	elite_kills+=1
	rewards.append({'id':str(run_serial)+':'+game.arena_id+'-'+str(game.wave_number),'wave':game.wave_number,'kind':e.elite})
	for i in range(hazards.size()-1,-1,-1):
		if is_same(hazards[i].get('owner'),e):hazards.remove_at(i)
	warn('ELITE BESIEGT! BEUTE IM NÄCHSTEN SHOP')
	game.sound('elite_reward')
func end_run():
	hazards.clear();rewards.clear();boss_lock=false;notice='';notice_time=0
func claim(id:String,choice:String) -> bool:
	if game.state!=game.State.SHOP or rewards.is_empty() or rewards[0].id!=id or not choice in ['damage','vital','coins']:return false
	var reward=rewards.pop_front()
	match choice:
		'damage':game.damage_mult+=float(data.reward_damage)
		'vital':game.max_hp+=int(data.reward_hp);game.hp=minf(game.max_hp,game.hp+int(data.reward_hp))
		'coins':
			var amount=int(data.reward_coins)+int(reward.wave)*2;game.coins+=amount;game.earned+=amount
	game.sound('buy');game.show_shop();return true
func reward_screen():
	if rewards.is_empty():return
	var reward=rewards[0]
	game.backdrop('ELITE-BEUTE','Du hast '+str(data[reward.kind].name)+' besiegt. Wähle eine Belohnung.')
	var choices=[['damage','KAMPFTRAINING','+5 % Basis-Schaden für diesen Run'],['vital','PANZERRESERVE','+10 maximale HP und +10 aktuelle HP'],['coins','SCHROTTDEPOT','+%d Coins für deinen nächsten Einkauf' % (int(data.reward_coins)+int(reward.wave)*2)]]
	for i in range(3):
		var x=100+i*580;var c=choices[i]
		game.UISkin.panel(game,Rect2(x,275,530,540),Color('#FFD166'))
		game.UISkin.image(game,game.UISkin.Icons.get_icon(c[0]),Rect2(x+25,305,135,135))
		game.label_at(c[1],Vector2(x+25,470),36,game.GOLD)
		var description=game.label_at(c[2],Vector2(x+25,540),26)
		description.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;description.set_deferred('size',Vector2(475,100))
		game.button('BEUTE SICHERN',Vector2(x+25,690),Vector2(480,100),func():claim(reward.id,c[0]),Color('#623C7D'))
func add_ring(origin:Vector2,radius:float,width:float,gap_angle:float,gap:float,warm:float,duration:float,damage:float,source:String,owner:Dictionary={}):
	hazards.append({'shape':'ring','origin':origin,'radius':radius,'width':width,'angle':gap_angle,'gap':gap,'warm':warm,'duration':duration,'damage':damage,'age':0.0,'source':source,'owner':owner})
func add_circle(pos:Vector2,radius:float,warm:float,damage:float):
	hazards.append({'shape':'circle','origin':pos,'radius':radius,'warm':warm,'duration':.35,'damage':damage,'age':0.0,'source':'boss'})
func add_lane(vertical:bool,at:float,warm:float):
	hazards.append({'shape':'lane','rect':Rect2(at-34,0,68,1600) if vertical else Rect2(0,at-34,2400,68),'warm':warm,'duration':.4,'damage':14.0,'age':0.0,'source':'boss'})
func contains(h:Dictionary,pos:Vector2) -> bool:
	if h.shape=='lane':return h.rect.grow(27).has_point(pos)
	var delta:Vector2=pos-h.origin
	if h.shape=='circle':return delta.length()<=h.radius+27
	if absf(delta.length()-float(h.radius))>float(h.width)+27:return false
	# Conservative angular margin ensures players fully fitting inside the visible gap stay safe.
	return absf(wrapf(delta.angle()-float(h.angle),-PI,PI))>=float(h.gap)*.5
func update(dt:float):
	if not enabled or game.state!=game.State.COMBAT:return
	notice_time=maxf(0,notice_time-dt)
	for i in range(hazards.size()-1,-1,-1):
		var h=hazards[i];var previous:float=h.age;h.age+=dt
		if h.age>=h.warm and previous<h.warm+h.duration and contains(h,game.player.position):
			game.hurt(h.damage)
			if game.state!=game.State.COMBAT:return
		if previous<h.warm and h.age>=h.warm:
			if h.shape=='ring':game.sound('ability_impulse') # Never cover a safe gap with a full-circle explosion.
			else:
				var at:Vector2=h.origin if h.shape=='circle' else h.rect.get_center()
				if h.shape=='lane':
					if h.rect.size.x<h.rect.size.y:at.y=game.player.position.y
					else:at.x=game.player.position.x
				game.vfx.ground_impact(at,float(h.get('radius',70)),Color('#FFD166'))
		if h.age>=h.warm+h.duration:hazards.remove_at(i)
	if game.wave_number!=10:return
	var boss:Dictionary={}
	for e in game.enemies:
		if e.kind=='boss' and e.hp>0:boss=e;break
	if boss.is_empty():return
	var ratio:float=boss.hp/boss.max_hp
	var tier=3 if ratio<=float(data.boss_thresholds[1]) else (2 if ratio<=float(data.boss_thresholds[0]) else 1)
	if tier>boss_tier:
		boss_tier=tier;interrupt_base(true);hazards.clear();recovery=1.25;boss_lock=true;special_clock=0
		first_special=true;special_number=1 if tier==3 else 0
		warn('BOSSPHASE %d: %s' % [tier,'KERNKOLLAPS' if game.is_reactor() else 'SCHROTTSTURM']);game.sound('boss_phase');return
	if boss_tier==1:return
	if recovery>0:
		recovery=maxf(0,recovery-dt);boss_lock=recovery>0;return
	var active=false
	for h in hazards:
		if h.source=='boss':active=true;break
	if active:boss_lock=true;return
	if boss_lock:
		boss_lock=true;recovery=data.boss_recovery;game.boss_warning='';special_clock=data.boss_special_cooldown
		return
	special_clock=maxf(0,special_clock-dt)
	if special_clock>0 or not visible(boss.pos):return
	if game.is_reactor() and game.reactor_guardian.stage!='recovery':return
	if not game.is_reactor() and (game.boss_phase%2==1 or game.boss_charging or (not first_special and game.boss_clock>.35)):return
	interrupt_base();boss_lock=true;first_special=false;special_number+=1
	var origin:Vector2=boss.pos;var target:Vector2=game.player.position
	if boss_tier>=3 and special_number%2==0:
		add_ring(origin,230 if not game.is_reactor() else 210,28,(target-origin).angle()+PI*.5,1.65,1.6,.4,16,'boss')
		game.boss_warning='IMPULSRING: DURCH DIE LEUCHTENDE ÖFFNUNG!'
	elif game.is_reactor():
		add_lane(true,target.x,1.65);add_lane(false,target.y,1.65)
		game.boss_warning='REAKTORBRUCH: KREUZMARKIERUNG VERLASSEN!'
	else:
		for offset in [Vector2.ZERO,Vector2(-170,90),Vector2(170,90)]:add_circle((target+offset).clamp(Vector2(110,110),Vector2(2290,1490)),74,1.5,14)
		game.boss_warning='TRÜMMERFELD: GOLDENE MARKIERUNGEN VERLASSEN!'
	game.sound('boss_phase')
func interrupt_base(phase_change:bool=false):
	game.boss_clock=3.0;game.boss_charging=false;game.boss_warning=''
	if phase_change:
		game.boss_phase=0;game.reactor_guardian.clear()
	else:
		# Keep the base attack cursor: specials must not starve charge/fan/bomb patterns.
		game.reactor_guardian.stage='recovery';game.reactor_guardian.clock=2.0
	game.arena_hazards.items.clear()
	for shot in game.shots:
		if shot.active and shot.hostile:shot.active=false
func draw_floor():
	if not enabled:return
	for h in hazards:
		var active=h.age>=h.warm;var color=Color('#FF4757') if active else Color('#FFD166')
		if h.shape=='lane':
			game.draw_rect(h.rect,Color(color,.28 if active else .10));game.draw_rect(h.rect,color,false,3,true)
		elif h.shape=='circle':
			game.draw_circle(h.origin,h.radius,Color(color,.30 if active else .1));game.draw_arc(h.origin,h.radius,0,TAU,48,color,3,true)
		else:draw_ring(h.origin,h.radius,h.width,h.angle,h.gap,color,.34 if active else .13)
func draw_ring(origin:Vector2,radius:float,width:float,angle:float,gap:float,color:Color,alpha:float):
	var start=angle+gap*.5;var end=angle+TAU-gap*.5
	game.draw_arc(origin,radius,start,end,64,Color(color,alpha),width*2,true)
	game.draw_arc(origin,radius-width,start,end,64,color,3,true);game.draw_arc(origin,radius+width,start,end,64,color,3,true)
	for side in [-1,1]:
		var edge=origin+Vector2.from_angle(angle+gap*.5*side)*radius
		game.draw_circle(edge,9,Color('#41F4DE'))
	var center=origin+Vector2.from_angle(angle)*radius
	game.draw_arc(center,18,0,TAU,24,Color('#41F4DE'),3,true)
func draw_elite(e:Dictionary):
	if e.kind=='boss' and boss_tier>1:
		var tint=Color('#41F4DE') if game.is_reactor() else Color('#FFAD42')
		game.draw_arc(e.pos,e.radius+18,0,TAU,48,Color(tint,.65),3,true)
		for i in range(boss_tier):game.draw_circle(e.pos+Vector2((i-(boss_tier-1)*.5)*18,-e.radius*2.2),5,tint)
	if not e.has('elite'):return
	var color=Color(data[e.elite].color)
	game.draw_arc(e.pos,e.radius+10,0,TAU,40,Color(color,.8),3,true)
	var at:Vector2=e.pos+Vector2(0,-e.radius*2.6)
	game.draw_colored_polygon(PackedVector2Array([at+Vector2(-13,0),at+Vector2(-15,-19),at+Vector2(-5,-12),at+Vector2(0,-25),at+Vector2(5,-12),at+Vector2(15,-19),at+Vector2(13,0)]),color)
	if e.elite_stage!='windup':return
	var progress=1-clampf(e.elite_clock/float(data[e.elite].windup),0,1)
	game.draw_arc(e.pos,e.radius+17,-PI*.5,-PI*.5+TAU*progress,36,Color('#FFD166'),5,true)
	if e.elite=='pulse':draw_ring(e.elite_origin,data.pulse.radius,data.pulse.width,e.elite_gap,data.pulse.gap,Color('#FFD166'),.12)
	else:
		var direction:Vector2=(e.elite_target-e.elite_origin).normalized();var normal=direction.orthogonal()*(e.radius+20)
		game.draw_colored_polygon(PackedVector2Array([e.elite_origin+normal,e.elite_target+normal,e.elite_target-normal,e.elite_origin-normal]),Color(1,.8,.3,.14))
		game.draw_line(e.elite_origin+normal,e.elite_target+normal,Color('#FFD166'),3,true)
		game.draw_line(e.elite_origin-normal,e.elite_target-normal,Color('#FFD166'),3,true)
		game.draw_arc(e.elite_target,e.radius+20,0,TAU,32,Color('#FFD166'),3,true)
func draw_notice(canvas:Control):
	if notice_time<=0:return
	var font=game.UISkin.HEADING
	canvas.draw_style_box(game.style(Color('#271B3F')),Rect2(630,920+game.safe_logical.end.y-1080,660,60))
	canvas.draw_string(font,Vector2(645,961+game.safe_logical.end.y-1080),notice,HORIZONTAL_ALIGNMENT_CENTER,630,26,game.GOLD)

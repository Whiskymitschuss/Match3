extends RefCounted
const R=preload('res://scripts/core/roster.gd')
var game:Node2D
var ladder:Dictionary
var stage='chase'
var clock=2.5
var tier=1
var pattern=0
var attack=''
var origin=Vector2.ZERO
var target=Vector2.ZERO
var hit=false
var signatures
const ATTACK_NAMES={'ring':'IMPULSRING','fan':'PROJEKTILFÄCHER','charge':'ANSTURM','zones':'ARENA-ANGRIFF'}
func _init(g:Node2D):game=g;ladder=game.read_data('waves/boss_ladder');signatures=preload('res://scripts/bosses/signature_moves.gd').new(game)
func slot() -> int:return ((game.wave_number-1)%10)+1
func scheduled() -> bool:return game.united.enabled and game.run_mode!='tutorial' and slot()%2==0
func profile() -> Dictionary:
	var s=slot();var d:Dictionary
	if s==6:d=game.breaker.data.duplicate(true);d.boss_art=0;d.pattern='drill';d.name='BREAKER AXEL';d.duration=75
	elif s==10:d={'name':game.arena_definition.boss_name,'hp':6000.0,'speed':78.0,'damage':20.0,'radius':78.0,'xp':150,'coins':150,'boss_art':int(game.arena_definition.get('boss_art',4)),'pattern':game.arena_definition.get('event',{'scrapyard':'debris','reactor':'storm','docks':'tide','foundry':'fire'}.get(game.arena_id,'storm')),'duration':90,'color':game.arena_definition.get('boss',{}).get('color','#FF9F1C')}
	else:d=ladder.get(str(s),ladder['2']).duplicate(true);d.boss_art=int(d.art);d.color='#C68CFF'
	for property in ['hp','speed']:
		if ladder.get(str(s),{}).has(property):d[property]=ladder[str(s)][property]
	var rank=int(game.arena_definition.get('rank',0));d.hp=roundf(float(d.hp)*(1+rank*.08));d.damage=float(d.damage)*(1+rank*.035)
	return d
func actor() -> Dictionary:
	for e in game.enemies:
		if e.kind in ['boss','champion'] and e.hp>0:return e
	return {}
func clear():stage='chase';clock=float(ladder.cadence.opening_delay);tier=1;pattern=0;attack='';hit=false
func rage(e:Dictionary) -> bool:return game.breaker.tier==3 if e.kind=='breaker_axel' else (tier==3 and R.BOSS_KINDS.has(e.kind))
func touch_damage(e:Dictionary) -> float:return e.damage*(1.15 if tier==3 else 1.0)
func update(dt:float):
	if not scheduled() or slot()==6 or game.state!=game.State.COMBAT:return
	var e=actor()
	if e.is_empty():return
	var next=3 if e.hp/e.max_hp<=.35 else (2 if e.hp/e.max_hp<=.7 else 1)
	if next>tier and stage not in ['windup','dash','salvo']:
		game.vfx.event('power_burst',e.pos,Color('#FF9F1C'),e.radius*2.2,Vector2.RIGHT,.6)
		tier=next;stage='phase';clock=float(ladder.cadence.phase_pause);game.sound('united_rage');game.encounters.warn('%s / PHASE %d' % [e.boss_name,tier]);return
	if float(e.get('steel_stun',0))>0:return
	if stage in ['windup','dash','salvo'] and (not game.enemy_roles.visible(e.pos) or (stage=='windup' and e.pos.distance_to(origin)>8)):
		game.united.enemies.removed(e);stage='recovery';clock=2;return
	clock=maxf(0,clock-dt)
	if clock>0:return
	if stage in ['chase','recovery','phase']:
		if not game.enemy_roles.visible(e.pos):return
		origin=e.pos;target=game.player.position;hit=false;attack=attack_order(e)[pattern%4];pattern+=1;stage='windup';clock=1.5
		game.boss_warning={'ring':'IMPULSRING / GRÜNE ÖFFNUNG NUTZEN','fan':'PROJEKTILFÄCHER / SEITLICH AUSWEICHEN','charge':'STURMSPUR VERLASSEN','zones':'MARKIERUNGEN VERLASSEN'}.get(attack,'SPEZIALANGRIFF');game.sound('united_warning')
		if signatures.prepare(e,attack):return
		if attack=='charge':target=(origin+origin.direction_to(target)*440).clamp(Vector2(40,40),Vector2(2360,1560))
		if attack=='ring':game.united.enemies.ring(origin,230+(45 if tier==3 else 0),origin.direction_to(target).angle()+PI*.5,1.5,touch_damage(e),e)
		if attack=='zones':
			var arena_warm=game.arena_mechanics.boss_zones(e,target)
			if arena_warm>0:
				clock=arena_warm;game.boss_warning=game.arena_mechanics.zone_title().to_upper()+' / GELBE MARKIERUNGEN VERLASSEN'
			elif e.boss_pattern in ['storm','frost','void']:
				game.united.enemies.lane(true,target.x,1.5,touch_damage(e),e);game.united.enemies.lane(false,target.y,1.5,touch_damage(e),e)
			else:
				for offset in [Vector2.ZERO,Vector2(-180,100),Vector2(180,-100)]:game.united.enemies.circle((target+offset).clamp(Vector2(100,100),Vector2(2300,1500)),90,1.5,1.6 if e.boss_pattern=='poison' else .4,touch_damage(e)*.75,e,Color('#C48AFF'),'slow' if e.boss_pattern=='frost' else '')
	elif stage=='salvo':signatures.pulse(e)
	elif stage=='windup':
		if signatures.owns(attack):signatures.release(e,attack);return
		if attack=='fan':
			var angle:float=origin.direction_to(target).angle()
			for i in range(7+(2 if tier==3 else 0)):
				game.shoot(origin,Vector2.from_angle(angle+(i-(3 if tier<3 else 4))*.17),touch_damage(e)*.7,true,250,3.2,'united_boss')
		if attack=='charge':stage='dash';clock=2.5
		else:stage='recovery';clock=float(ladder.cadence.recovery[tier-1]);game.boss_warning=''
	else:stage='recovery';clock=float(ladder.cadence.recovery[tier-1])
func velocity(e:Dictionary,normal:Vector2,dt:float) -> Vector2:
	if stage in ['windup','phase','salvo']:return Vector2.ZERO
	if stage=='dash':return e.pos.direction_to(target)*minf(470,e.pos.distance_to(target)/maxf(.0001,dt))
	return normal*(1.3 if tier==3 else 1.0)
func after_move(e:Dictionary,before:Vector2,after:Vector2):
	if stage!='dash':return
	if not hit and Geometry2D.get_closest_point_to_segment(game.player.position,before,after).distance_to(game.player.position)<e.radius+27:hit=true;game.breaker.hit(touch_damage(e),before,260,.18)
	if game.state==game.State.COMBAT and after.distance_to(target)<1:
		stage='recovery';clock=float(ladder.cadence.charge_recovery);game.boss_warning=''
		if tier>=2:game.united.enemies.ring(after,220,after.direction_to(game.player.position).angle()+PI*.5,1.5,touch_damage(e),e)
func draw():
	if stage!='windup' or actor().is_empty():return
	if attack in ['charge','crusher_ram']:
		var side:Vector2=origin.direction_to(target).orthogonal()*(actor().radius+27)
		game.draw_colored_polygon(PackedVector2Array([origin+side,target+side,target-side,origin-side]),Color(1,.7,.2,.15));game.draw_line(origin+side,target+side,Color('#FFD166'),3,true);game.draw_line(origin-side,target-side,Color('#FFD166'),3,true)
	elif attack=='fan':
		var angle:float=origin.direction_to(target).angle()
		var count=9 if tier==3 else 7
		for i in range(count):
			var ray=Vector2.from_angle(angle+(i-(count-1)*.5)*.17)
			game.draw_line(origin,origin+ray*600,Color(1,.8,.3,.55),3,true)
	signatures.draw()
	var left=maxf(0,clock);var value='%s / %.1f s' % [signatures.NAMES.get(attack,ATTACK_NAMES.get(attack,'ANGRIFF')),left]
	var font=game.UISkin.HEADING;var width=font.get_string_size(value,HORIZONTAL_ALIGNMENT_LEFT,-1,23).x
	var at=origin+Vector2(-width*.5,-actor().radius-40)
	game.draw_rect(Rect2(at-Vector2(8,26),Vector2(width+16,36)),Color('#101423'));game.draw_string(font,at,value,HORIZONTAL_ALIGNMENT_LEFT,-1,23,game.GOLD)
func hint() -> String:
	if stage=='phase':return 'PHASENWECHSEL / %.1f s' % maxf(0,clock)
	if stage=='windup':return boss_instruction()+' / %.1f s' % maxf(0,clock)
	if stage=='salvo':return 'GEWITTERSPIRALE / IN BEWEGUNG BLEIBEN'
	if stage=='dash':return 'ANSTURM / STURMSPUR VERLASSEN'
	if stage=='recovery':return 'ERHOLUNG / DEIN ANGRIFFSFENSTER %.1f s' % maxf(0,clock)
	return 'VERFOLGUNG / FLUCHTWEG FREIHALTEN'
func boss_instruction() -> String:
	if signatures.owns(attack):return signatures.NAMES[attack]
	if attack=='zones' and slot()==10 and game.arena_mechanics.worlds.IDS.has(game.arena_id):
		return game.arena_mechanics.zone_title().to_upper()+(' / INNEN SICHER' if game.arena_id in ['frost','void'] else ' / MARKIERUNG VERLASSEN')
	return {'ring':'IMPULSRING / GRÜNE ÖFFNUNG','fan':'FÄCHER / SEITLICH AUSWEICHEN','charge':'ANSTURM / SPUR VERLASSEN','zones':'ARENA-ANGRIFF / MARKIERUNG VERLASSEN'}.get(attack,'VORWARNUNG')
func intro():
	var d=profile();var art=preload('res://scripts/expansion/comic_art.gd')
	game.backdrop('BOSSWELLE %d / 10' % slot(),d.name+' / '+game.arena_definition.name)
	var texture=AtlasTexture.new();texture.atlas=art.BOSSES;texture.region=art.boss_region(d.boss_art);game.UISkin.image(game,texture,Rect2(110,265,620,680))
	game.UISkin.panel(game,Rect2(790,280,1010,590),Color('#FF9F45'))
	game.label_at(d.name,Vector2(825,315),55,game.GOLD)
	var actual=game.rules.scale_stats(game.WaveBalance.stats(d,game.rules.current_wave(),game.wave_number,true),true)
	game.label_at('%d HP / %.0f Kontaktschaden' % [roundi(actual.hp),actual.damage],Vector2(825,380),26,game.TEAL)
	var moves=signatures.order() if slot()!=6 else []
	if not moves.is_empty():game.label_at(signatures.NAMES[moves[0]]+'\n'+signatures.NAMES[moves[1]],Vector2(825,745),23,game.TEAL)
	game.label_at('WELLE %d / %.0f SEKUNDEN LIMIT\n\nGelb: Angriff wird vorbereitet.\nGrüne Ringöffnung: sicherer Durchgang.\n\nPhasen bei 70 %% und %d %% Leben.\nEin Sieg führt zum %s.' % [slot(),d.duration,40 if slot()==6 else 35,'Arenenabschluss' if slot()==10 else 'Shop'],Vector2(825,440),30)
	game.button('KAMPF STARTEN',Vector2(825,930),Vector2(920,100),func():game.queue_ui_action(game.begin_wave),Color('#8A432E'))

func attack_order(_e:Dictionary) -> Array:
	return signatures.order()
func weapon_factor(w:Dictionary) -> float:
	if not game.united.enabled:return 1.0
	return float(game.Specs.definition(w).get('boss_power',game.weapon_data[w.id].get('boss_power',1.0)))
func weapon_power(w:Dictionary,e:Dictionary,power:float) -> float:
	return power*weapon_factor(w) if R.BOSS_KINDS.has(e.kind) else power

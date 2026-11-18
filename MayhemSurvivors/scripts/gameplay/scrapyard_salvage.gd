extends RefCounted
# A voluntary, once-per-wave contract. Only COMBAT advances it; no extra combat RNG.
var game:Node2D
var phase='idle'
var position=Vector2.ZERO
var held=0.0
var age=0.0
var pulses=0
var completed=0
var total_coins=0
const HOLD=1.2
const RADIUS=78.0
const DURATION=7.0
func _init(g:Node2D):game=g
func available() -> bool:
	return game.united.enabled and game.arena_events.enabled and game.arena_id=='scrapyard' and game.run_mode=='campaign' and not game.rules.boss_wave() and game.wave_number>=3
func clear():phase='idle';held=0;age=0;pulses=0
func reset_run():clear();completed=0;total_coins=0
func reward() -> int:return 20+game.wave_number*4
func update(dt:float):
	if game.state!=game.State.COMBAT or not available():return
	if phase=='idle':
		if float(game.rules.current_wave().duration)-game.remaining<24 or game.remaining<12:return
		var offset=Vector2(-260 if game.player.position.x>1200 else 260,100 if game.player.position.y<250 else -100)
		position=(game.player.position+offset).clamp(Vector2(160,180),Vector2(2240,1420))
		phase='offered';game.encounters.warn('BERGUNG FREI / OPTIONAL / IM TÜRKISEN KREIS KURZ ANHALTEN');game.sound('salvage_offer')
	elif phase=='offered':
		if game.remaining<10:phase='expired';held=0;return
		held=minf(HOLD,held+dt) if game.player.position.distance_to(position)<=RADIUS and game.move_input.length_squared()<.04 else 0.0
		if held>=HOLD:
			phase='active';age=0;pulses=0;game.arena_events.active=true
			game.encounters.warn('BERGUNG LÄUFT / GELBE EINSCHLÄGE VERLASSEN / +%d RUN-COINS' % reward());game.sound('salvage_start');pulse()
	elif phase=='active':
		age+=dt
		if age>=3 and pulses==1:pulse()
		if age>=DURATION and game.arena_hazards.items.all(func(h):return not h.get('salvage',false)):
			# Set the terminal state before awarding; re-entry cannot duplicate the reward.
			phase='complete';game.arena_events.active=false;completed+=1;game.run_events+=1
			var value=reward();total_coins+=value;game.coins+=value;game.earned+=value
			game.vfx.coin(position,value);game.sound('salvage_complete');game.encounters.warn('BERGUNG GESICHERT / +%d RUN-COINS' % value)
func pulse():
	var at:Vector2=game.player.position
	for offset in [Vector2.ZERO,Vector2(-185,125),Vector2(185,-125)]:
		game.arena_hazards.bomb((at+offset).clamp(Vector2(110,110),Vector2(2290,1490)),90,1.8)
		var hazard=game.arena_hazards.items.back();hazard.damage=12;hazard.salvage=true
	pulses+=1
func draw():
	if phase=='idle' or not available():return
	var color=Color('#8F96AB') if phase=='expired' else Color('#00D9D0') if phase=='offered' else (Color('#FFD166') if phase=='active' else Color('#2ED573'))
	game.draw_circle(position,RADIUS,Color(color,.09))
	game.draw_arc(position,RADIUS,0,TAU,40,Color(color,.75),3,true)
	if phase=='offered' and held>0:game.draw_arc(position,RADIUS+7,-PI/2,-PI/2+TAU*held/HOLD,32,Color.WHITE,6,true)
	if phase=='active':game.draw_arc(position,RADIUS+7,-PI/2,-PI/2+TAU*minf(1,age/DURATION),32,color,6,true)
	# Original compact salvage terminal: steel crate, lid, hinges, coin insignia.
	game.draw_style_box(game.UISkin.box(Color('#183B47'),color),Rect2(position-Vector2(35,29),Vector2(70,58)))
	game.draw_line(position+Vector2(-34,-10),position+Vector2(34,-10),color,4,true)
	for x in [-23,23]:game.draw_line(position+Vector2(x,-21),position+Vector2(x,20),Color('#ADB9C8'),5,true)
	game.draw_circle(position+Vector2(0,8),12,Color('#FFD166'))
	game.draw_line(position+Vector2(0,0),position+Vector2(0,16),Color('#7C4B1B'),3,true)
	var label='BERGUNG +%d' % reward() if phase=='offered' else ('AUSWEICHEN / %.0f s' % maxf(0,DURATION-age) if phase=='active' else ('ZEITFENSTER ZU' if phase=='expired' else 'GESICHERT'))
	var width=game.UISkin.HEADING.get_string_size(label,HORIZONTAL_ALIGNMENT_LEFT,-1,22).x
	var at=position+Vector2(-width/2,-106)
	game.draw_rect(Rect2(at-Vector2(9,24),Vector2(width+18,34)),Color('#111324'))
	game.draw_string(game.UISkin.HEADING,at,label,HORIZONTAL_ALIGNMENT_LEFT,-1,22,color)
	if phase=='offered':game.draw_string(game.UISkin.BODY,position+Vector2(-76,116),'ANHALTEN: 1,2 s',HORIZONTAL_ALIGNMENT_LEFT,-1,19,Color.WHITE)

extends RefCounted
# Attack identities are gameplay patterns, not merely recoloured fan attacks.
const PAIRS={
 'scrapyard':['scrap_magnets','scrap_shred'], 'reactor':['reactor_pylons','reactor_overload'],
 'docks':['dock_anchors','dock_broadside'], 'foundry':['forge_fountains','forge_embers'],
 'gardens':['garden_bloom','garden_seeds'], 'frost':['frost_eye','frost_shards'],
 'storm':['storm_spiral','storm_rod'], 'crystal':['crystal_prism','crystal_mirrors'],
 'carnival':['carnival_roulette','carnival_balloons'], 'void':['void_portals','void_eclipse']}
const NAMES={
 'acid_lob':'SÄURENESTER / KREISE VERLASSEN','acid_spit':'DOPPELSPUCKER / ZWISCHEN DEN KUGELN',
 'crusher_ram':'WALZENRAMME / SEITLICH AUSWEICHEN','crusher_quake':'TRÜMMERBEBEN / RINGÖFFNUNG',
 'admiral_broadside':'KANONENBREITSEITE / LÜCKEN NUTZEN','admiral_mines':'SEEMINEN / MARKIERUNGEN VERLASSEN',
 'scrap_magnets':'MAGNETFALLEN / MITTE FREIHALTEN','scrap_shred':'SCHROTTSCHERE / V-FÄCHER',
 'reactor_pylons':'SPULENKÄFIG / IN DER MITTE BLEIBEN','reactor_overload':'REAKTORÜBERLAST / ZWISCHEN DEN SPEICHEN',
 'dock_anchors':'ANKERFALL / KREISE VERLASSEN','dock_broadside':'DOPPELBREITSEITE / LÜCKEN NUTZEN',
 'forge_fountains':'KREUZDAMPF / BAHNEN VERLASSEN','forge_embers':'SCHLACKENREGEN / SEITLICH LAUFEN',
 'garden_bloom':'DORNENBLÜTE / BLÜTENBLÄTTER MEIDEN','garden_seeds':'SAMENSCHLEUDER / ZWEI VERSATZTE FÄCHER',
 'frost_eye':'FROSTAUGE / GRÜNE RINGÖFFNUNG','frost_shards':'EISSPLITTER / DREI SPEERE',
 'storm_spiral':'GEWITTERSPIRALE / IN BEWEGUNG BLEIBEN','storm_rod':'BLITZABLEITER / ZIELPUNKTE VERLASSEN',
 'crystal_prism':'PRISMA / DREI GETRENNTE FÄCHER','crystal_mirrors':'SPIEGELFALL / ZWISCHEN DEN KRISTALLEN',
 'carnival_roulette':'TODESSROULETTE / GROSSE LÜCKE SUCHEN','carnival_balloons':'KNALLBALLONS / KREISE VERLASSEN',
 'void_portals':'DREI PORTALE / SPUR VERLASSEN','void_eclipse':'FINSTERNIS / GRÜNE RINGÖFFNUNG'}
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
func _init(g:Node):game_ref=weakref(g)
func order() -> Array:
	var slot=game.united.bosses.slot()
	if slot==2:return ['acid_lob','acid_spit','acid_lob','acid_spit']
	if slot==4:return ['crusher_ram','crusher_quake','crusher_ram','crusher_quake']
	if slot==8:return ['admiral_broadside','admiral_mines','admiral_broadside','admiral_mines']
	var p=PAIRS.get(game.arena_id,PAIRS.scrapyard);return [p[0],p[1],p[0],p[1]]
func owns(id:String) -> bool:return NAMES.has(id)
func color(id:String) -> Color:
	if id.begins_with('acid') or id.begins_with('garden'):return Color('#9AE852')
	if id.begins_with('frost') or id.begins_with('crystal'):return Color('#8FE8FF')
	if id.begins_with('forge') or id.begins_with('crusher'):return Color('#FF9F45')
	if id.begins_with('storm') or id.begins_with('reactor'):return Color('#52E9EE')
	if id.begins_with('void') or id.begins_with('carnival'):return Color('#EB78F6')
	return Color('#FFD166')
func prepare(e:Dictionary,id:String) -> bool:
	if not owns(id):return false
	var b=game.united.bosses;b.clock=1.8;game.boss_warning=NAMES[id]
	var at:Vector2=b.target;var c=color(id);var power:float=b.touch_damage(e)
	if id=='forge_fountains':
		b.clock=game.arena_mechanics.boss_zones(e,at);return true
	if id=='crusher_ram':b.target=(b.origin+b.origin.direction_to(at)*490).clamp(Vector2(65,65),Vector2(2335,1535));b.clock=1.6
	elif id in ['crusher_quake','frost_eye','void_eclipse']:
		game.united.enemies.ring(b.origin,260 if id!='void_eclipse' else 320,b.origin.direction_to(at).angle()+PI*.5,b.clock,power,e)
	elif id in ['acid_lob','dock_anchors','admiral_mines','forge_fountains','garden_bloom','reactor_pylons','storm_rod','crystal_mirrors','carnival_balloons','void_portals','scrap_magnets']:
		var offsets=[];var radius=75.0;var duration=.35
		match id:
			'acid_lob':offsets=[Vector2.ZERO,Vector2(-150,70),Vector2(150,-70)];duration=1.3
			'dock_anchors':offsets=[Vector2.ZERO,Vector2(0,-200)];radius=110
			'admiral_mines':offsets=[Vector2(-160,0),Vector2.ZERO,Vector2(160,0)];radius=62;duration=1.2
			'forge_fountains':offsets=[Vector2(-210,-140),Vector2(210,-140),Vector2(-210,140),Vector2(210,140)];radius=95;duration=1.0
			'garden_bloom':
				for i in range(5):offsets.append(Vector2.from_angle(i*TAU/5)*175)
				duration=1.1
			'reactor_pylons':offsets=[Vector2(-160,0),Vector2(160,0),Vector2(0,-160),Vector2(0,160)];radius=65
			'storm_rod':offsets=[Vector2.ZERO,Vector2(-210,130),Vector2(210,-130)];radius=55;b.clock=2.0
			'crystal_mirrors':offsets=[Vector2(-190,-110),Vector2(190,-110),Vector2(0,210)];radius=100
			'carnival_balloons':offsets=[Vector2(-220,0),Vector2(-110,-170),Vector2(0,90),Vector2(110,-170),Vector2(220,0)];radius=65
			'void_portals':
				var dir=b.origin.direction_to(at);offsets=[-dir*180,Vector2.ZERO,dir*180];radius=90
			'scrap_magnets':offsets=[Vector2(-180,-120),Vector2(180,120)];radius=115;duration=.7
		for offset in offsets:
			game.united.enemies.circle((at+offset).clamp(Vector2(120,120),Vector2(2280,1480)),radius,b.clock,duration,power*.8,e,c)
			game.united.enemies.hazards.back().signature=id
	return true
func rays(id:String) -> Array:
	var b=game.united.bosses;var aim:Vector2=b.origin.direction_to(b.target);var result=[]
	var angle=aim.angle()
	match id:
		'acid_spit':
			for sign in [-1,1]:result.append({'at':b.origin+aim.orthogonal()*42*sign,'dir':aim.rotated(sign*.11),'speed':200.0})
		'scrap_shred':
			for i in [-3,-2,2,3]:result.append({'at':b.origin,'dir':aim.rotated(i*.15),'speed':300.0})
		'dock_broadside','admiral_broadside':
			for side in [-1,1]:
				for i in [-1,0,1]:result.append({'at':b.origin+aim.orthogonal()*65*side,'dir':aim.rotated(i*.23),'speed':260.0})
		'forge_embers':
			for i in range(5):result.append({'at':b.origin+Vector2((i-2)*45,0),'dir':aim.rotated((i-2)*.25),'speed':180.0+i*18})
		'garden_seeds':
			for row in range(2):
				for i in [-1,0,1]:result.append({'at':b.origin+aim*row*55,'dir':aim.rotated(i*.34+.12*row),'speed':210.0+row*65})
		'frost_shards':
			for i in [-1,0,1]:result.append({'at':b.origin,'dir':aim.rotated(i*.42),'speed':360.0})
		'reactor_overload':
			for i in range(10):result.append({'at':b.origin,'dir':Vector2.from_angle(i*TAU/10+b.pattern*.21),'speed':235.0})
		'crystal_prism':
			for side in [-1,0,1]:
				for i in [-1,0,1]:result.append({'at':b.origin,'dir':aim.rotated(side*1.1+i*.12),'speed':280.0})
		'carnival_roulette':
			for i in range(16):
				if i in [0,1,2,3]:continue
				result.append({'at':b.origin,'dir':Vector2.from_angle(angle+i*TAU/16+b.pattern*.17),'speed':215.0})
	return result
func release(e:Dictionary,id:String):
	var b=game.united.bosses
	if id=='crusher_ram':b.stage='dash';b.clock=2.5;return
	if id=='storm_spiral':e.sig_left=5;e.sig_index=0;b.stage='salvo';b.clock=.01;return
	for ray in rays(id):game.shoot(ray.at,ray.dir,b.touch_damage(e)*.7,true,ray.speed,3.8,'sig_'+id)
	game.vfx.event('power_burst',b.origin,color(id),90,Vector2.RIGHT,.35);game.sound('signature_blast')
	b.stage='recovery';b.clock=1.8;game.boss_warning=''
func pulse(e:Dictionary):
	var b=game.united.bosses
	for i in range(5):game.shoot(e.pos,Vector2.from_angle(i*TAU/5+e.sig_index*.29),b.touch_damage(e)*.6,true,240,3.4,'sig_storm_spiral')
	e.sig_index+=1;e.sig_left-=1;b.clock=.22
	if e.sig_left<=0:b.stage='recovery';b.clock=2.2
func draw():
	var b=game.united.bosses
	if b.stage!='windup' or not owns(b.attack):return
	for ray in rays(b.attack):game.draw_line(ray.at,ray.at+ray.dir*570,Color('#FFD166')*Color(1,1,1,.42),2,true)
	if b.attack=='storm_spiral':game.draw_arc(b.origin,120,0,TAU,32,Color('#FFD166'),4,true)

extends RefCounted
const Art=preload('res://scripts/expansion/comic_art.gd')
const R=preload('res://scripts/core/roster.gd')
var game:Node2D
var enabled=true
var heroes
var enemies
var bosses
func _init(g:Node2D):
	game=g;heroes=preload('res://scripts/expansion/hero_combat.gd').new(g);enemies=preload('res://scripts/expansion/enemy_roster.gd').new(g);bosses=preload('res://scripts/expansion/boss_director.gd').new(g)
func clear():heroes.clear();enemies.clear();bosses.clear()
func update(dt:float):
	if not enabled:return
	heroes.update(dt)
	if game.state!=game.State.COMBAT:return
	enemies.update(dt)
	if game.state!=game.State.COMBAT:return
	bosses.update(dt)
func draw_shot(s:Dictionary) -> bool:
	if s.weapon not in ['cryo','chakram','pyro','united_boss']:return false
	var color=Color('#98F5FF') if s.weapon=='cryo' else Color('#FF9B52')
	if s.weapon=='chakram':
		game.draw_set_transform(s.pos,float(s.get('united_age',0))*12);game.draw_texture_rect_region(Art.WEAPONS,Rect2(-17,-17,34,34),Art.weapon('chakram'));game.draw_set_transform(Vector2.ZERO)
	else:
		var dir:Vector2=s.vel.normalized();game.draw_line(s.pos-dir*25,s.pos,Color(color,.4),7,true);game.draw_circle(s.pos,9,Color('#111324'));game.draw_circle(s.pos,6,color);game.draw_circle(s.pos,2,Color.WHITE)
	return true
func event_update(event,dt:float):
	if not event.triggered:
		if float(game.rules.current_wave().duration)-game.remaining<24 or enemies.hazards.size()>=2:return
		event.triggered=true;event.active=true;event.age=0;event.pulse=0;game.encounters.warn(game.arena_definition.name+' / ARENENEREIGNIS');event_pattern(event);return
	if not event.active:return
	event.age+=dt
	if event.age>=4 and event.pulse==1:event_pattern(event)
	if event.age>=8:event.active=false;game.run_events+=1;game.encounters.warn('EREIGNIS ÜBERSTANDEN')
func event_pattern(event):
	var kind:String=game.arena_definition.get('event','poison');var at:Vector2=game.player.position
	if kind in ['storm','crystal']:
		enemies.lane(true,at.x+130,1.8,11);enemies.lane(false,at.y-150,1.8,11)
	elif kind=='void':enemies.ring(at+Vector2(160,0),210,PI,1.8,12,{})
	else:
		for delta in [Vector2.ZERO,Vector2(-220,130),Vector2(220,-130)]:enemies.circle((at+delta).clamp(Vector2(100,100),Vector2(2300,1500)),95,1.8,2 if kind=='poison' else .5,10,{},Color(game.WorldProgress.rewards()[game.arena_id].color),'slow' if kind=='frost' else '')
	event.pulse+=1;game.sound('united_warning')
func draw():
	if not enabled:return
	enemies.draw();bosses.draw();heroes.draw()

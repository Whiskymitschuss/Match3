extends RefCounted
const C=preload('res://scripts/progression/collection.gd')
var game:Node2D
var id=''
var rank=0
var cooldown=0.0
var invulnerability=0.0
var touch_ids:Array[int]=[]
func _init(g:Node2D):game=g
func reset():id=game.run_gear.get('spell','');rank=int(game.run_gear.get('spell_rank',0));cooldown=0;invulnerability=0;touch_ids.clear()
func duration() -> float:return 45.0 if id=='heal_pulse' else (35.0 if id=='frost_nova' else 42.0-rank*2)
func rect() -> Rect2:return Rect2(game.ability_rect().position-Vector2(0,170),Vector2(300,140))
func ready() -> bool:return id!='' and rank>0 and cooldown<=0 and game.state==game.State.COMBAT
func activate() -> bool:
	if not ready() or (id=='heal_pulse' and game.hp>=game.max_hp):return false
	cooldown=duration();game.sound('spell_'+id)
	if id=='heal_pulse':
		var old:float=game.hp;game.hp=minf(game.max_hp,game.hp+game.max_hp*(.1+.01*rank));game.add_effect(game.player.position,Color('#2ED573'),60,'+%.0f HP' % (game.hp-old))
	elif id=='phase_blink':
		var dir:Vector2=game.move_input.normalized() if game.move_input.length_squared()>.01 else Vector2(game.facing,0)
		game.vfx.burst(game.player.position,Color('#C578FF'),game.vfx.limits().burst*2,'wisp',120)
		game.player.position=(game.player.position+dir*(220+rank*10)).clamp(Vector2(45,45),Vector2(2355,1555));invulnerability=.2
	else:
		game.vfx.explosion(game.player.position,210,Color('#A0F6FF'))
		for e in game.enemies.duplicate():
			if e.pos.distance_to(game.player.position)>210+e.radius:continue
			e.ability_slow=.4;e.ability_slow_time=2.0;game.damage_enemy(e,(12+rank*3)*game.damage_mult)
			if game.state!=game.State.COMBAT:break
	return true
func update(dt:float):
	if game.state!=game.State.COMBAT:return
	cooldown=maxf(0,cooldown-dt);invulnerability=maxf(0,invulnerability-dt)
func input(event:InputEvent) -> bool:
	if event is InputEventScreenTouch:
		if touch_ids.has(event.index):
			if not event.pressed:touch_ids.erase(event.index)
			return true
		if id!='' and game.state==game.State.COMBAT and event.pressed and rect().has_point(game.ui_root.get_global_transform().affine_inverse()*event.position):touch_ids.append(event.index);activate();return true
	if event is InputEventScreenDrag and touch_ids.has(event.index):return true
	return false

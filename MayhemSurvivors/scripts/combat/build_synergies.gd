extends RefCounted
# Run-only class modules. Only explicit primary weapon hits enter the proc path.
# Enemy marks are bounded by the existing enemy cap; visual limits never affect damage.
var owner_ref:WeakRef
var game:Node2D:
	get:return owner_ref.get_ref()
var armed=0.0
var cooldown=0.0
var procs=0
var fx:Array=[]
const MODULES={'bruiser':'fault_core','sparky':'ion_relay','shade':'umbra_spool'}
func _init(g:Node2D):owner_ref=weakref(g)
func module_id() -> String:return MODULES.get(game.characters[game.selected].id,'')
func definition() -> Dictionary:return game.run_items.data.get(module_id(),{})
func active() -> bool:
	var d=definition()
	return not d.is_empty() and game.run_items.owned.has(module_id()) and game.weapon_level(d.weapon)>0
func live() -> bool:
	return game.state==game.State.COMBAT and not (game.tutorial and game.tutorial.active and game.tutorial.frozen())
func clear():
	armed=0;cooldown=0;procs=0;fx.clear()
	for e in game.enemies:e.erase('synergy_tag');e.erase('synergy_ttl')
func update(dt:float):
	if not live():return
	armed=maxf(0,armed-dt);cooldown=maxf(0,cooldown-dt)
	for e in game.enemies:
		if e.has('synergy_ttl'):
			e.synergy_ttl=maxf(0,e.synergy_ttl-dt)
			if e.synergy_ttl<=0:e.erase('synergy_tag');e.erase('synergy_ttl')
	for i in range(fx.size()-1,-1,-1):
		fx[i].age+=dt
		if fx[i].age>=.35:fx.remove_at(i)
func mark(e:Dictionary):
	if not live() or not active() or e.hp<=0 or not game.enemies.has(e):return
	e.synergy_tag=module_id();e.synergy_ttl=float(definition().combo.duration)
func ability_started(id:String):
	if live() and active() and module_id()=='umbra_spool' and id=='shadow_step':
		armed=float(definition().combo.duration)
func ability_hit(e:Dictionary,id:String):
	if (module_id()=='fault_core' and id=='shockwave') or (module_id()=='ion_relay' and id=='impulse'):mark(e)
func tagged(e:Dictionary) -> bool:return e.get('synergy_tag','')==module_id() and float(e.get('synergy_ttl',0))>0
func before_hit(e:Dictionary,weapon:String) -> Dictionary:
	if not live() or not active():return {}
	var id=module_id();var d=definition().combo
	if id=='fault_core' and weapon=='hammer' and tagged(e):
		e.erase('synergy_tag');e.erase('synergy_ttl');procs+=1;game.recap.proc();burst(e.pos,'combo_fault')
		return {'multiplier':1+float(d.bonus)}
	if id=='umbra_spool' and weapon=='orbit' and armed>0:
		armed=0;procs+=1;game.recap.proc();burst(e.pos,'combo_umbra')
		return {'multiplier':1+float(d.bonus)}
	if id=='ion_relay' and weapon=='blaster' and tagged(e) and cooldown<=0:
		e.erase('synergy_tag');e.erase('synergy_ttl');cooldown=float(d.cooldown);procs+=1;game.recap.proc()
		return {'discharge':true,'origin':e.pos}
	return {}
func after_hit(e:Dictionary,weapon:String,power:float,event:Dictionary):
	if not live() or not active():return
	if module_id()=='ion_relay' and weapon=='arc':mark(e)
	if not event.get('discharge',false):return
	var d=definition().combo;var origin:Vector2=event.origin;var hit:Array=[e]
	burst(origin,'combo_ion')
	for i in range(int(d.targets)):
		var choice:Dictionary={};var reach=float(d.reach)
		for other in game.enemies:
			if hit.has(other) or other.hp<=0:continue
			var distance:float=origin.distance_to(other.pos)
			if distance<=reach:choice=other;reach=distance
		if choice.is_empty():break
		hit.append(choice);game.combat_visuals.beam(origin,choice.pos);origin=choice.pos
		game.damage_enemy(choice,power*float(d.ratio),'synergy')
		if not live():return
func burst(at:Vector2,cue:String):
	var limit=4 if game.saved.settings.quality=='LOW' else (8 if game.saved.settings.quality=='MEDIUM' else 12)
	while fx.size()>=limit:fx.pop_front()
	fx.append({'pos':at,'age':0.0,'color':Color(definition().color)})
	game.sound(cue)
func mark_count() -> int:
	var count=0
	for e in game.enemies:
		if tagged(e):count+=1
	return count
func status() -> String:
	if not game.run_items.owned.has(module_id()):return 'KLASSENMODUL IM SHOP'
	if not active():return 'PASSENDE WAFFE FEHLT'
	if module_id()=='umbra_spool':return 'KLINGE GELADEN · %.1f s' % armed if armed>0 else 'SCHATTENSCHRITT → KLINGE'
	if module_id()=='ion_relay' and cooldown>0:return 'RELAIS LÄDT · %.1f s' % cooldown
	var count=mark_count()
	if count>0:return '%d MARKIERT · %s' % [count,'HAMMER BEREIT' if module_id()=='fault_core' else 'BLASTER BEREIT']
	return 'SCHOCKWELLE → HAMMER' if module_id()=='fault_core' else 'STROM → BLASTER'
func help_text(value:String,rect:Rect2,font:int,color:Color):
	var label=game.label_at(value,rect.position,font,color)
	label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.set_deferred('size',rect.size)
func show_help(back:Callable):
	var d=definition()
	if d.is_empty() or game.state not in [game.State.PAUSED,game.State.SHOP]:return
	game.backdrop(d.name,'KLASSENKOMBINATION / '+game.characters[game.selected].name)
	game.UISkin.image(game,game.run_items.icon(module_id()),Rect2(140,305,270,270))
	help_text('AUSLÖSER → TREFFER → WIRKUNG',Rect2(540,275,1210,70),38,Color(d.color))
	help_text(d.details,Rect2(540,375,1180,310),32,Color.WHITE)
	var owned=game.run_items.owned.has(module_id())
	var note='MODUL GEKAUFT / '+status() if owned else 'Im Wellenshop kaufen: %d Run-Coins nach Welle %d. Bis zum Kauf in jedem Shop garantiert.' % [int(d.price)+game.wave_number*4,game.wave_number]
	help_text(note,Rect2(140,725,1600,100),28,game.GOLD)
	help_text('Nur in diesem Run. Zeiten stoppen bei Pause, Levelaufstieg und Shop. Markierungen und Ladungen verfallen beim Wellenwechsel.',Rect2(140,840,1600,85),26,game.TEAL)
	game.button('ZURÜCK',Vector2(120,960),Vector2(680,90),func():game.queue_ui_action(back))
func draw():
	if not active():return
	var color=Color(definition().color)
	for e in game.enemies:
		if not tagged(e):continue
		var at:Vector2=e.pos+Vector2(0,-e.radius*(2.4 if e.kind in ['boss','breaker_axel','champion'] else 2.2)-22)
		game.draw_circle(at,12,Color('#120C22'))
		if module_id()=='fault_core':
			game.draw_line(at+Vector2(-7,0),at+Vector2(7,0),color,4,true);game.draw_line(at,at+Vector2(0,7),color,4,true)
		else:game.draw_polyline(PackedVector2Array([at+Vector2(3,-8),at+Vector2(-4,0),at+Vector2(4,0),at+Vector2(-3,8)]),color,3,true)
	if armed>0:
		var at:Vector2=game.player.position
		game.draw_arc(at,46,0,TAU,32,Color(color,.7),3,true)
	for f in fx:
		var t:float=f.age/.35
		game.draw_arc(f.pos,20+45*t,0,TAU,24,Color(f.color,1-t),4,true)

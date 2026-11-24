extends RefCounted
const Layout=preload('res://scripts/mobile/touch_layout.gd')
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var active=false
var draft:Dictionary={}
var back:Callable
var pointer=-1
var selected=''
var origin=Vector2.ZERO
var previous=Vector2.ZERO
var preview:Control
var field=Rect2(100,430,1720,480)
var message=''
func _init(g:Node):game_ref=weakref(g)
func dispose():active=false;pointer=-1;back=Callable()
func show(return_to:Callable):
	back=return_to;draft=Layout.clean(game.saved.settings.get('touch_layout'));active=true;message='';render()
func button(value:String,rect:Rect2,action:Callable):
	var b=game.button(value,rect.position,rect.size,func():game.queue_ui_action(action))
	if value in ['−','+']:b.icon=null
	return b
func render():
	game.backdrop('DEINE TOUCHSTEUERUNG','Verschieben in der Vorschau / Anwenden speichert nur in deinem Profil')
	button('LINKSHÄNDER: '+('AN' if draft.left_handed else 'AUS'),Rect2(100,245,550,85),func():draft.left_handed=not draft.left_handed;render())
	button('JOYSTICK: '+('DYNAMISCH' if draft.dynamic else 'FEST'),Rect2(685,245,550,85),func():draft.dynamic=not draft.dynamic;render())
	button('STANDARD',Rect2(1270,245,550,85),func():draft=Layout.defaults();render())
	var keys=['size','opacity','deadzone'];var names=['GRÖSSE','SICHTBARKEIT','DEADZONE'];var lows=[.85,.45,.08];var highs=[1.2,1.0,.28];var steps=[.05,.05,.02]
	for i in range(3):
		var key=keys[i];var x=100+i*585
		game.label_at(names[i]+' %d %%' % roundi(draft[key]*100),Vector2(x,350),25,game.TEAL)
		button('−',Rect2(x+310,335,90,85),func():draft[key]=maxf(lows[i],draft[key]-steps[i]);render())
		button('+',Rect2(x+420,335,90,85),func():draft[key]=minf(highs[i],draft[key]+steps[i]);render())
	preview=Control.new();preview.position=field.position;preview.size=field.size;preview.mouse_filter=Control.MOUSE_FILTER_IGNORE
	preview.set_script(preload('res://scripts/ui/touch_layout_preview.gd'));preview.editor=self;game.ui_root.add_child(preview)
	var map=projection();game.portrait(field.position+map.offset+Vector2(810,245)*map.scale,game.selected,.7*map.scale,'wardrobe')
	game.label_at(message if message!='' else 'Joystick oder Fähigkeit ziehen. Der Zauber bleibt bei deiner Fähigkeit. Buttons bleiben getrennt.',Vector2(110,925),25,game.GOLD)
	button('ABBRECHEN',Rect2(100,970,530,85),leave)
	button('ANWENDEN',Rect2(1230,970,590,85),apply)
	game.ui_back_action=leave;game.ui_back_priority=3
func projection() -> Dictionary:
	var scale=minf(field.size.x/1920.0,field.size.y/1080.0)
	return {'scale':scale,'offset':(field.size-Vector2(1920,1080)*scale)*.5}
func input(event:InputEvent) -> bool:
	if not active:return false
	if not (event is InputEventScreenTouch or event is InputEventScreenDrag):return false
	var p:Vector2=game.ui_root.get_global_transform().affine_inverse()*event.position
	var map=projection();var pos=(p-field.position-map.offset)/map.scale
	if event is InputEventScreenTouch:
		if not event.pressed and event.index==pointer:pointer=-1;selected='';return true
		if not event.pressed or pointer!=-1 or not field.has_point(p):return false
		var geom=Layout.geometry(Rect2(0,0,1920,1080),draft)
		if pos.distance_to(geom.joy)<=geom.visual_radius:selected='joy'
		elif geom.ability.has_point(pos):selected='ability'
		else:return false
		pointer=event.index;origin=pos;previous=Vector2(draft[selected+'_x'],draft[selected+'_y']);return true
	if event.index==pointer:
		var delta=pos-origin
		draft[selected+'_x']=previous.x+delta.x*(-1 if draft.left_handed else 1);draft[selected+'_y']=previous.y+delta.y
		draft=Layout.clean(draft);preview.queue_redraw();return true
	return false
func apply() -> bool:
	var old=game.saved.settings.get('touch_layout',Layout.defaults()).duplicate(true)
	game.saved.settings.touch_layout=Layout.clean(draft)
	if not game.save_game():game.saved.settings.touch_layout=old;message=game.save_error;render();return false
	game.update_safe_area()
	if game.tutorial and game.tutorial.active:game.tutorial.redraw_card()
	game.sound('buy');leave();return true
func leave():
	var target=back;dispose()
	if target.is_valid():target.call()
	else:game.main_menu()

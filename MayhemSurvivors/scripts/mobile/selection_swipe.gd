extends RefCounted
var game:Node2D
var context=''
var finger=-1
var origin=Vector2.ZERO
var begun=0
var blocked:Array[int]=[]
const REGION=Rect2(90,235,1740,695)
func _init(g:Node2D):game=g
func set_context(value:String):context=value;finger=-1
func cancel_buttons():
	for child in game.ui_root.get_children():
		if child is BaseButton and not child.disabled:
			child.disabled=true;child.set_deferred('disabled',false)
func handle(event:InputEvent) -> bool:
	if event is InputEventScreenTouch:
		if not event.pressed and blocked.has(event.index):blocked.erase(event.index);return true
		if context=='':return false
		var pos=game.ui_root.get_global_transform().affine_inverse()*event.position
		if event.pressed:
			if finger!=-1:
				for index in [finger,event.index]:
					if not blocked.has(index):blocked.append(index)
				finger=-1;cancel_buttons();return true
			if REGION.has_point(pos):finger=event.index;origin=pos;begun=Time.get_ticks_msec()
		elif event.index==finger:finger=-1
	elif event is InputEventScreenDrag and event.index==finger and context!='':
		var pos=game.ui_root.get_global_transform().affine_inverse()*event.position
		var offset=pos-origin
		if offset.length()>22 and not blocked.has(event.index):blocked.append(event.index);cancel_buttons()
		if absf(offset.x)>=100 and absf(offset.x)>absf(offset.y)*1.25 and Time.get_ticks_msec()-begun<=1200:
			var destination=context;finger=-1
			for child in game.ui_root.get_children():
				if child is BaseButton:child.set_pressed_no_signal(false)
			game.call_deferred('selection_shift',destination,1 if offset.x<0 else -1)
			return true
		return offset.length()>22
	return false

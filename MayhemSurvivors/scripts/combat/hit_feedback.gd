extends RefCounted
var game:Node2D
var numbers:Array=[]
var hurt_flash=0.0
var serial=0
func _init(g:Node2D):game=g
func clear():
	numbers.clear()
	hurt_flash=0
	serial=0
func limit() -> int:
	return 24 if game.saved.settings.quality=='LOW' else (40 if game.saved.settings.quality=='MEDIUM' else 64)
func update(dt:float):
	while numbers.size()>limit():numbers.pop_front()
	hurt_flash=maxf(0,hurt_flash-dt)
	for i in range(numbers.size()-1,-1,-1):
		numbers[i].life-=dt
		if numbers[i].life<=0:numbers.remove_at(i)
func damage(pos:Vector2, amount:float, critical:bool, player_hit:bool=false):
	if player_hit:hurt_flash=.22
	if not game.saved.settings.get('damage_numbers',true):return
	var cap=limit()
	while numbers.size()>=cap:numbers.pop_front()
	serial+=1
	var color=Color('#FF6376') if player_hit else (Color('#FFD166') if critical else Color.WHITE)
	var text=('-' if player_hit else ('KRIT ' if critical else ''))+str(ceili(amount))
	if critical:
		var criticals=0
		for n in numbers:
			if n.get('critical',false):criticals+=1
		if criticals>=6:
			for i in range(numbers.size()):
				if numbers[i].get('critical',false):numbers.remove_at(i);break
	numbers.append({'pos':pos+Vector2((serial%5-2)*10,-30),'life':.7,'text':text,'color':color,'critical':critical,'size':52 if critical else (40 if player_hit else 29)})
func draw():
	if not game.saved.settings.get('damage_numbers',true):return
	var font=ThemeDB.fallback_font
	for n in numbers:
		var pos:Vector2=n.pos-Vector2(0,(.7-n.life)*65)
		var pop=1.0 if game.saved.settings.get('reduced_motion',false) else 1.0+.2*maxf(0,1-(.7-n.life)/.12)
		var font_size=roundi(n.size*pop)
		var alpha=clampf(n.life*4,0,1)
		game.draw_string_outline(font,pos,n.text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,8 if n.get('critical',false) else 5,Color(.37,.04,.48,alpha) if n.get('critical',false) else Color(0.04,.06,.12,alpha))
		game.draw_string(font,pos,n.text,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size,Color(n.color,alpha))

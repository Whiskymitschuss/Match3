extends RefCounted
const Rewards=preload('res://scripts/progression/daily_rewards.gd')
var game:Node2D
var tab='daily'
var page=0
var error=''
var data:Dictionary
func _init(g:Node2D):game=g;data=Rewards.definition()
func action(kind:String,id:String='',index:int=-1):
	var before=game.saved.meta.duplicate(true);var ok=false
	match kind:
		'claim':ok=Rewards.claim(game.saved.meta,tab,id)
		'pass':ok=Rewards.claim_pass(game.saved.meta,index)
		'renew':ok=Rewards.renew_pass(game.saved.meta)
		'buy':ok=Rewards.buy(game.saved.meta,id)
		'equip':ok=Rewards.equip(game.saved.meta,id)
		'off':game.saved.meta.equipped={'ring':'','buddy':'','title':''};ok=true
	if ok:
		if game.SaveManager.save_local(game.saved,game.active_save_path())!=OK:game.saved.meta=before;error='Speichern fehlgeschlagen. Bitte erneut versuchen.'
		else:error='';game.sound('buy')
	show(tab,page)
func text(value:String,pos:Vector2,width:float,size:int=27,color:Color=Color.WHITE):
	var label=game.label_at(value,pos,size,color);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.set_deferred('size',Vector2(width,150));return label
func show(which:String='daily',offset:int=0):
	tab=which if which in ['daily','weekly','pass','shop'] else 'daily';page=clampi(offset,0,1)
	Rewards.refresh(game.saved.meta)
	game.backdrop('AUFTRÄGE & BELOHNUNGEN','Täglich 00:00 UTC / Wochenstart Montag / kostenloser Pass / kosmetische Belohnungen')
	game.label_at('%d STUDIO-COINS' % game.saved.meta.coins,Vector2(1250,82),35,game.GOLD)
	for i in range(4):
		var key=['daily','weekly','pass','shop'][i]
		game.button(['TÄGLICH','WÖCHENTLICH','DAILY PASS','STUDIO-SHOP'][i],Vector2(100+i*435,240),Vector2(410,85),func():show(key,0),Color('#147F81') if key==tab else Color('#243958'))
	if tab in ['daily','weekly']:
		for i in range(3):
			var task=data[tab][i];var x=100+i*585;var value=Rewards.value(game.saved.meta,tab,task);var claimed=game.saved.meta[tab].claimed.has(task.id)
			game.UISkin.panel(game,Rect2(x,350,550,550))
			game.UISkin.image(game,load('res://assets/ui/meta/tasks.svg'),Rect2(x+25,375,110,100))
			text(task.name,Vector2(x+25,490),490,31,game.GOLD)
			text(task.description,Vector2(x+25,555),490,26)
			text('%d / %d\n+%d Studio-Coins / +%d Pass-XP' % [mini(value,task.target),task.target,task.coins,task.xp],Vector2(x+25,665),490,26,game.TEAL)
			var button=game.button('ABGEHOLT' if claimed else 'ABHOLEN',Vector2(x+25,790),Vector2(500,85),func():action('claim',task.id));button.disabled=claimed or value<task.target
	elif tab=='pass':
		text('Pass %d / %d XP / jede Stufe 100 XP / Fortschritt verfällt nicht' % [game.saved.meta.pass.cycle,game.saved.meta.pass.xp],Vector2(110,345),1650,28,game.TEAL)
		for i in range(page*4,mini(7,page*4+4)):
			var x=100+(i%4)*435;var claimed=game.saved.meta.pass.claimed.has(i)
			game.UISkin.panel(game,Rect2(x,410,410,470))
			game.UISkin.image(game,load('res://assets/ui/meta/pass.svg'),Rect2(x+120,435,170,150))
			text('STUFE %d\n%d PASS-XP\n+%d STUDIO-COINS' % [i+1,(i+1)*100,data.pass_rewards[i]],Vector2(x+25,610),360,28,game.GOLD)
			var button=game.button('ABGEHOLT' if claimed else 'ABHOLEN',Vector2(x+20,775),Vector2(370,85),func():action('pass','',i));button.disabled=claimed or game.saved.meta.pass.xp<(i+1)*100
		game.button('VORHERIGE',Vector2(500,965),Vector2(350,85),func():show(tab,0))
		game.button('NÄCHSTE',Vector2(890,965),Vector2(350,85),func():show(tab,1))
		var renew=game.button('NEUEN PASS STARTEN',Vector2(1280,965),Vector2(500,85),func():action('renew'));renew.disabled=game.saved.meta.pass.claimed.size()!=7
	elif tab=='shop':
		for i in range(page*3,mini(data.shop.size(),page*3+3)):
			var item=data.shop[i];var x=100+(i%3)*585;var owned=game.saved.meta.owned.has(item.id);var equipped=game.saved.meta.equipped[item.group]==item.id
			game.UISkin.panel(game,Rect2(x,350,550,550),Color(item.color))
			game.UISkin.image(game,load('res://assets/ui/meta/'+item.id+'.svg'),Rect2(x+170,375,210,160))
			text(item.name,Vector2(x+25,565),490,34,Color(item.color))
			text(item.description,Vector2(x+25,635),490,26)
			text('PERMANENT / KEINE WERTEBONI',Vector2(x+25,735),490,19,game.TEAL)
			var b=game.button('AKTIV' if equipped else ('AUSRÜSTEN' if owned else '%d COINS KAUFEN' % item.price),Vector2(x+25,790),Vector2(500,85),func():action('equip' if owned else 'buy',item.id));b.disabled=equipped or (not owned and game.saved.meta.coins<item.price)
		game.button('VORHERIGE',Vector2(500,965),Vector2(350,85),func():show(tab,0))
		game.button('NÄCHSTE',Vector2(890,965),Vector2(350,85),func():show(tab,1))
		game.button('KOSMETIK ABLEGEN',Vector2(1280,965),Vector2(500,85),func():action('off'))
	if tab in ['daily','weekly']:game.button('TROPHÄEN & RINGE',Vector2(500,965),Vector2(680,85),game.challenges_screen)
	if error!='':text(error,Vector2(120,915),1600,23,Color('#FF4757'))
	game.button('ZURÜCK',Vector2(100,965),Vector2(350,85),game.main_menu)
func draw_cosmetics():
	var equipped=game.saved.meta.equipped;var at:Vector2=game.player.position+Vector2(0,27);var clock:float=game.animation_clock
	if equipped.ring!='':
		game.draw_set_transform(at,0,Vector2(1,.35))
		if equipped.ring=='comet':
			game.draw_arc(Vector2.ZERO,43,clock*2,clock*2+PI*1.7,36,Color('#A0F6FF'),3,true);game.draw_circle(Vector2.from_angle(clock*2)*43,6,Color.WHITE)
		elif equipped.ring=='circuit':
			for i in range(8):game.draw_arc(Vector2.ZERO,43,i*TAU/8+clock*.3,i*TAU/8+clock*.3+.45,5,Color('#00D9D0'),4,true)
		elif equipped.ring=='flame':
			for i in range(10):
				var p=Vector2.from_angle(i*TAU/10)*42;game.draw_colored_polygon(PackedVector2Array([p-Vector2(4,0),p+Vector2(0,-10-4*sin(clock*5+i)),p+Vector2(4,0)]),Color('#FF9F1C'))
		game.draw_set_transform(Vector2.ZERO)
	if equipped.buddy!='':
		var p:Vector2=game.player.position+Vector2(cos(clock)*55,-55+sin(clock*2)*7)
		if equipped.buddy=='mini_bot':
			game.draw_circle(p,16,Color('#14213D'));game.draw_rect(Rect2(p-Vector2(12,9),Vector2(24,18)),Color('#80DEFF'));game.draw_circle(p+Vector2(-5,0),3,Color('#14213D'));game.draw_circle(p+Vector2(5,0),3,Color('#14213D'));game.draw_line(p-Vector2(0,8),p-Vector2(0,22),Color('#FFD166'),3,true)
		else:
			var art=preload('res://scripts/ui/combat_art.gd');game.draw_texture_rect_region(art.weapon_texture('bomb'),Rect2(p-Vector2(22,22),Vector2(44,44)),art.weapon('bomb'))
	if equipped.title!='':game.draw_string(game.UISkin.HEADING,game.player.position+Vector2(-110,-92),'CHAOS-LEGENDE',HORIZONTAL_ALIGNMENT_CENTER,220,17,game.GOLD)

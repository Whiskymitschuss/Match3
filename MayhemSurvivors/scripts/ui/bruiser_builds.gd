extends RefCounted
var game:Node2D
func _init(g:Node2D):game=g
func text(value:String,at:Vector2,width:float,font:int=28,color:Color=Color.WHITE):
	var node=game.label_at(value,at,font,color);node.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;node.set_deferred('size',Vector2(width,170));return node
func show():
	if game.state!=game.State.SHOP or game.characters[game.selected].id!='bruiser':return
	game.backdrop('DEIN HAMMER. DEIN STIL.','BRUISER / Zwei kostenlose Entwicklungen ab Run-Waffenstufe 5')
	var hammer=game.weapons.filter(func(w):return w.id=='hammer')[0]
	for i in range(2):
		var id=['quake','crusher'][i];var d=game.Specs.all()[id];var x=100+i*880;var color=Color(d.color)
		game.UISkin.panel(game,Rect2(x,260,840,620),color)
		game.UISkin.image(game,game.Specs.icon(id),Rect2(x+30,285,150,150))
		text(d.name,Vector2(x+210,300),590,48,color)
		text('GEGEN GRUPPEN' if i==0 else 'GEGEN EINZELZIELE',Vector2(x+210,365),590,26,game.TEAL)
		text(d.description,Vector2(x+35,460),765,30)
		var power=float(game.weapon_data.hammer.damage)*2.2*game.damage_mult*game.gear_weapon_multiplier('hammer')*(1.0+float(game.characters[game.selected].melee_bonus))*float(d.power)
		var cooldown=float(game.weapon_data.hammer.cooldown)/game.attack_mult/1.24*float(d.cooldown)
		text('VORSCHAU STUFE 5 MIT DEINEN WERTEN\n%.1f Schaden pro Treffer / %.2f s Abklingzeit\nOhne kritische Treffer.' % [power,cooldown],Vector2(x+35,585),765,26,game.GOLD)
		text('Passt zu Schaden, Angriffstempo und Sammelradius. Der Rundumschlag trifft auch Gegner hinter dir.' if i==0 else 'Passt zu Angriffstempo, Bewegung und Rüstung. Bleib in Reichweite und weiche den angekündigten Bossangriffen aus.',Vector2(x+35,720),765,25)
	text('DEIN HAMMER: STUFE %d / 5%s' % [hammer.level,' / '+game.Specs.label(hammer) if not game.Specs.definition(hammer).is_empty() else ' / Entwicklung noch offen'],Vector2(110,905),1650,28,game.TEAL)
	game.button('ZUM LADEN',Vector2(100,975),Vector2(600,80),func():game.queue_ui_action(game.show_shop))
	game.button('HAMMER AUFRÜSTEN',Vector2(1000,975),Vector2(820,80),func():game.queue_ui_action(func():game.shop_view.weapon_details('hammer')))

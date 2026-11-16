extends RefCounted
var game: Node2D
func _init(owner_game: Node2D):
	game = owner_game

func update(dt: float):
	for w in game.weapons:
		var d = game.weapon_data[w.id]
		var power = float(d.damage)*(1+(w.level-1)*.3)*game.damage_mult
		if w.id == 'hammer': power *= 1.0+float(game.characters[game.selected].melee_bonus)
		if w.id == 'orbit':
			var blade = game.player.position+Vector2.from_angle(game.orbit_angle)*(110+5*(w.level-1))
			for e in game.enemies.duplicate():
				if e.pos.distance_to(blade)<e.radius+28 and e.orbit_cd<=0:
					e.orbit_cd = .5/game.attack_mult/(1+.08*(w.level-1))
					game.damage_enemy(e,power)
			continue
		w.clock -= dt
		if w.clock>0: continue
		var target = game.nearest(game.player.position,float(d.reach)+10*(w.level-1))
		if target == null: continue
		w.clock = float(d.cooldown)/game.attack_mult/(1+.06*(w.level-1))
		var direction: Vector2 = (target.pos-game.player.position).normalized()
		match w.id:
			'blaster','splitgun':
				var count = (3 if w.id=='splitgun' else 1)+game.multishot
				for j in range(count):
					var angle = (j-(count-1)*.5)*(.15-.01*(w.level-1))
					game.shoot(game.player.position+direction*30,direction.rotated(angle),power,false,650*game.projectile_speed*(1+.04*(w.level-1)),float(d.reach)/650+.25)
				game.sound('shot')
			'hammer':
				game.add_effect(game.player.position+direction*70,game.GOLD,105,'WHAM!')
				for e in game.enemies.duplicate():
					if e.pos.distance_to(game.player.position)<float(d.reach)+12*(w.level-1)+e.radius and direction.dot((e.pos-game.player.position).normalized())>-.15: game.damage_enemy(e,power)
			'arc':
				var origin = game.player.position
				var hit: Array = []
				for j in range(3):
					var choice = null
					var dist = float(d.reach) if j==0 else 220.0+25*(w.level-1)
					for e in game.enemies:
						if not hit.has(e) and origin.distance_to(e.pos)<dist: choice=e; dist=origin.distance_to(e.pos)
					if choice==null: break
					hit.append(choice)
					game.effects.append({'pos':origin,'end':choice.pos,'color':game.TEAL,'radius':6.0,'life':.22,'text':''})
					origin = choice.pos
					game.damage_enemy(choice,power*(1-j*maxf(.04,.15-.02*(w.level-1))))


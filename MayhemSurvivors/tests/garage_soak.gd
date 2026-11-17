extends SceneTree
var g
var steps=0
var peak=0
func _initialize():call_deferred('run')
func run():
	g=load('res://scenes/boot/main.tscn').instantiate();g.test_mode=true;root.add_child(g);preload('res://tests/legacy_release.gd').apply(g);g.set_physics_process(false)
	for hero in range(6):
		for arena in g.Arenas.IDS:
			for spell in ['heal_pulse','frost_nova','phase_blink']:
				g.saved=g.default_save();preload('res://tests/legacy_collection.gd').unlock_all(g.saved);g.saved.wins=1;preload('res://tests/legacy_worlds.gd').unlock_all(g.saved)
				for id in g.Collection.catalog().items:g.saved.collection.levels[id]=5 if g.Collection.catalog().items[id].ranked else 1
				for id in ['reactor_plate','neon_soles','neon_visor','heart_module',spell,'cyan_core']:g.Collection.equip(g.saved,g.characters[hero].id,id)
				g.selected=hero;g.selected_difficulty='mayhem';g.arena_id=arena;g.run_mode='endless';g.start_run();g.wave_number=31;g.begin_wave();g.rng.seed=180;g.hp=100000;g.max_hp=100000;g.weapons[0].level=5;g.weapons[0].spec=g.Specs.choices(g.weapons[0].id)[0]
				for i in range(1200):
					if g.state==g.State.LEVEL_UP:g.if_more_levels()
					if g.state==g.State.COMBAT:
						g.move_input=Vector2.from_angle(i*.004)*.7
						if g.hero_ability.ready_to_use():g.hero_ability.activate()
						if g.equipped_spell.ready():g.equipped_spell.activate()
						g._physics_process(1.0/60)
					steps+=1;peak=maxi(peak,g.enemies.size())
					assert(g.enemies.size()<=100 and g.player.position.is_finite() and is_finite(g.hp) and g.hp<=g.max_hp and g.equipped_spell.cooldown>=0 and g.equipped_spell.invulnerability>=0)
					for e in g.enemies:assert(e.pos.is_finite() and is_finite(e.hp))
				print('GARAGE SOAK ',g.characters[hero].id,' ',arena,' ',spell,' enemies=',g.enemies.size())
	print('GARAGE SOAK PASS steps=',steps,' peak_enemies=',peak,' all6 heroes/four arenas/three rank5 spells/max gear/Mayhem endless31; artificial HP and pilot; no Android FPS claim')
	g.queue_free();await process_frame;quit()

extends Node2D
# All simulation advances exclusively in COMBAT. UI stays active in every state.
const GameStateMachine = preload('res://scripts/core/game_state_machine.gd')
const State = GameStateMachine.State
const RunRecords = preload('res://scripts/progression/run_records.gd')
const CharacterArt = preload('res://scripts/ui/character_art.gd')
const Arenas = preload('res://scripts/core/arena_catalog.gd')
var arena_id='scrapyard'
var arena_definition=Arenas.definition('scrapyard')
var arena_hazards
var reactor_guardian
var hero_ability
var hit_feedback
var haptic_feedback=preload('res://scripts/mobile/haptic_feedback.gd').new()
var ability_button:Button
var ability_touch_ids:Array[int]=[]
const ABILITY_RECT=Rect2(1510,770,300,210)
var facing = 1.0
const INK = Color('#14213D')
const TEAL = Color('#00D9D0')
const GOLD = Color('#FFD166')
var state = State.BOOT
var characters = read_data('characters/characters')
var weapon_data = read_data('weapons/weapons')
var enemy_data = read_data('enemies/enemies')
var upgrades = read_data('upgrades/upgrades')
var waves = read_data('waves/waves')
var selected = 0
var player: CharacterBody2D
var camera: Camera2D
var ui: CanvasLayer
var panel: Control
var ui_root: Control
var hud: Label
var boss_hud: Label
var joystick: Control
var stick_id = -1
var stick_origin = Vector2(200, 850)
var stick_pos = Vector2.ZERO
var move_input = Vector2.ZERO
var enemies: Array = []
var projectile_pool = preload('res://scripts/combat/projectile_pool.gd').new()
var shots: Array = projectile_pool.items
const SaveManager = preload('res://scripts/autoload/save_manager.gd')
var loot: Array = []
var effects: Array = []
var weapons: Array = []
const Specs=preload('res://scripts/weapons/specializations.gd')
var specialized_combat
var weapon_manager
var combat_visuals
var world_visuals
var hp = 120.0
var max_hp = 120.0
var speed = 180.0
var damage_mult = 1.0
var attack_mult = 1.0
var crit = .05
var armor = 0
var magnet = 100.0
var projectile_speed = 1.0
var multishot = 0
var level = 1
var xp = 0
var coins = 0
var earned = 0
var kills = 0
var dealt = 0.0
var run_time = 0.0
var wave_number = 1
var remaining = 60.0
var spawn_clock = 0.0
var hurt_clock = 0.0
var orbit_angle = 0.0
var animation_clock = 0.0
var boss_clock = 0.0
var boss_phase = 0
var boss_charging = false
var boss_target = Vector2.ZERO
var boss_warning = ''
var rerolls = 0
var offers: Array = []
var upgrade_counts = {}
var saved = {}
var rng = RandomNumberGenerator.new()
var sfx_players: Array = []
var alert_audio: AudioStreamPlayer
var music: AudioStreamPlayer
var result_recorded = false
var style_cache: Dictionary = {}
var test_mode = false

func read_data(path: String):
	return JSON.parse_string(FileAccess.get_file_as_string('res://data/' + path + '.json'))

func change_state(next: int):
	if not test_mode and not GameStateMachine.permits(state,next):
		push_error('Invalid state transition: %s -> %s' % [state,next])
		return
	state = next

func _ready():
	rng.randomize()
	weapon_manager = preload('res://scripts/weapons/weapon_manager.gd').new(self)
	combat_visuals = preload('res://scripts/combat/combat_visuals.gd').new(self)
	world_visuals = preload('res://scripts/gameplay/world_visuals.gd').new(self)
	arena_hazards=preload('res://scripts/gameplay/arena_hazards.gd').new(self)
	reactor_guardian=preload('res://scripts/bosses/reactor_guardian.gd').new(self)
	hero_ability=preload('res://scripts/characters/hero_ability.gd').new(self)
	hit_feedback=preload('res://scripts/combat/hit_feedback.gd').new(self)
	specialized_combat=preload('res://scripts/weapons/specialized_combat.gd').new(self)
	load_save()
	player = load('res://scenes/characters/player.tscn').instantiate()
	player.name = 'PlayerController'
	add_child(player)
	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5
	camera.zoom = Vector2(1.15, 1.15)
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = 2400
	camera.limit_bottom = 1600
	player.add_child(camera)
	ui = CanvasLayer.new()
	add_child(ui)
	ui_root = Control.new()
	ui_root.name = 'SafeAreaUI'
	ui_root.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
	ui_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.add_child(ui_root)
	get_viewport().size_changed.connect(update_safe_area)
	update_safe_area()
	for i in range(12):
		var a = AudioStreamPlayer.new()
		add_child(a)
		sfx_players.append(a)
	alert_audio=AudioStreamPlayer.new()
	alert_audio.name='AlertAudio'
	add_child(alert_audio)
	setup_music()
	get_tree().auto_accept_quit = false
	main_menu()

func update_safe_area():
	if not ui_root: return
	var size = get_viewport_rect().size
	var safe = Rect2(Vector2.ZERO,size)
	if OS.has_feature('android'):
		var screen = Vector2(DisplayServer.screen_get_size())
		var area = Rect2(DisplayServer.get_display_safe_area())
		if screen.x>0 and screen.y>0 and area.size.x>0:
			safe = Rect2(area.position/screen*size,area.size/screen*size)
	var factor = minf(safe.size.x/1920.0,safe.size.y/1080.0)
	ui_root.scale = Vector2.ONE*factor
	ui_root.position = safe.position+(safe.size-Vector2(1920,1080)*factor)*.5
	ui_root.size = Vector2(1920,1080)

func default_save():
	return SaveManager.defaults()

func load_save():
	saved = SaveManager.load_local()

func save_game():
	SaveManager.save_local(saved)

func sound(id: String):
	if test_mode: return
	if id in ['boss_radial_warning','boss_charge_warning','warning','victory','defeat'] and is_instance_valid(alert_audio):
		alert_audio.stop()
		alert_audio.stream=load('res://assets/audio/'+id+'.wav')
		alert_audio.volume_db=linear_to_db(maxf(.001,float(saved.settings.master)*float(saved.settings.sfx)))
		alert_audio.play()
		return
	for a in sfx_players:
		if not a.playing:
			a.stream = load('res://assets/audio/' + id + '.wav')
			a.volume_db = linear_to_db(maxf(.001, float(saved.settings.master) * float(saved.settings.sfx)))
			a.play()
			return

func setup_music():
	var stream = AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = 44100
	var bytes = PackedByteArray()
	bytes.resize(88200)
	var notes = [130.81,164.81,196.0,164.81,146.83,174.61,220.0,174.61]
	for i in range(44100):
		var t = float(i) / 22050.0
		var v = int(1100 * sin(TAU * notes[int(t * 4) % 8] * t) * (1.0-fmod(t*4,1.0)))
		bytes.encode_s16(i*2,v)
	stream.data = bytes
	music = AudioStreamPlayer.new()
	add_child(music)
	music.stream = stream
	update_music()
	if not test_mode: music.play()

func update_music():
	if music: music.volume_db = linear_to_db(maxf(.001,float(saved.settings.master)*float(saved.settings.music)))

func clear_ui():
	for n in ui_root.get_children():
		ui_root.remove_child(n)
		n.queue_free()
	ability_button=null
	ability_touch_ids.clear()
	hud = null
	boss_hud = null
	stick_id = -1
	move_input = Vector2.ZERO
	stick_pos = Vector2.ZERO

func label_at(text: String, pos: Vector2, size: int = 32, color: Color = Color.WHITE, parent: Node = null) -> Label:
	var l = Label.new()
	l.text = text
	l.position = pos
	l.add_theme_font_size_override('font_size',size)
	l.add_theme_color_override('font_color',color)
	l.add_theme_color_override('font_shadow_color',INK)
	l.add_theme_constant_override('shadow_offset_x',3)
	l.add_theme_constant_override('shadow_offset_y',3)
	(parent if parent else ui_root).add_child(l)
	return l

func style(color: Color) -> StyleBoxFlat:
	if style_cache.has(color): return style_cache[color]
	var s = StyleBoxFlat.new()
	s.bg_color = color
	s.border_color = TEAL.darkened(.35)
	s.set_border_width_all(3)
	s.set_corner_radius_all(22)
	s.content_margin_left = 24
	s.content_margin_right = 24
	style_cache[color] = s
	return s

func button(text: String, pos: Vector2, size: Vector2, action: Callable, color: Color = Color('#243958')) -> Button:
	var b = Button.new()
	b.text = text
	b.position = pos
	b.size = size
	b.custom_minimum_size = size
	b.add_theme_font_size_override('font_size',29)
	b.add_theme_stylebox_override('normal',style(color))
	b.add_theme_stylebox_override('hover',style(color.lightened(.15)))
	b.add_theme_stylebox_override('pressed',style(TEAL.darkened(.5)))
	b.pressed.connect(func(): sound('click'); action.call())
	ui_root.add_child(b)
	return b

func backdrop(title: String, subtitle: String = ''):
	clear_ui()
	var bg = ColorRect.new()
	bg.color = Color(INK,.95)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(bg)
	label_at(title,Vector2(100,75),64,GOLD)
	label_at(subtitle,Vector2(105,162),27,TEAL)

func main_menu():
	change_state(State.MAIN_MENU)
	cleanup()
	player.position = Vector2(1200,800)
	backdrop('MAYHEM SURVIVORS','BY RF WORLDS  /  ANDROID ALPHA')
	var play_button = button('SPIELEN',Vector2(110,300),Vector2(600,110),character_select,Color('#147f81'))
	var char_button = button('CHARAKTERE',Vector2(110,435),Vector2(600,110),character_select)
	var stats_button = button('STATISTIK',Vector2(110,570),Vector2(600,110),statistics)
	var settings_button = button('EINSTELLUNGEN',Vector2(110,705),Vector2(600,110),func(): settings(main_menu))
	var goals_button=button('ZIELE & STILE',Vector2(110,820),Vector2(600,95),challenges_screen)
	var stack = VBoxContainer.new()
	stack.position = Vector2(110,300)
	stack.size = Vector2(600,575)
	stack.add_theme_constant_override('separation',20)
	ui_root.add_child(stack)
	for item in [play_button,char_button,stats_button,settings_button,goals_button]:
		item.custom_minimum_size.y=95
		item.reparent(stack)
	label_at('0.5.0 Alpha • Offline • Keine Werbung',Vector2(110,970),25)
	portrait(Vector2(1330,530),1,1.05)
	label_at('DEIN HELD.\nDEINE WAFFE.\nDEIN MAYHEM.',Vector2(1000,320),48,TEAL)

func portrait(pos: Vector2, index: int, factor: float = 1.0, mode: String = 'portrait'):
	var art = Control.new()
	art.set_script(preload('res://scripts/ui/portrait.gd'))
	art.position = pos
	art.scale = Vector2.ONE*factor
	art.color = Color(characters[index].color)
	art.kind = characters[index].id
	art.mode = mode
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(art)

func character_select():
	change_state(State.CHARACTER_SELECT)
	backdrop('WÄHLE DEINEN HELDEN','RF WORLDS / MAYHEM CREW')
	var roles = ['DER BERSERKER','DIE TECHNIKERIN','DER SCHATTEN']
	for i in range(3):
		var c = characters[i]
		var x = 100 + i*585
		var card = Panel.new()
		card.position = Vector2(x,230)
		card.size = Vector2(550,705)
		card.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var box = style(Color('#201d35')).duplicate()
		box.border_color = Color(c.color).darkened(.4)
		card.add_theme_stylebox_override('panel',box)
		ui_root.add_child(card)
		portrait(Vector2(x+77,240),i,1.1)
		label_at(roles[i],Vector2(x+25,645),23,Color(c.color))
		label_at(c.name,Vector2(x+25,677),42,Color.WHITE)
		label_at(c.description,Vector2(x+25,739),22)
		label_at('%d HP / %d Tempo / %s' % [c.hp,c.speed,weapon_data[c.weapon].name],Vector2(x+25,782),21)
		label_at(['Nur Hammer','Blaster / Splitgun / Arc Cannon','Nur Orbit Blade'][i]+' • '+hero_ability.data[c.id].name,Vector2(x+25,808),18,Color(c.color))
		button('AUSWÄHLEN',Vector2(x+20,835),Vector2(510,85),func(): selected=i; arena_select(),Color(c.color).darkened(.65))
	button('ZURÜCK',Vector2(100,965),Vector2(340,85),main_menu)

func duration_text(seconds: float) -> String:
	var value=int(maxf(0,seconds))
	return '%02d:%02d' % [value/60,value%60]

func statistics(character: int = -1, arena_filter: String = 'all'):
	var totals=saved if arena_filter=='all' else saved.arena_records[arena_filter]
	var profiles=saved.records if arena_filter=='all' else totals.records
	backdrop('DEINE STATISTIK','Arena: '+('Alle Arenen' if arena_filter=='all' else Arenas.definition(arena_filter).name))
	var filters=['all','scrapyard','reactor']
	button('ARENA WECHSELN',Vector2(1330,105),Vector2(460,85),func():statistics(character,filters[(filters.find(arena_filter)+1)%3]))
	for i in range(4):
		var tab=i-1
		button(['ÜBERSICHT','BRUISER','SPARKY','SHADE'][i],Vector2(100+i*435,235),Vector2(400,80),func(): statistics(tab,arena_filter),Color('#147f81') if tab==character else Color('#243958'))
	if character<0:
		label_at('ALLE RUNDEN',Vector2(120,365),28,TEAL)
		var rate=100.0*float(totals.wins)/float(totals.games) if totals.games>0 else 0.0
		label_at('Spiele: %d\nSiege: %d  /  %.0f %%\nHöchste Welle: %d / 10\nBesiegte Gegner: %d\nSpielzeit: %.1f Minuten' % [totals.games,totals.wins,rate,totals.highest_wave,totals.kills,float(totals.time)/60],Vector2(120,420),36)
		var best=RunRecords.aggregate(profiles)
		label_at('PERSÖNLICHE BESTWERTE',Vector2(1010,365),28,GOLD)
		label_at('Kills in einer Runde: %d\nHöchstes Level: %d\nGrößter Schaden: %d\nLängster Run: %s\nSchnellster Sieg: %s' % [best.best_kills,best.best_level,best.best_damage,duration_text(best.longest_run),duration_text(best.fastest_victory) if best.fastest_victory>0 else '—'],Vector2(1010,420),32)
	else:
		var record=profiles[characters[character].id]
		portrait(Vector2(110,355),character,1.05)
		label_at(characters[character].name,Vector2(130,770),36,Color(characters[character].color))
		label_at('BILANZ',Vector2(650,365),28,TEAL)
		label_at('Spiele: %d\nSiege: %d\nKills gesamt: %d\nCoins gesamt: %d\nSpielzeit: %.1f Minuten' % [record.games,record.wins,record.kills,record.coins,record.time/60],Vector2(650,420),31)
		label_at('BESTWERTE',Vector2(1250,365),28,GOLD)
		label_at('Welle: %d / 10\nKills: %d\nLevel: %d\nSchaden: %d\nLängster Run: %s\nSchnellster Sieg: %s' % [record.best_wave,record.best_kills,record.best_level,record.best_damage,duration_text(record.longest_run),duration_text(record.fastest_victory) if record.fastest_victory>0 else '—'],Vector2(1250,420),29)
	button('ZURÜCK',Vector2(110,900),Vector2(400,95),main_menu)
	var history=button('LETZTE RUNDEN →',Vector2(1110,900),Vector2(650,95),func(): recent_runs_screen(character,0,arena_filter))
	history.disabled=saved.recent_runs.is_empty()
	if saved.recent_runs.is_empty():label_at('Der Verlauf beginnt mit deinem nächsten Run.',Vector2(1010,830),24)

func recent_runs_screen(character: int = -1, page: int = 0, arena_filter: String = 'all'):
	var records: Array=[]
	for run in saved.recent_runs:
		if (character<0 or run.character==characters[character].id) and (arena_filter=='all' or run.get('arena','scrapyard')==arena_filter):records.append(run)
	var pages=maxi(1,ceili(records.size()/4.0))
	page=clampi(page,0,pages-1)
	backdrop('LETZTE RUNDEN','Bis zu 20 neue Runden lokal gespeichert / '+('Alle Charaktere' if character<0 else characters[character].name))
	if records.is_empty():label_at('Für diesen Charakter ist noch keine neue Runde gespeichert.',Vector2(120,400),32)
	for row in range(4):
		var index=page*4+row
		if index>=records.size():break
		var run=records[index]
		var y=285+row*137
		var card=Panel.new()
		card.position=Vector2(100,y)
		card.size=Vector2(1710,118)
		card.mouse_filter=Control.MOUSE_FILTER_IGNORE
		card.add_theme_stylebox_override('panel',style(Color('#201d35')))
		ui_root.add_child(card)
		var hero=RunRecords.CHARACTERS.find(run.character)
		label_at(characters[hero].name,Vector2(125,y+10),29,Color(characters[hero].color))
		label_at('SIEG' if run.won else 'GAME OVER',Vector2(465,y+10),29,Color('#2ED573') if run.won else Color('#FF6376'))
		label_at('Welle %d / 10   LV %d   %d Kills   %s' % [run.wave,run.level,run.kills,duration_text(run.time)],Vector2(940,y+12),25)
		var loadout=''
		for w in run.weapons:loadout+='%s Lv.%d  ' % [Specs.label(w) if not Specs.label(w).is_empty() else weapon_data[w.id].name,w.level]
		label_at(Arenas.definition(run.get('arena','scrapyard')).name+' / '+loadout,Vector2(125,y+65),21)
		label_at('%d Schaden  /  %d Coins' % [run.damage,run.coins],Vector2(1190,y+65),23,GOLD)
	button('ZURÜCK',Vector2(100,905),Vector2(350,95),func(): statistics(character,arena_filter))
	var previous=button('← VORHERIGE',Vector2(590,905),Vector2(350,95),func(): recent_runs_screen(character,page-1,arena_filter))
	previous.disabled=page==0
	label_at('%d / %d' % [page+1,pages],Vector2(1040,930),30)
	var next=button('NÄCHSTE →',Vector2(1280,905),Vector2(480,95),func(): recent_runs_screen(character,page+1,arena_filter))
	next.disabled=page>=pages-1

func settings(back: Callable):
	backdrop('EINSTELLUNGEN','Audio, Vibration und Trefferfeedback')
	var keys = ['master','music','sfx']
	for i in range(3):
		var key = keys[i]
		label_at(['MASTER','MUSIK','EFFEKTE'][i],Vector2(120,300+i*120),32)
		var slider = HSlider.new()
		slider.position = Vector2(500,300+i*120)
		slider.size = Vector2(800,75)
		slider.min_value = 0
		slider.max_value = 1
		slider.step = .05
		slider.value = float(saved.settings[key])
		slider.value_changed.connect(func(v): saved.settings[key]=v; update_music(); save_game())
		ui_root.add_child(slider)
	for i in range(3):
		var q = ['LOW','MEDIUM','HIGH'][i]
		button(('✓ ' if saved.settings.quality == q else '')+q,Vector2(120+i*460,710),Vector2(420,95),func(): saved.settings.quality=q; save_game(); settings(back))
	var modes=['OFF','LOW','HIGH']
	var mode=saved.settings.get('haptics','OFF')
	button('VIBRATION: '+{'OFF':'AUS','LOW':'DEZENT','HIGH':'STARK'}[mode],Vector2(120,825),Vector2(620,90),func(): saved.settings.haptics=modes[(modes.find(mode)+1)%3];save_game();haptic('ability');settings(back))
	button('SCHADENSZAHLEN: '+('AN' if saved.settings.get('damage_numbers',true) else 'AUS'),Vector2(800,825),Vector2(700,90),func(): saved.settings.damage_numbers=not saved.settings.get('damage_numbers',true);save_game();settings(back))
	button('ZURÜCK',Vector2(120,960),Vector2(420,85),back)

func cleanup():
	if combat_visuals: combat_visuals.clear()
	if world_visuals: world_visuals.clear()
	if arena_hazards:arena_hazards.clear()
	if reactor_guardian:reactor_guardian.clear()
	if specialized_combat:specialized_combat.clear()
	if hero_ability:hero_ability.clear()
	if hit_feedback:hit_feedback.clear()
	enemies.clear()
	loot.clear()
	effects.clear()
	projectile_pool.clear()
	boss_warning = ''

func start_run():
	if not Arenas.unlocked(saved,arena_id):arena_select();return
	arena_definition=Arenas.definition(arena_id)
	waves=read_data(arena_definition.waves)
	cleanup()
	var c = characters[selected]
	max_hp = c.hp
	hp = max_hp
	speed = c.speed
	damage_mult = 1
	attack_mult = 1.0+float(c.attack_speed_bonus)
	crit = .05+float(c.crit_bonus)
	armor = 0
	magnet = 100
	projectile_speed = 1
	multishot = 0
	level = 1
	xp = 0
	coins = 0
	earned = 0
	kills = 0
	dealt = 0
	run_time = 0
	wave_number = 1
	upgrade_counts.clear()
	weapons = [{'id':c.weapon,'level':1,'clock':0.0}]
	player.position = Vector2(1200,800)
	facing = 1.0
	result_recorded = false
	prepare_wave()

func prepare_wave():
	change_state(State.WAVE_PREPARATION)
	backdrop('WELLE %d / 10' % wave_number,arena_definition.boss_name+' ERWACHT' if wave_number == 10 else arena_definition.name+' / Bewege dich, sammle Kristalle und überlebe!')
	label_at('Automatische Waffen • Links unten bewegen\nXP sammeln → Upgrades wählen\nZwischen den Wellen: Ausrüstung kaufen',Vector2(120,350),36)
	var ability=hero_ability.definition()
	label_at('RECHTS UNTEN: '+ability.name+' / %.0f s Abklingzeit' % ability.cooldown,Vector2(120,525),30,Color(ability.color))
	var help=label_at(ability.description,Vector2(120,575),26)
	help.custom_minimum_size.x=1550
	help.size.x=1550
	help.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	button('LOS GEHT’S',Vector2(120,680),Vector2(650,120),begin_wave,Color('#147f81'))

func begin_wave():
	cleanup()
	remaining = float(waves[wave_number-1].duration)
	spawn_clock = .2
	boss_clock = 3
	boss_phase = 0
	boss_charging = false
	if wave_number == 10: spawn_enemy('boss')
	change_state(State.COMBAT)
	make_hud()

func make_hud():
	clear_ui()
	hud = label_at('',Vector2(75,35),30)
	boss_hud = label_at('',Vector2(620,150),32,Color('#FF4757'))
	button('Ⅱ',Vector2(1690,40),Vector2(140,100),pause_game)
	ability_button=button('',ABILITY_RECT.position,ABILITY_RECT.size,func():hero_ability.activate())
	ability_button.set_script(preload('res://scripts/ui/ability_button.gd'))
	ability_button.game=self
	ability_button.focus_mode=Control.FOCUS_NONE
	ability_button.action_mode=BaseButton.ACTION_MODE_BUTTON_PRESS
	joystick = Control.new()
	joystick.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick.set_script(load('res://scripts/mobile/joystick_visual.gd'))
	joystick.set('game',self)
	ui_root.add_child(joystick)
	refresh_hud()

func refresh_hud():
	if not is_instance_valid(hud): return
	var info = '♥ %d / %d     LV %d  ◈ %d / %d     ● %d\nWELLE %d / 10     %02d:%02d' % [ceili(hp),max_hp,level,xp,required_xp(),coins,wave_number,int(remaining)/60,int(remaining)%60]
	if hud.text != info: hud.text = info
	boss_hud.text = ''
	for e in enemies:
		if e.kind == 'boss':
			boss_hud.text = '%s   %d / %d\n%s' % [arena_definition.boss_name,maxi(0,int(e.hp)),int(e.max_hp),boss_warning]
			var warning=world_visuals.boss_telegraph()
			if not warning.is_empty(): boss_hud.text += '  %.1f s' % warning.seconds

func _input(event):
	if event is InputEventScreenTouch:
		var pos = ui_root.get_global_transform().affine_inverse() * event.position
		if event.index in ability_touch_ids:
			if not event.pressed:ability_touch_ids.erase(event.index)
			get_viewport().set_input_as_handled()
			return
		if state==State.COMBAT and event.pressed and event.index!=stick_id and ABILITY_RECT.has_point(pos):
			ability_touch_ids.append(event.index)
			hero_ability.activate()
			get_viewport().set_input_as_handled()
			return
		if state == State.COMBAT and event.pressed and stick_id == -1 and pos.x < 700 and pos.y > 540:
			stick_id = event.index
			stick_origin = Vector2(clampf(pos.x,130,570),clampf(pos.y,680,930))
			stick_pos = (pos-stick_origin).limit_length(110)
			get_viewport().set_input_as_handled()
		elif event.index == stick_id and not event.pressed:
			stick_id = -1
			stick_pos = Vector2.ZERO
			move_input = Vector2.ZERO
	if event is InputEventScreenDrag and event.index in ability_touch_ids:
		get_viewport().set_input_as_handled()
		return
	if event is InputEventScreenDrag and event.index == stick_id:
		stick_pos = ((ui_root.get_global_transform().affine_inverse()*event.position)-stick_origin).limit_length(110)
		move_input = stick_pos/110.0 if stick_pos.length()>14 else Vector2.ZERO
		get_viewport().set_input_as_handled()

func _notification(what):
	if what == NOTIFICATION_APPLICATION_PAUSED or what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if state == State.COMBAT: pause_game()
		save_game()
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if state == State.COMBAT: pause_game()
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()
		get_tree().quit()

func pause_game():
	if state != State.COMBAT: return
	change_state(State.PAUSED)
	pause_menu()

func pause_menu():
	backdrop('DURCHATMEN','Simulation angehalten')
	button('FORTSETZEN',Vector2(120,320),Vector2(620,110),resume)
	button('EINSTELLUNGEN',Vector2(120,460),Vector2(620,110),func(): settings(pause_menu))
	button('HAUPTMENÜ',Vector2(120,600),Vector2(620,110),confirm_leave)

func resume():
	change_state(State.COMBAT)
	make_hud()

func confirm_leave():
	backdrop('RUN WIRKLICH BEENDEN?','Dieser Durchlauf wird als Niederlage gewertet.')
	button('WEITERSPIELEN',Vector2(120,420),Vector2(650,110),pause_menu)
	button('RUN BEENDEN',Vector2(120,570),Vector2(650,110),func(): finish(false); main_menu())

func _physics_process(delta):
	animation_clock += delta
	queue_redraw()
	if is_instance_valid(joystick): joystick.queue_redraw()
	if is_instance_valid(ability_button):ability_button.queue_redraw()
	if state != State.COMBAT: return
	specialized_combat.update(delta)
	hit_feedback.update(delta)
	hero_ability.update(delta)
	if state != State.COMBAT:return
	combat_visuals.update(delta)
	world_visuals.update(delta)
	run_time += delta
	remaining = maxf(0,remaining-delta)
	hurt_clock -= delta
	if absf(move_input.x)>.08: facing = -1.0 if move_input.x<0 else 1.0
	if not hero_ability.move_dash(delta):player.move_analog(move_input,speed)
	if state != State.COMBAT:return
	orbit_angle += delta*3.5
	spawn_clock -= delta
	if spawn_clock <= 0:
		spawn_clock += float(waves[wave_number-1].interval)
		if enemies.size()<100:
			var roll = rng.randf()
			if is_reactor():
				var w=waves[wave_number-1]
				spawn_enemy('tank' if roll<w.tank_weight else ('runner' if roll<w.tank_weight+w.runner_weight else 'grunt'))
			else:spawn_enemy('tank' if wave_number>=3 and roll<.18 else ('runner' if wave_number>=2 and roll<.55 else 'grunt'))
	arena_hazards.update(delta)
	if state != State.COMBAT:return
	update_enemies(delta)
	if state != State.COMBAT: return
	update_weapons(delta)
	if state != State.COMBAT: return
	update_shots(delta)
	update_loot(delta)
	for i in range(effects.size()-1,-1,-1):
		effects[i].life -= delta
		if effects[i].life <= 0: effects.remove_at(i)
	if state != State.COMBAT: return
	if xp >= required_xp(): level_up(); return
	if remaining <= 0:
		if wave_number == 10: finish(false)
		else:
			cleanup()
			open_shop()
	refresh_hud()

func spawn_enemy(kind: String):
	var d = enemy_definition(kind)
	var angle = rng.randf()*TAU
	var pos = (player.position+Vector2.from_angle(angle)*rng.randf_range(650,850)).clamp(Vector2(70,70),Vector2(2330,1530))
	if pos.distance_to(player.position)<450:
		pos = Vector2(2300 if player.position.x<1200 else 100,1500 if player.position.y<800 else 100)
	var scaling = 1.0 if kind == 'boss' else 1.0+(wave_number-1)*.09
	enemies.append({'kind':kind,'pos':pos,'hp':float(d.hp)*scaling,'max_hp':float(d.hp)*scaling,'speed':float(d.speed),'damage':float(d.damage),'radius':float(d.radius),'hit':0.0,'orbit_cd':0.0})

func update_enemies(dt: float):
	if wave_number==10 and is_reactor():reactor_guardian.update(dt)
	if wave_number == 10 and not is_reactor():
		boss_clock -= dt
		if boss_clock <= 0:
			boss_phase = (boss_phase+1)%4
			boss_charging = boss_phase == 0
			if boss_phase==1: sound('boss_radial_warning')
			if boss_phase==3: sound('boss_charge_warning')
			boss_clock = 1.3 if boss_phase%2 == 1 else 3.2
			boss_warning = '⚠ RADIALSALVE!' if boss_phase == 1 else ('⚠ STURMANGRIFF!' if boss_phase == 3 else '')
			if boss_phase == 3: boss_target = player.position
			if boss_phase == 2:
				for e in enemies:
					if e.kind == 'boss':
						for j in range(18): shoot(e.pos,Vector2.from_angle(TAU*j/18),14,true,240,4.5)
					sound('warning')
	for i in range(enemies.size()):
		var e = enemies[i]
		e.hit = maxf(0,e.hit-dt)
		e.orbit_cd = maxf(0,e.orbit_cd-dt)
		var dir: Vector2 = (player.position-e.pos).normalized()
		var velocity: Vector2 = dir*e.speed
		if e.kind == 'boss' and is_reactor():
			if reactor_guardian.stationary():velocity=Vector2.ZERO
		elif e.kind == 'boss':
			if boss_phase%2 == 1: velocity *= .15
			if boss_charging and boss_phase == 0 and boss_clock>2.1: velocity = (boss_target-e.pos).normalized()*520
		if float(e.get('ability_slow_time',0))>0:
			velocity*=float(e.get('ability_slow',1.0))
			e.ability_slow_time=maxf(0,e.ability_slow_time-dt)
		# Staggered limited local separation avoids quadratic full neighbor scans.
		for j in range(i+1,mini(i+7,enemies.size())):
			if e.kind=='boss' and is_reactor() and reactor_guardian.stationary():break
			var other = enemies[j]
			var offset: Vector2 = e.pos-other.pos
			var distance = offset.length()
			if distance<e.radius+other.radius and distance>.1:
				velocity += offset/distance*45
		e.pos = (e.pos+velocity*dt).clamp(Vector2(35,35),Vector2(2365,1565))
		if e.pos.distance_to(player.position)<e.radius+27 and hurt_clock<=0: hurt(e.damage)
		if state != State.COMBAT: return

func hurt(amount: float):
	if state != State.COMBAT or hurt_clock>0 or hero_ability.invulnerable(): return
	hp -= maxf(1,amount-armor)
	hurt_clock = .65
	sound('hit')
	hit_feedback.damage(player.position,maxf(1,amount-armor),false,true)
	haptic('hurt')
	if hp <= 0: hp=0; finish(false)

func nearest(pos: Vector2, reach: float):
	var target = null
	var best = reach*reach
	for e in enemies:
		var dist = pos.distance_squared_to(e.pos)
		if e.hp>0 and dist<best: best=dist; target=e
	return target

func update_weapons(dt: float):
	weapon_manager.update(dt)

func shoot(pos: Vector2, direction: Vector2, power: float, hostile: bool, velocity: float, life: float, weapon_id: String = 'blaster'):
	var shot=projectile_pool.acquire(pos,direction,power,hostile,velocity,life)
	if shot!=null:
		shot.skin = selected
		shot.weapon = weapon_id
	return shot

func update_shots(dt: float):
	for s in shots:
		if not s.active: continue
		var old: Vector2 = s.pos
		s.pos += s.vel*dt
		s.life -= dt
		if s.life<=0: s.active=false; continue
		if s.hostile:
			if Geometry2D.get_closest_point_to_segment(player.position,old,s.pos).distance_to(player.position)<34:
				s.active=false
				combat_visuals.impact(s.pos,'boss',true)
				hurt(s.damage)
				if state != State.COMBAT: return
		elif s.get('spec','')!='':
			specialized_combat.projectile(s,old)
			if state!=State.COMBAT:return
		else:
			for e in enemies.duplicate():
				if Geometry2D.get_closest_point_to_segment(e.pos,old,s.pos).distance_to(e.pos)<e.radius+8:
					s.active=false
					combat_visuals.impact(s.pos,s.get('weapon','blaster'))
					damage_enemy(e,s.damage)
					if state != State.COMBAT: return
					break

func damage_enemy(e: Dictionary, power: float):
	if e.hp<=0 or not enemies.has(e): return
	var critical = rng.randf()<crit
	var amount = power*(2 if critical else 1)
	dealt += minf(e.hp,amount)
	e.hp -= amount
	e.hit = .15
	hit_feedback.damage(e.pos,amount,critical)
	if e.hp<=0:
		var kind: String = e.kind
		var pos: Vector2 = e.pos
		world_visuals.enemy_defeated(e)
		enemies.erase(e)
		kills += 1
		var reward = int(enemy_definition(kind).coins)
		coins += reward
		add_effect(pos+Vector2(0,20),GOLD,22,'+%d ●' % reward)
		earned += reward
		loot.append({'pos':pos,'xp':int(enemy_definition(kind).xp)})
		add_effect(pos,Color(enemy_data[kind].color),50,'')
		sound('death')
		sound('coin')
		if kind == 'boss': finish(true)

func update_loot(dt: float):
	for i in range(loot.size()-1,-1,-1):
		var l = loot[i]
		var distance = l.pos.distance_to(player.position)
		if distance<magnet: l.pos = l.pos.move_toward(player.position,600*dt)
		if distance<34:
			xp += l.xp
			loot.remove_at(i)
			sound('xp')
	# Merge bounded crystal storage without discarding XP.
	while loot.size()>240:
		loot[0].xp += loot.back().xp
		loot.pop_back()

func required_xp() -> int:
	return roundi(20*pow(1.18,level-1))

func has_projectile_weapon() -> bool:
	for w in weapons:
		if w.id in ['blaster','splitgun']: return true
	return false

func valid_upgrade(id: String) -> bool:
	var count = int(upgrade_counts.get(id,0))
	match id:
		'heal': return hp<max_hp
		'crit': return crit<.75
		'projectile':
			return upgrade_counts.get(id,0)<6 and has_projectile_weapon()
		'multi':
			var suitable = false
			for w in weapons:
				if w.id in ['blaster','splitgun']: suitable=true
			return suitable and multishot<4
		'armor': return armor<20
		'speed': return count<8
		'magnet': return count<6
		'rapid': return count<10
	return true

func level_up():
	xp -= required_xp()
	level += 1
	change_state(State.LEVEL_UP)
	sound('level')
	haptic('level')
	backdrop('LEVEL %d • DEIN UPGRADE' % level,'Wähle eine Verbesserung. Der Kampf wartet auf dich.')
	var pool: Array = []
	for u in upgrades:
		if valid_upgrade(u[0]): pool.append(u)
	pool.shuffle()
	for i in range(mini(3,pool.size())):
		var u = pool[i]
		var x = 100+i*580
		label_at(u[1],Vector2(x+30,320),86,TEAL)
		label_at(u[2],Vector2(x+20,450),33,GOLD)
		label_at(u[3],Vector2(x+20,520),25)
		button('WÄHLEN',Vector2(x,680),Vector2(530,110),func(): apply_upgrade(u[0]); if_more_levels())

func if_more_levels():
	if xp>=required_xp(): level_up()
	else: resume()

func apply_upgrade(id: String):
	upgrade_counts[id] = int(upgrade_counts.get(id,0))+1
	match id:
		'vital': max_hp+=20; hp=minf(max_hp,hp+20)
		'damage': damage_mult+=.12
		'rapid': attack_mult+=.10
		'speed': speed*=1.08
		'crit': crit=minf(.75,crit+.05)
		'armor': armor=mini(20,armor+2)
		'magnet': magnet*=1.25
		'projectile': projectile_speed*=1.12
		'heal': hp=minf(max_hp,hp+25)
		'multi': multishot=mini(4,multishot+1)

func allowed_weapon_ids() -> Array:
	return characters[selected].allowed_weapons

func can_equip_weapon(id: String) -> bool:
	return allowed_weapon_ids().has(id)

func class_weapon_summary() -> String:
	var names: Array[String]=[]
	for id in allowed_weapon_ids(): names.append(weapon_data[id].name)
	return ' / '.join(names)

func generate_offers():
	offers.clear()
	var pool: Array = []
	for id in allowed_weapon_ids():
		var existing = weapon_level(id)
		if (existing==0 and weapons.size()<4) or (existing>0 and existing<5):
			pool.append({'type':'weapon','id':id,'name':weapon_data[id].name,'description':'Neue Waffe' if existing==0 else 'Waffenlevel %d → %d' % [existing,existing+1],'price':int((18+wave_number*5)*(1+existing*.3)),'rarity':'SELTEN' if id in ['arc','orbit'] else 'STANDARD'})
	for u in upgrades:
		if valid_upgrade(u[0]): pool.append({'type':'upgrade','id':u[0],'name':u[2],'description':u[3],'price':12+wave_number*4,'rarity':'STANDARD'})
	pool.shuffle()
	for i in range(mini(4,pool.size())): offers.append(pool[i])

func weapon_level(id: String) -> int:
	for w in weapons:
		if w.id==id: return w.level
	return 0

func open_shop():
	change_state(State.SHOP)
	rerolls = 0
	generate_offers()
	show_shop()

func weapon_icon(id: String, pos: Vector2, size: Vector2):
	var icon = TextureRect.new()
	var atlas = AtlasTexture.new()
	atlas.atlas = preload('res://scripts/ui/combat_art.gd').TEXTURE
	atlas.region = preload('res://scripts/ui/combat_art.gd').weapon(id)
	icon.texture = atlas
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.position = pos
	icon.size = size
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(icon)

func show_shop():
	if not pending_specialization().is_empty():specialization_screen();return
	backdrop('MAYHEM MARKET','%s • %d Coins • %s' % [characters[selected].name,coins,class_weapon_summary()])
	for i in range(offers.size()):
		var o = offers[i]
		var x = 85+i*455
		if o.type=='weapon': weapon_icon(o.id,Vector2(x+270,248),Vector2(130,108))
		label_at(('⚒ ' if o.type=='weapon' else '✦ ')+o.rarity,Vector2(x,300),25,TEAL)
		label_at(o.name,Vector2(x,365),29,GOLD)
		label_at(o.description,Vector2(x,425),22)
		var b = button('GEKAUFT' if o.get('sold',false) else '%d ●  KAUFEN' % o.price,Vector2(x,555),Vector2(420,110),func(): buy_offer(i))
		b.disabled = o.get('sold',false) or coins<o.price
	button('REROLL • '+('GRATIS' if rerolls==0 else '%d ●' % (5+rerolls*3)),Vector2(100,790),Vector2(650,100),reroll_shop)
	button('NÄCHSTE WELLE →',Vector2(1050,790),Vector2(650,100),next_shop_wave,Color('#147f81'))
	label_at('Ausrüstung: '+weapon_summary(),Vector2(100,940),25)

func weapon_summary() -> String:
	var text = ''
	for w in weapons: text += '%s Lv.%d  ' % [Specs.label(w) if not Specs.label(w).is_empty() else weapon_data[w.id].name,w.level]
	return text

func buy_offer(index: int) -> bool:
	if state!=State.SHOP or index<0 or index>=offers.size(): return false
	var o = offers[index]
	if o.get('sold',false) or coins<o.price: return false
	if o.type=='weapon':
		if not can_equip_weapon(o.id): return false
		var lvl = weapon_level(o.id)
		if lvl>=5 or (lvl==0 and weapons.size()>=4): return false
		if lvl==0: weapons.append({'id':o.id,'level':1,'clock':0.0})
		else:
			for w in weapons:
				if w.id==o.id: w.level+=1
	else:
		if not valid_upgrade(o.id): return false
		apply_upgrade(o.id)
	coins -= int(o.price)
	o.sold = true
	sound('buy')
	show_shop()
	return true

func reroll_shop() -> bool:
	if state!=State.SHOP: return false
	var cost = 0 if rerolls==0 else 5+rerolls*3
	if coins<cost: return false
	coins-=cost
	rerolls+=1
	generate_offers()
	show_shop()
	return true

func finish(victory: bool):
	if result_recorded: return
	result_recorded = true
	change_state(State.VICTORY if victory else State.GAME_OVER)
	saved.games+=1
	saved.wins+=int(victory)
	saved.kills+=kills
	saved.time+=run_time
	saved.highest_wave=maxi(int(saved.highest_wave),wave_number)
	var improvements=RunRecords.add_run(saved,{'arena':arena_id,'character':characters[selected].id,'won':victory,'wave':wave_number,'time':run_time,'kills':kills,'level':level,'damage':dealt,'coins':earned,'weapons':weapons})
	var unlocked=Arenas.sync(saved)
	save_game()
	cleanup()
	sound('victory' if victory else 'defeat')
	backdrop('MAYHEM GEMEISTERT!' if victory else 'DAS WAR EIN MAYHEM!',arena_definition.name+' • '+('SIEG' if victory else 'GAME OVER'))
	if victory:
		var celebration=Control.new()
		celebration.set_script(preload('res://scripts/ui/victory_fx.gd'))
		celebration.count=12 if saved.settings.quality=='LOW' else (24 if saved.settings.quality=='MEDIUM' else 40)
		celebration.mouse_filter=Control.MOUSE_FILTER_IGNORE
		ui_root.add_child(celebration)
	portrait(Vector2(1380,300),selected,1.05,'victory' if victory else 'defeat')
	label_at('Welle %d / 10     Zeit %02d:%02d\nKills %d     Level %d\nSchaden %d     Gesammelte Coins %d\n\n%s' % [wave_number,int(run_time)/60,int(run_time)%60,kills,level,dealt,earned,weapon_summary()],Vector2(110,300),33)
	if not improvements.is_empty(): label_at('NEUER PERSÖNLICHER BESTWERT',Vector2(110,640),26,GOLD)
	if not unlocked.is_empty():label_at('FREIGESCHALTET: '+', '.join(unlocked),Vector2(110,685),24,TEAL)
	button('NOCHMAL SPIELEN',Vector2(110,740),Vector2(540,110),start_run)
	button('CHARAKTERE',Vector2(690,740),Vector2(500,110),character_select)
	button('HAUPTMENÜ',Vector2(1230,740),Vector2(500,110),main_menu)

func add_effect(pos: Vector2, color: Color, radius: float, text: String):
	var cap = 30 if saved.settings.quality=='LOW' else (65 if saved.settings.quality=='MEDIUM' else 110)
	if effects.size()<cap: effects.append({'pos':pos,'color':color,'radius':radius,'life':.45,'text':text})

func character_facing() -> float:
	var x=combat_visuals.target_direction.x
	return -1.0 if x<-.1 else (1.0 if x>.1 else facing)

func draw_player_character():
	var moving = state == State.COMBAT and move_input.length_squared()>.01
	var stride = sin(animation_clock*12) if moving else 0.0
	var pos = player.position
	var accent = Color({'gold':'#FFD166','mayhem':'#FF33E0','reactor':'#2ED573'}.get(saved.settings.get('aura','class'),characters[selected].color))
	draw_set_transform(pos+Vector2(0,26),0,Vector2(1,.3))
	draw_circle(Vector2.ZERO,33,Color(0,0,0,.3))
	draw_arc(Vector2.ZERO,35,0,TAU,32,Color(accent,.55),3,true)
	draw_set_transform(pos,stride*.035,Vector2(character_facing(),1))
	var tint = Color(2,2,2,1) if hurt_clock>.4 else Color.WHITE
	var rect = Rect2(Vector2(-48,-64-absf(stride)*3),Vector2(96,96))
	draw_texture_rect_region(CharacterArt.GAMEPLAY_TEXTURE,rect,CharacterArt.body_region(characters[selected].id),tint)
	draw_set_transform(Vector2.ZERO)

func _draw():
	world_visuals.draw_arena()
	if state in [State.MAIN_MENU,State.CHARACTER_SELECT,State.ARENA_SELECT,State.BOOT]:
		for i in range(8):
			var kind=['grunt','runner','tank'][i%3]
			world_visuals.draw_enemy({'kind':kind,'pos':Vector2(250+i*240,650+sin(animation_clock+i)*180),'radius':38.0,'hit':0.0},true)
		return
	arena_hazards.draw()
	if is_reactor():reactor_guardian.draw()
	world_visuals.draw_telegraph()
	world_visuals.draw_deaths()
	hero_ability.draw()
	for l in loot:
		var p: Vector2 = l.pos
		draw_circle(p,18,Color(0,.85,.8,.12))
		draw_colored_polygon(PackedVector2Array([p+Vector2(0,-13),p+Vector2(9,0),p+Vector2(0,13),p+Vector2(-9,0)]),TEAL)
		draw_line(p+Vector2(0,-9),p+Vector2(-5,0),Color.WHITE,3)
	# Keep the player visible in crowds, as in the accepted combat version.
	for e in enemies: world_visuals.draw_enemy(e)
	combat_visuals.draw_weapons(true)
	draw_player_character()
	combat_visuals.draw_weapons(false)
	combat_visuals.draw_shots()
	specialized_combat.draw()
	combat_visuals.draw_effects()
	hit_feedback.draw()
	for e in effects:
		if e.has('end'): draw_line(e.pos,e.end,e.color,5,true)
		else:
			draw_arc(e.pos,e.radius*(1.5-e.life),0,TAU,20,Color(e.color,e.life*2),4,true)
			if e.text!='': draw_string(ThemeDB.fallback_font,e.pos+Vector2(-12,-35*(1-e.life)),e.text,HORIZONTAL_ALIGNMENT_LEFT,-1,24,e.color)

func _exit_tree():
	if is_instance_valid(alert_audio):
		alert_audio.stop()
		alert_audio.stream=null
	if is_instance_valid(music):
		music.stop()
		music.stream = null
	for a in sfx_players:
		if is_instance_valid(a):
			a.stop()
			a.stream = null

func is_reactor() -> bool:return arena_id=='reactor'
func enemy_definition(kind: String) -> Dictionary:
	return arena_definition.boss if kind=='boss' and is_reactor() else enemy_data[kind]
func choose_arena(id: String) -> bool:
	if not Arenas.IDS.has(id) or not Arenas.unlocked(saved,id):return false
	arena_id=id
	start_run()
	return true
func arena_select():
	change_state(State.ARENA_SELECT)
	backdrop('WÄHLE DEINE ARENA',characters[selected].name+' / 10 Wellen / Ein Boss / Deine Ausrüstung')
	for i in range(2):
		var id=Arenas.IDS[i]
		var d=Arenas.definition(id)
		var x=110+i*865
		var art=Control.new()
		art.set_script(preload('res://scripts/ui/arena_preview.gd'))
		art.texture=load('res://assets/environments/'+d.floor+'.png')
		art.position=Vector2(x,260)
		art.size=Vector2(805,350)
		art.clip_contents=true
		art.mouse_filter=Control.MOUSE_FILTER_IGNORE
		ui_root.add_child(art)
		label_at(d.name,Vector2(x,635),42,TEAL if i==0 else Color('#2ED573'))
		label_at(d.description,Vector2(x,705),25)
		label_at('BOSS: '+d.boss_name,Vector2(x,755),25,GOLD)
		var available=Arenas.unlocked(saved,id)
		var enter=button('ARENA BETRETEN' if available else 'ERSTER SIEG BENÖTIGT',Vector2(x,825),Vector2(805,100),func(): choose_arena(id),Color('#147f81') if available else Color('#343749'))
		enter.disabled=not available
	button('ZURÜCK',Vector2(110,965),Vector2(350,85),character_select)
func challenges_screen():
	backdrop('ZIELE & STILE','Nur Optik: Alle Ringe behalten die gleichen Kampfwerte.')
	var rows=[['gold','CHAMPIONRING','Gewinne einen Run.',saved.wins,1],['mayhem','MAYHEMRING','Besiege insgesamt 1.000 Gegner.',saved.kills,1000],['reactor','REAKTORSIEGEL','Besiege den Reaktorwächter.',saved.arena_records.reactor.wins,1]]
	for i in range(rows.size()):
		var r=rows[i]
		var y=280+i*190
		label_at(r[1],Vector2(120,y),36,GOLD)
		label_at('%s  %d / %d' % [r[2],mini(r[3],r[4]),r[4]],Vector2(120,y+58),28)
		var unlocked=saved.unlocked_styles.has(r[0])
		var selected_style=saved.settings.get('aura','class')==r[0]
		var equip=button('AKTIV' if selected_style else ('AKTIVIEREN' if unlocked else 'GESPERRT'),Vector2(1220,y),Vector2(520,105),func(): saved.settings.aura=r[0];save_game();challenges_screen())
		equip.disabled=not unlocked or selected_style
	button('KLASSENRING',Vector2(720,905),Vector2(520,95),func(): saved.settings.aura='class';save_game();challenges_screen())
	button('ZURÜCK',Vector2(110,905),Vector2(400,95),main_menu)

func haptic(kind:String) -> bool:
	if test_mode or not OS.has_feature('android'):return false
	return haptic_feedback.request(saved.settings.get('haptics','OFF'),kind,Time.get_ticks_msec(),func(duration:int,amplitude:float):Input.vibrate_handheld(duration,amplitude))

func pending_specialization() -> Dictionary:
	for w in weapons:
		if w.level==5 and Specs.definition(w).is_empty() and can_equip_weapon(w.id):return w
	return {}
func specialization_screen():
	if state!=State.SHOP:return
	var w=pending_specialization()
	if w.is_empty():show_shop();return
	backdrop('WÄHLE DEINE ENTWICKLUNG',weapon_data[w.id].name+' / Stufe 5 / Kostenlos / Gilt für diesen Run')
	var choices=Specs.choices(w.id)
	for i in range(choices.size()):
		var id=choices[i]
		var d=Specs.all()[id]
		var x=110+i*865
		var icon=TextureRect.new()
		icon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
		icon.texture=load('res://assets/ui/specializations/'+id+'.svg')
		icon.position=Vector2(x+260,265)
		icon.size=Vector2(220,220)
		icon.mouse_filter=Control.MOUSE_FILTER_IGNORE
		ui_root.add_child(icon)
		label_at(d.name,Vector2(x+15,520),42,Color(d.color))
		var description=label_at(d.description,Vector2(x+15,605),30)
		description.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
		description.set_deferred('size',Vector2(760,155))
		button('ENTWICKELN',Vector2(x,815),Vector2(805,110),func():choose_specialization(w.id,id),Color(d.color).darkened(.65))
	label_at('Eine Wahl pro Waffe. Keine zusätzlichen Coins. Kampf und Timer stehen still.',Vector2(120,985),25)
func choose_specialization(weapon:String,id:String) -> bool:
	if state!=State.SHOP or not can_equip_weapon(weapon) or not Specs.valid(weapon,id):return false
	var w=pending_specialization()
	if w.is_empty() or w.id!=weapon:return false
	w.spec=id
	sound('spec_evolve')
	show_shop()
	return true
func next_shop_wave():
	if state!=State.SHOP:return
	if not pending_specialization().is_empty():specialization_screen();return
	wave_number+=1
	prepare_wave()

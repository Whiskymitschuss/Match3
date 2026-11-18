extends Node2D
# All simulation advances exclusively in COMBAT. UI stays active in every state.
const GameStateMachine = preload('res://scripts/core/game_state_machine.gd')
const State = GameStateMachine.State
const RunRecords = preload('res://scripts/progression/run_records.gd')
const Unlocks=preload('res://scripts/progression/hero_unlocks.gd')
const Mastery = preload('res://scripts/progression/character_mastery.gd')
const CharacterArt = preload('res://scripts/ui/character_art.gd')
const WorldProgress=preload('res://scripts/progression/world_progress.gd')
const Arenas = preload('res://scripts/core/arena_catalog.gd')
var menu_motion=preload('res://scripts/mobile/menu_motion.gd').new(self)
const Difficulty=preload('res://scripts/gameplay/difficulty.gd')
const DifficultyRecords=preload('res://scripts/progression/difficulty_records.gd')
var selected_difficulty='normal'
var run_difficulty='normal'
var selection_swipe=preload('res://scripts/mobile/selection_swipe.gd').new(self)
var hero_cursor=0
var arena_cursor=0
var reward_hub
var run_waves=0
var run_abilities=0
var run_events=0
var steelfist
const Collection=preload('res://scripts/progression/collection.gd')
const GearArt=preload('res://scripts/ui/gear_art.gd')
var garage
var equipped_spell
var run_gear:Dictionary={}
var run_loadout:Dictionary={}
var studio_reward=0
var united
var game_guide
var world_map
var spell_button
var run_mode='campaign'
var rules
var tutorial
var arena_id='scrapyard'
var arena_definition=Arenas.definition('scrapyard')
var arena_hazards
var reactor_guardian
var ravox
var enemy_pack
var arena_events
var scrapyard_salvage
var bruiser_builds
var result_details:Dictionary={}
var enemy_roles
var encounters
var bombs
var twinkle
var hero_ability
var hit_feedback
var vfx
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
const DisplayLayout=preload('res://scripts/mobile/display_layout.gd')
var safe_logical=Rect2(0,0,1920,1080)
var ui_bleed=Rect2(0,0,1920,1080)
var pause_button:Button
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
var run_items
var shop_view
var ui_revision=0
var audio_director
const UISkin=preload('res://scripts/ui/skin.gd')
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
const WaveBalance=preload('res://scripts/gameplay/wave_balance.gd')
var spawn_cycle=0
var spawn_clock = 0.0
var hurt_clock = 0.0
var orbit_angle = 0.0
var animation_clock = 0.0
var breaker
var axel_shop_pending=false
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
	if audio_director:audio_director.state_changed(next)

func _ready():
	rules=preload('res://scripts/gameplay/run_rules.gd').new(self)
	rng.randomize()
	run_items=preload('res://scripts/economy/run_items.gd').new(self)
	shop_view=preload('res://scripts/ui/shop_view.gd').new(self)
	weapon_manager = preload('res://scripts/weapons/weapon_manager.gd').new(self)
	combat_visuals = preload('res://scripts/combat/combat_visuals.gd').new(self)
	world_visuals = preload('res://scripts/gameplay/world_visuals.gd').new(self)
	arena_hazards=preload('res://scripts/gameplay/arena_hazards.gd').new(self)
	reactor_guardian=preload('res://scripts/bosses/reactor_guardian.gd').new(self)
	breaker=preload('res://scripts/bosses/breaker_axel.gd').new(self)
	united=preload('res://scripts/expansion/united.gd').new(self)
	bombs=preload('res://scripts/characters/kicksy_bombs.gd').new(self)
	twinkle=preload('res://scripts/characters/twinkle_combat.gd').new(self)
	steelfist=preload('res://scripts/characters/steelfist_combat.gd').new(self)
	hero_ability=preload('res://scripts/characters/hero_ability.gd').new(self)
	hit_feedback=preload('res://scripts/combat/hit_feedback.gd').new(self)
	specialized_combat=preload('res://scripts/weapons/specialized_combat.gd').new(self)
	vfx=preload('res://scripts/combat/mayhem_vfx.gd').new(self)
	enemy_pack=preload('res://scripts/enemies/enemy_pack.gd').new(self)
	arena_events=preload('res://scripts/gameplay/arena_events.gd').new(self)
	scrapyard_salvage=preload('res://scripts/gameplay/scrapyard_salvage.gd').new(self)
	bruiser_builds=preload('res://scripts/ui/bruiser_builds.gd').new(self)
	ravox=preload('res://scripts/enemies/ravox_controller.gd').new(self)
	enemy_roles=preload('res://scripts/enemies/reactor_roles.gd').new(self)
	encounters=preload('res://scripts/gameplay/encounter_director.gd').new(self)
	load_save()
	reward_hub=preload('res://scripts/ui/reward_hub.gd').new(self)
	garage=preload('res://scripts/ui/garage_hub.gd').new(self)
	world_map=preload('res://scripts/ui/world_map.gd').new(self)
	game_guide=preload('res://scripts/ui/game_guide.gd').new(self)
	equipped_spell=preload('res://scripts/gameplay/equipped_spell.gd').new(self)
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
	tutorial=preload('res://scripts/progression/tutorial_controller.gd').new(self)
	add_child(tutorial)
	get_tree().auto_accept_quit = false
	main_menu()

func update_safe_area():
	if not ui_root:return
	var viewport_size=get_viewport_rect().size
	var screen=Vector2.ZERO
	var safe=Rect2()
	if OS.has_feature('android'):
		screen=Vector2(DisplayServer.screen_get_size())
		safe=Rect2(DisplayServer.get_display_safe_area())
	var layout=DisplayLayout.calculate(viewport_size,screen,safe)
	ui_root.scale=Vector2.ONE*layout.scale
	ui_root.position=layout.position
	ui_root.size=Vector2(1920,1080)
	safe_logical=layout.safe
	ui_bleed=layout.bleed
	var bg=ui_root.get_node_or_null('FullBleedBackdrop')
	if bg:bg.position=ui_bleed.position;bg.size=ui_bleed.size
	var chrome=ui_root.get_node_or_null('HudChrome')
	if chrome:chrome.queue_redraw()
	if is_instance_valid(hud):hud.position=Vector2(75,35)+hud_top_left()
	if is_instance_valid(boss_hud):boss_hud.position=Vector2(620,222)+Vector2(0,safe_logical.position.y)
	if is_instance_valid(pause_button):pause_button.position=Vector2(1690,40)+hud_top_right()
	if is_instance_valid(ability_button):ability_button.position=ability_rect().position
	stick_id=-1
	ability_touch_ids.clear()
	stick_pos=Vector2.ZERO
	move_input=Vector2.ZERO
	if camera:camera.zoom=Vector2.ONE*DisplayLayout.camera_zoom(viewport_size)
func hud_top_left() -> Vector2:return safe_logical.position
func hud_top_right() -> Vector2:return Vector2(safe_logical.end.x-1920,safe_logical.position.y)
func ability_rect() -> Rect2:
	return Rect2(ABILITY_RECT.position+safe_logical.end-Vector2(1920,1080),ABILITY_RECT.size)
func joystick_rest() -> Vector2:return Vector2(220+safe_logical.position.x,850+safe_logical.end.y-1080)

func default_save():
	return SaveManager.defaults()

func load_save():
	saved = SaveManager.load_local()

func save_game():
	SaveManager.save_local(saved)

func sound(id: String):
	if audio_director:audio_director.play(id)

func setup_music():
	audio_director=preload('res://scripts/audio/audio_director.gd').new(self)

func update_music():
	if audio_director:audio_director.update_settings()

func clear_ui():
	selection_swipe.set_context('')
	ui_revision+=1
	for n in ui_root.get_children():
		ui_root.remove_child(n)
		n.queue_free()
	pause_button=null
	ability_button=null
	ability_touch_ids.clear()
	hud = null
	boss_hud = null
	stick_id = -1
	move_input = Vector2.ZERO
	stick_pos = Vector2.ZERO

func label_at(text: String, pos: Vector2, size: int = 32, color: Color = Color.WHITE, parent: Node = null) -> Label:
	var l = Label.new()
	l.mouse_filter=Control.MOUSE_FILTER_IGNORE
	l.text = text
	l.position = pos
	l.add_theme_font_size_override('font_size',size)
	l.add_theme_font_override('font',UISkin.HEADING if size>=40 else UISkin.BODY)
	l.add_theme_color_override('font_color',color)
	l.add_theme_color_override('font_shadow_color',INK)
	l.add_theme_constant_override('shadow_offset_x',3)
	l.add_theme_constant_override('shadow_offset_y',3)
	(parent if parent else ui_root).add_child(l)
	return l

func style(color: Color) -> StyleBoxFlat:
	if style_cache.has(color): return style_cache[color]
	var s=UISkin.box(color,Color('#FFAE35') if color.r>color.b*1.3 else Color('#795396'))
	style_cache[color] = s
	return s

func button(text: String, pos: Vector2, size: Vector2, action: Callable, color: Color = Color('#2F2044')) -> Button:
	var b = Button.new()
	var icon_id='' if text in ['‹','›'] else UISkin.Icons.button_id(text)
	b.text=text.replace('▶','').replace('←','').replace('→','').replace('✓','AKTIV ·').replace('●','').replace('Ⅱ','').replace('? HILFE','HILFE').strip_edges()
	if not icon_id.is_empty():
		b.icon=UISkin.Icons.get_icon(icon_id);b.expand_icon=true
		b.add_theme_constant_override('icon_max_width',44)
		b.add_theme_constant_override('h_separation',14)
	b.set_script(preload('res://scripts/ui/menu_button.gd'));b.motion_enabled=saved.settings.quality!='LOW' and not saved.settings.get('reduced_motion',false)
	b.position = pos
	b.size = size
	b.custom_minimum_size = size
	b.add_theme_font_size_override('font_size',32)
	b.add_theme_font_override('font',UISkin.HEADING)
	b.add_theme_color_override('font_color',Color('#F6EDDD'))
	b.add_theme_color_override('font_disabled_color',Color('#7B8490'))
	b.add_theme_stylebox_override('disabled',UISkin.box(Color('#171E28'),Color('#303C4A')))
	var focus=UISkin.box(Color(0,0,0,0),Color('#FFD166'));focus.bg_color=Color(0,0,0,0)
	b.add_theme_stylebox_override('focus',focus)
	b.add_theme_stylebox_override('normal',style(color))
	b.add_theme_stylebox_override('hover',style(color.lightened(.15)))
	b.add_theme_stylebox_override('pressed',style(Color('#78246B')))
	b.pressed.connect(func(): sound('click'); action.call())
	ui_root.add_child(b)
	return b

func backdrop(title: String, subtitle: String = ''):
	clear_ui()
	UISkin.background(self)
	UISkin.decorate_screen(self,title)
	UISkin.brand(self)
	schedule_menu_reveal()
	label_at(title,Vector2(100,75),64,GOLD)
	label_at(subtitle,Vector2(105,162),27,TEAL)

func schedule_menu_reveal():call_deferred('_reveal_menu',ui_revision)
func _reveal_menu(revision:int):UISkin.reveal(self,revision)
func queue_ui_action(action:Callable):call_deferred('_apply_ui_action',ui_revision,action)
func _apply_ui_action(revision:int,action:Callable):
	if revision==ui_revision and action.is_valid():action.call()

func main_menu():
	if tutorial and tutorial.active:tutorial.stop(false);return
	change_state(State.MAIN_MENU)
	cleanup()
	player.position = Vector2(1200,800)
	UISkin.menu(self)

func play():
	if saved.games>0 or saved.settings.get('onboarding_seen',false) or saved.settings.tutorial_complete:character_select();return
	backdrop('WILLKOMMEN, FIGHTER!','Kicksy zeigt dir Bewegung, Kampf und Werkstatt mit deinem ersten Helden Bruiser.')
	UISkin.panel(self,Rect2(100,265,720,670),TEAL)
	portrait(Vector2(190,280),4,1.5)
	label_at('DEIN ERSTER RUN',Vector2(925,315),56,GOLD)
	var help=label_at('Links bewegen, automatisch kämpfen, rechts die Schockwelle auslösen.\n\nIm Training probierst du alle wichtigen Tasten selbst aus. Du kannst es jederzeit verlassen und später wiederholen.',Vector2(925,420),32)
	help.text=UISkin.wrap_text(help.text,UISkin.BODY,32,820)
	button('MIT KICKSY ÜBEN',Vector2(925,725),Vector2(850,105),func():queue_ui_action(func():saved.settings.onboarding_seen=true;save_game();tutorial.start()),Color('#147F81'))
	button('DIREKT ZUR CREW',Vector2(925,865),Vector2(850,95),func():queue_ui_action(func():saved.settings.onboarding_seen=true;save_game();character_select()))
	button('ZURÜCK',Vector2(100,965),Vector2(500,85),func():queue_ui_action(main_menu))

func portrait(pos: Vector2, index: int, factor: float = 1.0, mode: String = 'portrait'):
	var art = Control.new()
	art.set_script(preload('res://scripts/ui/portrait.gd'))
	art.position = pos
	art.scale = Vector2.ONE*factor
	art.color = Color(characters[index].color)
	art.kind = characters[index].id
	art.outfit = Mastery.selected(saved,art.kind)
	art.hunter = Mastery.goals(saved,art.kind)[1].value>=250
	art.mode = mode
	art.gear=saved.collection.loadouts[characters[index].id].duplicate(true)
	art.decor=saved.meta.equipped.duplicate(true)
	art.motion_enabled=not saved.settings.get('reduced_motion',false)
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(art)

func character_select(index:int=-1):
	if index>=0:hero_cursor=index
	hero_cursor=posmod(hero_cursor,characters.size())
	change_state(State.CHARACTER_SELECT)
	backdrop('DEINE MAYHEM CREW','Links oder rechts wischen / %d von %d' % [hero_cursor+1,characters.size()])
	selection_swipe.set_context('hero')
	button('CASES',Vector2(1420,75),Vector2(400,85),garage.cases)
	var c=characters[hero_cursor]
	UISkin.panel(self,Rect2(100,245,740,675),Color(c.color))
	portrait(Vector2(170,245),hero_cursor,1.65)
	label_at(c.name,Vector2(920,270),64,Color(c.color))
	if c.id=='steelfist':label_at(c.title,Vector2(925,337),23,GOLD)
	label_at(c.description,Vector2(925,365),31)
	label_at('BASIS: %d HP / %d Tempo / %s' % [roundi(c.hp*(1+float(c.get('hp_bonus',0)))),c.speed,weapon_data[Collection.starter(saved,c.id)].name],Vector2(925,425),29)
	var info=label_at(hero_ability.data[c.id].name+'\n'+hero_ability.data[c.id].description+'\n\nKlassenwaffen: '+(' / '.join(c.allowed_weapons.map(func(id):return weapon_data[id].name))),Vector2(925,505),27)
	if float(weapon_data[c.weapon].get('boss_power',1))>1:info.text+='\nKlassenwaffe gegen Bosse: ×%.2f Schaden' % weapon_data[c.weapon].boss_power
	info.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;info.set_deferred('size',Vector2(830,240))
	if c.id=='steelfist':
		var traits=label_at('160 Basis-HP +30 % / 10 % Schadensreduktion\n2 % Heilung je 5 s / jeder 4. Schlag: 150 % Schaden',Vector2(925,725),23,TEAL)
		traits.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;traits.set_deferred('size',Vector2(830,75))
		var quote=label_at('„'+c.quote+'“',Vector2(120,848),22,GOLD)
		quote.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;quote.set_deferred('size',Vector2(695,65))
	var available=Unlocks.available(saved,c.id)
	if not available:label_at('Freischalten: CREW-CASE / Chancen im Case-Menü',Vector2(925,750),25,GOLD)
	var enter=button('AUSWÄHLEN' if available else 'NOCH GESPERRT',Vector2(925,810),Vector2(850,105),func():selected=hero_cursor;arena_select(),Color(c.color).darkened(.65))
	enter.disabled=not available
	button('ZURÜCK',Vector2(100,965),Vector2(350,85),main_menu)
	button('VORHERIGER',Vector2(500,965),Vector2(300,85),func():selection_shift('hero',-1))
	button('NÄCHSTER',Vector2(840,965),Vector2(300,85),func():selection_shift('hero',1))
	button('INVENTAR & STILE',Vector2(1180,965),Vector2(650,85),func():garage.show(hero_cursor))
func selection_shift(kind:String,direction:int):
	if kind=='hero' and state==State.CHARACTER_SELECT:character_select(hero_cursor+direction);sound('click')
	elif kind=='arena' and state==State.ARENA_SELECT:arena_cursor=posmod(arena_cursor+direction,Arenas.IDS.size());arena_select();sound('click')

func duration_text(seconds: float) -> String:
	var value=int(maxf(0,seconds))
	return '%02d:%02d' % [value/60,value%60]

func statistics(character: int = -1, arena_filter: String = 'all'):
	var totals=saved if arena_filter=='all' else saved.arena_records[arena_filter]
	var profiles=saved.records if arena_filter=='all' else totals.records
	backdrop('DEINE STATISTIK','Arena: '+('Alle Arenen' if arena_filter=='all' else Arenas.definition(arena_filter).name))
	var filters=['all']+Arenas.IDS
	button('STUFEN-REKORDE',Vector2(800,75),Vector2(480,85),difficulty_statistics)
	button('ENDLOS-REKORDE',Vector2(550,900),Vector2(520,95),endless_statistics)
	button('ARENA WECHSELN',Vector2(1330,75),Vector2(460,85),func():statistics(character,filters[(filters.find(arena_filter)+1)%filters.size()]))
	var first_tab=maxi(0,(character+1)/6)*6
	for i in range(first_tab,mini(first_tab+6,characters.size()+1)):
		var tab=i-1
		var tab_width=1720.0/6
		button('ÜBERSICHT' if i==0 else characters[i-1].name,Vector2(100+(i-first_tab)*tab_width,235),Vector2(tab_width-14,80),func(): statistics(tab,arena_filter),Color('#147f81') if tab==character else Color('#243958'))
	button('WEITERE HELDEN',Vector2(110,810),Vector2(700,70),func():statistics(5 if first_tab==0 else -1,arena_filter))
	if character<0:
		label_at('KAMPAGNEN-RUNDEN',Vector2(120,365),28,TEAL)
		var rate=100.0*float(totals.wins)/float(totals.games) if totals.games>0 else 0.0
		label_at('Spiele: %d\nSiege: %d  /  %.0f %%\nHöchste Welle: %d / 10\nBesiegte Gegner: %d\nSpielzeit: %.1f Minuten' % [totals.games,totals.wins,rate,totals.highest_wave,totals.kills,float(totals.time)/60],Vector2(120,420),36)
		var best=RunRecords.aggregate(profiles)
		label_at('PERSÖNLICHE BESTWERTE',Vector2(1010,365),28,GOLD)
		label_at('Kills in einer Runde: %d\nHöchstes Level: %d\nGrößter Schaden: %d\nLängster Run: %s\nSchnellster Sieg: %s' % [best.best_kills,best.best_level,best.best_damage,duration_text(best.longest_run),duration_text(best.fastest_victory) if best.fastest_victory>0 else '—'],Vector2(1010,420),32)
	else:
		var record=profiles[characters[character].id]
		portrait(Vector2(110,355),character,1.05)
		label_at(characters[character].name,Vector2(130,770),36,Color(characters[character].color))
		label_at('KAMPAGNEN-BILANZ',Vector2(650,365),28,TEAL)
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
		label_at(('Welle %d / 10   LV %d   %d Kills   %s' % [run.wave,run.level,run.kills,duration_text(run.time)])+(' / %d Eliten' % int(run.get('elite_kills',0))),Vector2(940,y+12),25)
		var loadout=''
		for w in run.weapons:loadout+='%s Lv.%d  ' % [Specs.label(w) if not Specs.label(w).is_empty() else weapon_data[w.id].name,w.level]
		label_at(Arenas.definition(run.get('arena','scrapyard')).name+' / '+Difficulty.definition(run.get('difficulty','normal')).name+' / '+loadout,Vector2(125,y+65),21)
		label_at('%d Schaden  /  %d Coins' % [run.damage,run.coins],Vector2(1190,y+65),23,GOLD)
	button('ZURÜCK',Vector2(100,905),Vector2(350,95),func(): statistics(character,arena_filter))
	var previous=button('← VORHERIGE',Vector2(590,905),Vector2(350,95),func(): recent_runs_screen(character,page-1,arena_filter))
	previous.disabled=page==0
	label_at('%d / %d' % [page+1,pages],Vector2(1040,930),30)
	var next=button('NÄCHSTE →',Vector2(1280,905),Vector2(480,95),func(): recent_runs_screen(character,page+1,arena_filter))
	next.disabled=page>=pages-1

func settings(back: Callable):
	backdrop('EINSTELLUNGEN','Audio, Vibration und Trefferfeedback')
	button('BEWEGUNG',Vector2(1570,310),Vector2(260,120),motion_settings)
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
		slider.add_theme_icon_override('grabber',preload('res://assets/ui/slider_grab.svg'))
		slider.add_theme_icon_override('grabber_highlight',preload('res://assets/ui/slider_grab.svg'))
		var rail=UISkin.box(Color('#182230'));rail.content_margin_top=7;rail.content_margin_bottom=7
		slider.add_theme_stylebox_override('slider',rail)
		slider.add_theme_stylebox_override('grabber_area',UISkin.box(Color('#B56B1E'),GOLD))
		var percentage=label_at('%d %%' % int(slider.value*100),Vector2(1360,310+i*120),34,GOLD)
		slider.value_changed.connect(func(v): saved.settings[key]=v;percentage.text='%d %%' % roundi(v*100); update_music(); save_game())
		ui_root.add_child(slider)
	for i in range(3):
		var q = ['LOW','MEDIUM','HIGH'][i]
		button(('✓ ' if saved.settings.quality == q else '')+q,Vector2(120+i*460,710),Vector2(420,95),func(): saved.settings.quality=q; vfx.apply_settings(); save_game(); settings(back))
	var modes=['OFF','LOW','HIGH']
	var mode=saved.settings.get('haptics','OFF')
	button('VIBRATION: '+{'OFF':'AUS','LOW':'DEZENT','HIGH':'STARK'}[mode],Vector2(120,825),Vector2(620,90),func(): saved.settings.haptics=modes[(modes.find(mode)+1)%3];save_game();haptic('ability');settings(back))
	button('SCHADENSZAHLEN: '+('AN' if saved.settings.get('damage_numbers',true) else 'AUS'),Vector2(800,825),Vector2(700,90),func(): saved.settings.damage_numbers=not saved.settings.get('damage_numbers',true);save_game();settings(back))
	button('CARTOON-SPLATTER: '+('AN' if saved.settings.get('splatter',true) else 'AUS'),Vector2(800,960),Vector2(700,85),func(): saved.settings.splatter=not saved.settings.get('splatter',true);vfx.apply_settings();save_game();settings(back))
	button('ZURÜCK',Vector2(120,960),Vector2(420,85),back)

func cleanup():
	if united:united.clear()
	axel_shop_pending=false
	if breaker:breaker.clear()
	if equipped_spell:equipped_spell.invulnerability=0;equipped_spell.touch_ids.clear()
	if arena_events:arena_events.clear()
	if scrapyard_salvage:scrapyard_salvage.clear()
	if encounters:encounters.clear_combat()
	if combat_visuals: combat_visuals.clear()
	if world_visuals: world_visuals.clear()
	if arena_hazards:arena_hazards.clear()
	if reactor_guardian:reactor_guardian.clear()
	if enemy_roles:enemy_roles.clear()
	if specialized_combat:specialized_combat.clear()
	if hero_ability:hero_ability.clear()
	if twinkle:twinkle.clear()
	if steelfist:steelfist.clear()
	if bombs:bombs.clear()
	if hit_feedback:hit_feedback.clear()
	if vfx:vfx.clear()
	enemies.clear()
	loot.clear()
	effects.clear()
	projectile_pool.clear()
	boss_warning = ''

func start_run():
	if not Unlocks.available(saved,characters[selected].id) and not (tutorial and tutorial.active and run_mode=='tutorial'):character_select(selected);return
	if not Arenas.unlocked(saved,arena_id):arena_select();return
	run_difficulty=selected_difficulty if selected_difficulty in Difficulty.IDS else 'normal'
	arena_definition=Arenas.definition(arena_id)
	waves=read_data(arena_definition.waves)
	cleanup()
	var c = characters[selected]
	run_gear=Collection.snapshot(saved,c.id) if run_mode!='tutorial' else {}
	run_loadout=saved.collection.loadouts[c.id].duplicate(true) if run_mode!='tutorial' else {}
	max_hp = roundi(c.hp*(1+float(c.get('hp_bonus',0))))
	max_hp+=float(run_gear.get('hp',0))
	hp = max_hp
	speed = c.speed*(1+float(c.get('move_bonus',0)))
	speed*=1+float(run_gear.get('speed',0))
	damage_mult = 1
	attack_mult = 1.0+float(c.attack_speed_bonus)
	crit = .05+float(c.crit_bonus)
	armor = int(run_gear.get('armor',0))+int(c.get('armor',0))
	magnet = 100+float(run_gear.get('magnet',0))
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
	run_items.clear()
	scrapyard_salvage.reset_run()
	result_details.clear()
	encounters.reset_run()
	ravox.reset_run()
	steelfist.reset_run()
	shop_view.tab='weapons'
	upgrade_counts.clear()
	weapons = [{'id':Collection.starter(saved,c.id) if run_mode!='tutorial' else c.weapon,'level':1,'clock':0.0}]
	equipped_spell.reset();studio_reward=0
	player.position = Vector2(1200,800)
	facing = 1.0
	hurt_clock=0
	result_recorded = false
	run_waves=0;run_abilities=0;run_events=0
	prepare_wave()

func prepare_wave():
	change_state(State.WAVE_PREPARATION)
	if united.enabled and rules.boss_wave():united.bosses.intro();return
	if breaker.scheduled():breaker.intro();return
	backdrop(('WELLE %d / ENDLOS' if run_mode=='endless' else 'WELLE %d / 10') % wave_number,arena_definition.boss_name+' ERWACHT' if rules.boss_wave() else arena_definition.name+(' / Verstärkte Gegnergruppen ab Welle 4' if wave_number>=4 else ' / Bewege dich, sammle Kristalle und überlebe!'))
	label_at('Automatische Waffen • Links unten bewegen\nXP sammeln → Upgrades wählen\nZwischen den Wellen: Ausrüstung kaufen',Vector2(120,350),36)
	var ability=hero_ability.definition()
	label_at('RECHTS UNTEN: '+ability.name+' / %.0f s Abklingzeit' % ability.cooldown,Vector2(120,525),30,Color(ability.color))
	var help=label_at(ability.description,Vector2(120,575),26)
	help.custom_minimum_size.x=1550
	help.size.x=1550
	help.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	if is_reactor():
		var tips=label_at('NEUE GEGNER\nAb Welle 2: Spucker – rote Linie, dann Schuss.\nAb Welle 4: Drohne – 30 % Schutz im Umfeld.\nDrohne zuerst: ihr Schutz stapelt sich nicht.\nBosse und Drohnen bleiben ungeschützt.',Vector2(1030,310),25,TEAL)
		tips.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
		tips.set_deferred('size',Vector2(730,200))
	if ((wave_number-1)%10)+1 in ([3,5,7,9] if united.enabled else [4,6,8,9]):
		label_at('ELITE: '+('IMPULSWÄCHTER / Ring meiden oder grüne Öffnung nutzen' if is_reactor() else 'SCHROTTBRECHER / Sturmrichtung verlassen / Schockwelle unterbricht'),Vector2(120,850),25,GOLD)
		label_at('Elite besiegen: zusätzliche Beutewahl im nächsten Shop.',Vector2(120,900),24,TEAL)
	if wave_number>=5 and not rules.boss_wave():label_at('RAVOX / Orange Sturmbahn verlassen / Seife und Schockwelle unterbrechen',Vector2(120,950),24,Color('#FFAA55'))
	if rules.boss_wave():label_at('Bossphasen bei 65 % und 30 % HP / Neue Angriffe werden gold markiert',Vector2(120,850),25,GOLD)
	if scrapyard_salvage.available():
		label_at('OPTIONALE BERGUNG / Ab Sekunde 24 im türkisen Kreis 1,2 s anhalten.',Vector2(120,755),28,TEAL)
		label_at('Zwei Einschlagsalven ausweichen: +%d Run-Coins. Ignorieren ist erlaubt.' % scrapyard_salvage.reward(),Vector2(120,800),25,GOLD)
	button('LOS GEHT’S',Vector2(120,680),Vector2(650,120),begin_wave,Color('#147f81'))

func begin_wave():
	cleanup()
	remaining = float(rules.current_wave().duration)
	spawn_cycle=0
	spawn_clock = .2
	boss_clock = 3
	boss_phase = 0
	boss_charging = false
	if breaker.scheduled():spawn_enemy('breaker_axel')
	elif united.enabled and united.bosses.scheduled() and not rules.final_boss_wave():spawn_enemy('champion')
	elif rules.boss_wave(): spawn_enemy('boss')
	change_state(State.COMBAT)
	make_hud()

func make_hud():
	clear_ui()
	var chrome=Control.new();chrome.name='HudChrome';chrome.set_script(preload('res://scripts/ui/hud_chrome.gd'));chrome.game=self;ui_root.add_child(chrome)
	hud = label_at('',Vector2(75,35)+hud_top_left(),30)
	boss_hud = label_at('',Vector2(620,222)+Vector2(0,safe_logical.position.y),32,Color('#FF4757'))
	pause_button=button('Ⅱ',Vector2(1690,40)+hud_top_right(),Vector2(140,100),pause_game)
	ability_button=button('',ability_rect().position,ABILITY_RECT.size,func():hero_ability.activate())
	ability_button.set_script(preload('res://scripts/ui/ability_button.gd'))
	ability_button.game=self
	ability_button.focus_mode=Control.FOCUS_NONE
	ability_button.action_mode=BaseButton.ACTION_MODE_BUTTON_PRESS
	if equipped_spell.id!='':
		spell_button=button('',equipped_spell.rect().position,equipped_spell.rect().size,func():equipped_spell.activate())
		spell_button.set_script(preload('res://scripts/ui/spell_button.gd'));spell_button.game=self
	joystick = Control.new()
	joystick.mouse_filter = Control.MOUSE_FILTER_IGNORE
	joystick.set_script(load('res://scripts/mobile/joystick_visual.gd'))
	joystick.set('game',self)
	ui_root.add_child(joystick)
	refresh_hud()

func refresh_hud():
	if not is_instance_valid(hud): return
	var info = 'HP %d / %d    LV %d    XP %d / %d\nWELLE %d / 10    %02d:%02d    RUN-COINS %d' % [ceili(hp),max_hp,level,xp,required_xp(),wave_number,int(remaining)/60,int(remaining)%60,coins]
	if run_mode=='endless':info=info.replace('WELLE %d / 10' % wave_number,'WELLE %d / ENDLOS' % wave_number)
	if run_mode!='tutorial':info='['+Difficulty.definition(run_difficulty).name+'] '+info
	if run_mode=='tutorial':info=info.split('\n')[0]+'\nTUTORIAL   RUN-COINS %d' % coins
	if saved.settings.get('show_fps',false):info+='\n%.0f FPS / %d Gegner / %d Projektile' % [Engine.get_frames_per_second(),enemies.size(),shots.filter(func(s):return s.active).size()]
	if hud.text != info: hud.text = info
	boss_hud.text = ''
	var warning_stage=breaker.stage if breaker.scheduled() else united.bosses.stage
	boss_hud.add_theme_color_override('font_color',GOLD if warning_stage in ['windup','phase'] else Color('#F6EDDD'))
	for e in enemies:
		if e.kind == 'breaker_axel':
			boss_hud.text='BREAKER AXEL / PHASE %d / %d / %d HP\n%s' % [breaker.tier,maxi(0,ceili(e.hp)),roundi(e.max_hp),breaker.warning_text()]
		elif united.enabled and e.kind in ['boss','champion']:
			boss_hud.text='%s / PHASE %d / %d / %d HP\n%s' % [e.get('boss_name',arena_definition.boss_name),united.bosses.tier,maxi(0,ceili(e.hp)),roundi(e.max_hp),boss_warning]
		elif e.kind == 'boss' and not united.enabled:
			boss_hud.text = '%s   %d / %d%s\n%s' % [arena_definition.boss_name,maxi(0,ceili(e.hp)),roundi(e.max_hp),('  /  PHASE %d' % encounters.boss_tier) if encounters.enabled else '',boss_warning]
			var warning=world_visuals.boss_telegraph()
			if not warning.is_empty(): boss_hud.text += '  %.1f s' % warning.seconds

func _input(event):
	if selection_swipe.handle(event):get_viewport().set_input_as_handled();return
	if equipped_spell and equipped_spell.input(event):get_viewport().set_input_as_handled();return
	if event is InputEventScreenTouch:
		var pos = ui_root.get_global_transform().affine_inverse() * event.position
		if tutorial and tutorial.blocks_touch(pos) and event.index!=stick_id and not event.index in ability_touch_ids:return
		if event.index in ability_touch_ids:
			if not event.pressed:ability_touch_ids.erase(event.index)
			get_viewport().set_input_as_handled()
			return
		if state==State.COMBAT and event.pressed and event.index!=stick_id and ability_rect().has_point(pos):
			ability_touch_ids.append(event.index)
			hero_ability.activate()
			get_viewport().set_input_as_handled()
			return
		if state == State.COMBAT and event.pressed and stick_id == -1 and safe_logical.has_point(pos) and pos.x < 700+safe_logical.position.x and pos.y > 540+safe_logical.end.y-1080:
			stick_id = event.index
			stick_origin = Vector2(clampf(pos.x,130+safe_logical.position.x,570+safe_logical.position.x),clampf(pos.y,680+safe_logical.end.y-1080,930+safe_logical.end.y-1080))
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
	if what == NOTIFICATION_APPLICATION_FOCUS_IN and is_instance_valid(ui_root):
		if OS.has_feature('android'):DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		call_deferred('update_safe_area')
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
	backdrop('DURCHATMEN','Deine Runde wartet auf dich.')
	button('FORTSETZEN',Vector2(120,320),Vector2(620,110),resume)
	button('EINSTELLUNGEN',Vector2(120,460),Vector2(620,110),func(): settings(pause_menu))
	button('HANDBUCH',Vector2(120,740),Vector2(620,110),func():game_guide.show('rules',0,pause_menu))
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
	if is_instance_valid(spell_button):spell_button.queue_redraw()
	if state != State.COMBAT: return
	if tutorial and tutorial.active and tutorial.frozen():return
	vfx.update(delta)
	specialized_combat.update(delta)
	hit_feedback.update(delta)
	hero_ability.update(delta)
	equipped_spell.update(delta)
	steelfist.update(delta)
	if state != State.COMBAT:return
	combat_visuals.update(delta)
	world_visuals.update(delta)
	run_time += delta
	remaining = maxf(0,remaining-delta)
	hurt_clock -= delta
	if absf(move_input.x)>.08: facing = -1.0 if move_input.x<0 else 1.0
	breaker.tick_player(delta)
	if not hero_ability.move_dash(delta):player.move_analog(move_input*breaker.control_factor(),speed*(.6 if united.enemies.slow_time>0 else 1.0),breaker.push_velocity)
	if state != State.COMBAT:return
	orbit_angle += delta*3.5
	spawn_clock -= delta
	if spawn_clock <= 0:
		var current_wave=rules.current_wave()
		spawn_clock+=float(current_wave.interval)
		spawn_cycle+=1
		for index in range(WaveBalance.spawn_count(current_wave,spawn_cycle)):
			if enemies.size()>=100:break
			var roll=rng.randf()
			var kind=enemy_roles.spawn_kind(current_wave,roll) if is_reactor() else ('tank' if wave_number>=3 and roll<.18 else ('runner' if wave_number>=2 and roll<.55 else 'grunt'))
			spawn_enemy(united.enemies.choose(enemy_pack.choose(ravox.select_kind(kind,roll),roll),roll))
	encounters.update(delta)
	if state!=State.COMBAT:return
	arena_hazards.update(delta)
	arena_events.update(delta)
	scrapyard_salvage.update(delta)
	if state != State.COMBAT:return
	united.update(delta)
	if state!=State.COMBAT:return
	breaker.update(delta)
	if state!=State.COMBAT:return
	bombs.update(delta)
	if state!=State.COMBAT:return
	twinkle.update(delta)
	if state!=State.COMBAT:return
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
	if level<999 and xp >= required_xp(): level_up(); return
	if remaining <= 0:
		if rules.boss_wave(): finish(false)
		else:
			run_waves+=1
			cleanup()
			open_shop()
	refresh_hud()

func spawn_enemy(kind: String):
	if kind=='breaker_axel' and (not breaker.scheduled() or not breaker.actor().is_empty()):return false
	if united.enemies.data.has(kind) and not united.enemies.allowed(kind):return false
	if kind=='champion' and (not united.bosses.scheduled() or not united.bosses.actor().is_empty()):return false
	if kind=='ravox' and not ravox.allowed():return false
	if enemy_pack.CONFIG.has(kind) and enemy_pack.count(kind)>=enemy_pack.CONFIG[kind].cap:return false
	if enemy_roles.data.has(kind) and enemy_roles.count(kind)>=int(enemy_roles.data[kind].cap):return false
	var d = enemy_definition(kind)
	var angle = rng.randf()*TAU
	var pos = (player.position+Vector2.from_angle(angle)*rng.randf_range(650,850)).clamp(Vector2(70,70),Vector2(2330,1530))
	if pos.distance_to(player.position)<450:
		pos = Vector2(2300 if player.position.x<1200 else 100,1500 if player.position.y<800 else 100)
	var current_wave=rules.current_wave()
	var is_boss=kind in ['boss','breaker_axel','champion']
	var values=rules.scale_stats(WaveBalance.stats(d,current_wave,wave_number,is_boss),is_boss)
	enemies.append({'kind':kind,'pos':pos,'hp':values.hp,'max_hp':values.hp,'speed':values.speed,'damage':values.damage,'radius':float(d.radius),'hit':0.0,'orbit_cd':0.0,'coin_reward':WaveBalance.reward(int(d.coins),current_wave,is_boss),'xp_reward':WaveBalance.reward(int(d.xp),current_wave,is_boss)})
	enemy_roles.initialize(enemies.back())
	ravox.initialize(enemies.back())
	enemy_pack.initialize(enemies.back())
	united.enemies.initialize(enemies.back())
	if united.enabled and is_boss:
		var profile=united.bosses.profile();enemies.back().boss_art=profile.boss_art;enemies.back().boss_name=profile.name;enemies.back().boss_pattern=profile.pattern
	enemies.back().coin_reward=Difficulty.reward(self,int(enemies.back().coin_reward))
	enemies.back().xp_reward=Difficulty.reward(self,int(enemies.back().xp_reward))
	encounters.promote(enemies.back())
	if enemies.back().has('elite'):
		enemies.back().coin_reward=Difficulty.reward(self,int(enemies.back().coin_reward))
		enemies.back().xp_reward=Difficulty.reward(self,int(enemies.back().xp_reward))
	return true

func update_enemies(dt: float):
	if not united.enabled and rules.final_boss_wave() and is_reactor() and not encounters.boss_lock and not steelfist.boss_stunned():reactor_guardian.update(dt)
	if not united.enabled and rules.final_boss_wave() and not is_reactor() and not encounters.boss_lock and not steelfist.boss_stunned():
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
		if steelfist.stunned(e,dt):continue
		if twinkle.stunned(e,dt):continue
		var dir: Vector2 = rules.direction(e)
		var velocity: Vector2 = dir*e.speed
		if united.enemies.data.has(e.kind):velocity=united.enemies.velocity(e,velocity,dt)
		if united.enabled and e.kind in ['boss','champion']:velocity=united.bosses.velocity(e,velocity,dt)
		if e.kind=='ravox':velocity=ravox.velocity(e,velocity,dt)
		if e.kind=='breaker_axel':velocity=breaker.velocity(e,velocity,dt)
		if enemy_pack.CONFIG.has(e.kind):velocity=enemy_pack.velocity(e,velocity,dt)
		if e.kind in ['spitter','drone']:velocity=enemy_roles.velocity(e,velocity,dt)
		if e.has('elite'):velocity=encounters.movement(e,velocity,dt)
		if state!=State.COMBAT:return
		if e.kind=='boss' and encounters.boss_lock:velocity=Vector2.ZERO
		if e.kind=='spitter' and e.get('windup',0)>0:velocity=Vector2.ZERO
		if e.kind == 'boss' and not united.enabled and is_reactor():
			if reactor_guardian.stationary():velocity=Vector2.ZERO
		elif e.kind == 'boss' and not united.enabled:
			if boss_phase%2 == 1: velocity *= .15
			if boss_charging and boss_phase == 0 and boss_clock>2.1: velocity = (boss_target-e.pos).normalized()*520
		if float(e.get('ability_slow_time',0))>0:
			velocity*=float(e.get('ability_slow',1.0))
			e.ability_slow_time=maxf(0,e.ability_slow_time-dt)
		# Staggered limited local separation avoids quadratic full neighbor scans.
		for j in range(i+1,mini(i+7,enemies.size())):
			if enemy_pack.CONFIG.has(e.kind) and e.pack_stage in ['windup','release']:break
			if united.enabled and e.kind in ['boss','champion'] and united.bosses.stage in ['windup','dash','phase']:break
			if e.get('u_stage','') in ['windup','dash']:break
			if e.kind=='breaker_axel' and breaker.stage in ['windup','dash','hammer','phase']:break
			if e.kind=='ravox' and e.ravox_stage in ['windup','dash','recovery']:break
			if e.has('elite') and e.elite_stage in ['windup','dash']:break
			if e.kind=='boss' and encounters.boss_lock:break
			if e.kind=='spitter' and e.get('windup',0)>0:break
			if e.kind=='boss' and is_reactor() and reactor_guardian.stationary():break
			var other = enemies[j]
			var offset: Vector2 = e.pos-other.pos
			var distance = offset.length()
			if distance<e.radius+other.radius and distance>.1:
				velocity += offset/distance*45
		var previous_pos:Vector2=e.pos
		e.pos = (e.pos+velocity*dt).clamp(Vector2(35,35),Vector2(2365,1565))
		if united.enabled and e.kind in ['boss','champion']:united.bosses.after_move(e,previous_pos,e.pos)
		if united.enemies.data.has(e.kind):united.enemies.after_move(e,previous_pos,e.pos)
		if e.kind=='ravox':ravox.after_move(e,previous_pos,e.pos)
		if e.kind=='breaker_axel':breaker.after_move(e,previous_pos,e.pos)
		if state!=State.COMBAT:return
		if e.has('elite'):encounters.after_move(e,previous_pos,e.pos)
		if state!=State.COMBAT:return
		if not (e.kind=='ravox' and e.ravox_stage=='dash') and not (e.kind=='breaker_axel' and breaker.stage=='dash') and e.get('u_stage','')!='dash' and not (united.enabled and e.kind in ['boss','champion'] and united.bosses.stage=='dash') and e.pos.distance_to(player.position)<e.radius+27 and hurt_clock<=0:
			if e.kind=='breaker_axel':breaker.hit(breaker.damage(breaker.data.damage,e),e.pos,180,.12)
			elif united.enabled and e.kind in ['boss','champion']:breaker.hit(united.bosses.touch_damage(e),e.pos,180,.12)
			else:
				var before_hp=hp;hurt(e.damage)
				if state==State.COMBAT:united.enemies.contact(e,before_hp)
		if state != State.COMBAT: return
	for actor in enemies.duplicate():
		enemy_pack.resolve(actor)
		if state!=State.COMBAT:return

func hurt(amount: float):
	if tutorial and tutorial.active:return
	if state != State.COMBAT or hurt_clock>0 or hero_ability.invulnerable() or equipped_spell.invulnerability>0 or united.heroes.invulnerability>0: return
	var received=maxf(1,amount-armor)*steelfist.damage_factor()
	received=united.heroes.absorb(received)
	hp -= received
	hurt_clock = .65
	if received<=0:sound('united_impact');return
	sound('hit')
	hit_feedback.damage(player.position,received,false,true)
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
	weapon_manager.update(dt*united.heroes.rate())

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
		elif s.get('united',false):
			united.heroes.projectile(s,old,dt)
			if state!=State.COMBAT:return
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
	var amount = power*(2 if critical else 1)*enemy_roles.damage_factor(e)*united.enemies.factor(e)*(1.0-float(breaker.data.resistance) if e.kind=='breaker_axel' else 1.0)
	dealt += minf(e.hp,amount)
	e.hp -= amount
	e.hit = .15
	vfx.enemy_hit(e,critical)
	hit_feedback.damage(e.pos,amount,critical)
	if e.hp<=0:
		var kind: String = e.kind
		var pos: Vector2 = e.pos
		vfx.enemy_died(e)
		world_visuals.enemy_defeated(e)
		enemy_roles.removed(e)
		united.enemies.removed(e)
		encounters.removed(e)
		enemies.erase(e)
		kills += 1
		twinkle.on_kill()
		steelfist.on_kill()
		var reward = int(e.get('coin_reward',enemy_definition(kind).coins))
		coins += reward
		vfx.coin(pos,reward)
		earned += reward
		if kind in ['breaker_axel','champion']:xp+=int(e.xp_reward)
		else:loot.append({'pos':pos,'xp':int(e.get('xp_reward',enemy_definition(kind).xp))})
		sound('death')
		sound('coin')
		if kind in ['breaker_axel','champion']:
			sound('axel_defeat');run_waves+=1;cleanup();axel_shop_pending=true
			if level<999 and xp>=required_xp():level_up()
			else:axel_shop_pending=false;open_shop()
			var death_fx=Control.new();death_fx.set_script(preload('res://scripts/ui/axel_defeat_fx.gd'));death_fx.art_index=int(e.get('boss_art',0));death_fx.title=str(e.get('boss_name','AXEL'))+' BESIEGT!';ui_root.add_child(death_fx)
		elif kind == 'boss':
			run_waves+=1
			if run_mode=='endless':cleanup();open_shop()
			else:finish(true)

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
	return roundi(minf(1000000000,20*pow(1.18,mini(100,level-1))))

func has_projectile_weapon() -> bool:
	for w in weapons:
		if w.id in ['blaster','splitgun','bomb','cryo','chakram']: return true
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
				if w.id in ['blaster','splitgun','bomb','cryo','chakram']: suitable=true
			return suitable and multishot<4
		'armor': return armor<20
		'speed': return count<8
		'magnet': return count<6
		'rapid': return count<10
	return true

func level_up():
	if level>=999:return
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
		UISkin.panel(self,Rect2(x,270,530,545),Color('#9861C1'))
		UISkin.image(self,UISkin.Icons.get_icon(u[0]),Rect2(x+25,300,130,130))
		label_at(u[2],Vector2(x+20,450),33,GOLD)
		label_at(u[3],Vector2(x+20,520),25)
		button('WÄHLEN',Vector2(x+25,685),Vector2(480,105),func(): apply_upgrade(u[0]); if_more_levels())

func if_more_levels():
	if level<999 and xp>=required_xp(): level_up()
	elif axel_shop_pending:axel_shop_pending=false;open_shop()
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
	return characters[selected].allowed_weapons.filter(func(id):return saved.collection.levels.has(id) or run_mode=='tutorial')

func gear_weapon_multiplier(id:String) -> float:return 1.0+float(run_gear.get('weapon_bonus',{}).get(id,0))

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
	for id in run_items.data:
		if run_items.valid(id):
			var item=run_items.data[id]
			pool.append({'type':'item','id':id,'name':item.name,'description':item.description,'price':int(item.price)+wave_number*4,'rarity':item.rarity})
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
	atlas.atlas = preload('res://scripts/ui/combat_art.gd').weapon_texture(id)
	atlas.region = preload('res://scripts/ui/combat_art.gd').weapon(id)
	icon.texture = atlas
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.position = pos
	icon.size = size
	icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_root.add_child(icon)

func show_shop():
	if not encounters.rewards.is_empty():encounters.reward_screen();return
	if not pending_specialization().is_empty():specialization_screen();return
	shop_view.show()

func weapon_summary() -> String:
	var text = ''
	for w in weapons: text += '%s Lv.%d  ' % [Specs.label(w) if not Specs.label(w).is_empty() else weapon_data[w.id].name,w.level]
	return text

func buy_offer(index: int) -> bool:
	if not encounters.rewards.is_empty():return false
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
	elif o.type=='item':
		if not run_items.add(o.id):return false
	else:
		if not valid_upgrade(o.id): return false
		apply_upgrade(o.id)
	run_items.sync()
	coins -= int(o.price)
	o.sold = true
	sound('buy')
	show_shop()
	return true

func reroll_shop() -> bool:
	if not encounters.rewards.is_empty():return false
	if state!=State.SHOP: return false
	var cost = 0 if rerolls==0 else 5+rerolls*3
	if coins<cost: return false
	coins-=cost
	rerolls+=1
	generate_offers()
	show_shop()
	return true

func finish(victory: bool):
	if tutorial and tutorial.active:tutorial.stop(false);return
	if result_recorded: return
	result_recorded = true
	studio_reward=Collection.run_reward(saved,run_mode,run_waves,kills,victory)
	preload('res://scripts/progression/daily_rewards.gd').record(saved.meta,{'mode':run_mode,'arena':arena_id,'kills':kills,'waves':run_waves,'skills':run_abilities,'won':victory})
	change_state(State.VICTORY if victory else State.GAME_OVER)
	if run_mode=='campaign':
		saved.games+=1
		saved.wins+=int(victory)
		saved.kills+=kills
		saved.time+=run_time
		saved.highest_wave=maxi(int(saved.highest_wave),mini(10,wave_number))
	var difficulty_best=DifficultyRecords.add(saved,run_difficulty,run_mode,arena_id,wave_number,kills,run_time,victory)
	var previous_rewards=Mastery.rewards(saved,characters[selected].id)
	var improvements=RunRecords.add_run(saved,{'difficulty':run_difficulty,'arena':arena_id,'character':characters[selected].id,'won':victory,'wave':wave_number,'time':run_time,'kills':kills,'level':level,'damage':dealt,'coins':earned,'weapons':weapons,'items':run_items.owned,'elite_kills':encounters.elite_kills}) if run_mode=='campaign' else []
	if run_mode=='endless':preload('res://scripts/progression/endless_records.gd').add(saved,arena_id,wave_number,kills,run_time)
	var world_first_clear=WorldProgress.complete(saved,arena_id,run_mode,victory,wave_number)
	var unlocked=Arenas.sync(saved)
	if Unlocks.sync(saved):unlocked.append('KICKSY')
	for reward in Mastery.rewards(saved,characters[selected].id):
		if not previous_rewards.has(reward):unlocked.append(reward)
	world_map.persist()
	result_details={'victory':victory,'improvements':improvements,'difficulty_best':difficulty_best,'world_first_clear':world_first_clear,'unlocked':unlocked}
	cleanup()
	encounters.end_run()
	sound('victory' if victory else 'defeat')
	show_result()

func show_result():
	if result_details.is_empty() or state not in [State.VICTORY,State.GAME_OVER]:return
	var victory:bool=result_details.victory
	var improvements:Array=result_details.improvements
	var difficulty_best:bool=result_details.difficulty_best
	var world_first_clear:bool=result_details.world_first_clear
	var unlocked:Array=result_details.unlocked
	backdrop('ENDLOS BEENDET' if run_mode=='endless' else ('MAYHEM GEMEISTERT!' if victory else 'DAS WAR EIN MAYHEM!'),arena_definition.name+' / '+Difficulty.definition(run_difficulty).name+' • '+('SIEG' if victory else 'GAME OVER'))
	if victory:
		var celebration=Control.new()
		celebration.set_script(preload('res://scripts/ui/victory_fx.gd'))
		celebration.count=12 if saved.settings.quality=='LOW' else (24 if saved.settings.quality=='MEDIUM' else 40)
		celebration.mouse_filter=Control.MOUSE_FILTER_IGNORE
		ui_root.add_child(celebration)
	portrait(Vector2(1380,300),selected,1.05,'victory' if victory else 'defeat')
	var summary=label_at('Welle %d / 10     Zeit %02d:%02d\nKills %d (Eliten %d)     Level %d\nSchaden %d     Run-Coins %d\n\n%s' % [wave_number,int(run_time)/60,int(run_time)%60,kills,encounters.elite_kills,level,dealt,earned,weapon_summary()],Vector2(110,300),33)
	if run_mode=='endless':summary.text=summary.text.replace(' / 10',' / ENDLOS')
	summary.text=UISkin.wrap_text(summary.text,UISkin.BODY,33,1120)
	if not run_items.owned.is_empty():
		var items_label=label_at('GEGENSTÄNDE: '+', '.join(run_items.owned.map(func(id):return run_items.data[id].name)),Vector2(110,565),20,TEAL)
		items_label.text=UISkin.wrap_text(items_label.text,UISkin.BODY,20,1120)
	if not improvements.is_empty() or difficulty_best: label_at('NEUER PERSÖNLICHER BESTWERT',Vector2(110,640),26,GOLD)
	var world_message=''
	if world_first_clear:
		var next_world=WorldProgress.next_world(arena_id)
		world_message=('NEUE WELT: '+Arenas.definition(next_world).name if next_world!='' else 'ALLE ZEHN WELTEN GEMEISTERT!')+' / ERSTABSCHLUSS-BELOHNUNG AUF DER WELTKARTE'
	if not unlocked.is_empty():world_message+=(' / ' if world_message!='' else '')+'FREIGESCHALTET: '+', '.join(unlocked)
	if world_map.error!='':world_message='FORTSCHRITT NOCH NICHT GESPEICHERT / AUF DER WELTKARTE ERNEUT VERSUCHEN'
	if world_message!='':
		var message=label_at(UISkin.wrap_text(world_message,UISkin.BODY,20,1110),Vector2(110,680),20,TEAL if world_map.error=='' else Color('#FF6D7B'))
		message.set_deferred('size',Vector2(1120,60))
	button('NOCHMAL SPIELEN',Vector2(110,740),Vector2(540,110),start_run)
	button('CHARAKTERE',Vector2(690,740),Vector2(500,110),func():character_select(selected))
	button('HAUPTMENÜ',Vector2(1230,740),Vector2(500,110),main_menu)
	button('+%d STUDIO-COINS / DETAILS' % studio_reward,Vector2(110,900),Vector2(540,95),func():queue_ui_action(reward_details))
	button('WELTKARTE / BELOHNUNG',Vector2(690,900),Vector2(500,95),func():world_map.persist();arena_select(Arenas.IDS.find(arena_id)))
	button('CASES & GARAGE',Vector2(1230,900),Vector2(500,95),func():main_menu();garage.cases())

func reward_details():
	if result_details.is_empty() or state not in [State.VICTORY,State.GAME_OVER]:return
	backdrop('DEIN FORTSCHRITT','Run-Coins und Studio-Coins haben getrennte Zwecke. Alle Belohnungen sind erspielbar.')
	var parts=Collection.reward_breakdown(run_mode,run_waves,kills,result_details.victory)
	var rows=[['STUDIO-COINS','+%d DAUERHAFT' % studio_reward,'%d überlebte Wellen: +%d\n%d Kills: +%d\nKampagnensieg: +%d\n\nBereits deinem Profil gutgeschrieben. Für Cases und den kosmetischen Shop.' % [run_waves,parts.waves,kills,parts.kills,parts.victory]],['RUN-COINS','%d IM RUN VERDIENT' % earned,'Davon Bergung: %d\nBergungen geschafft: %d\n\nFür Käufe im Wellenshop. Ein neuer Durchlauf startet bei null Run-Coins.' % [scrapyard_salvage.total_coins,scrapyard_salvage.completed]],['WELTABSCHLUSS','BELOHNUNG BEREIT' if WorldProgress.eligible(saved,arena_id) else ('BEREITS ABGEHOLT' if saved.world_progress.claimed.has(arena_id) else 'DEIN NÄCHSTES ZIEL'),WorldProgress.reward_text(arena_id)+'\n\n'+('Auf der Weltkarte einmalig abholen. Die nächste Welt ist bereits offen.' if WorldProgress.eligible(saved,arena_id) else ('Diese Erstbelohnung gehört bereits deinem Profil. Wähle auf der Weltkarte dein nächstes Ziel.' if saved.world_progress.claimed.has(arena_id) else 'Besiege den Arenaboss in Welle 10. Erstabschlüsse bringen zusätzliche dauerhafte Beute.'))]]
	for i in range(3):
		var x=100+i*585
		UISkin.panel(self,Rect2(x,270,550,610),TEAL if i<2 else GOLD)
		UISkin.image(self,UISkin.Icons.get_icon(['coins','coins','world'][i]),Rect2(x+195,290,160,145))
		label_at(rows[i][0],Vector2(x+30,460),39,GOLD)
		label_at(rows[i][1],Vector2(x+30,520),26,TEAL)
		var detail=label_at(rows[i][2],Vector2(x+30,580),26)
		detail.text=UISkin.wrap_text(detail.text,UISkin.BODY,26,485)
	button('ZUM ERGEBNIS',Vector2(100,945),Vector2(540,100),func():queue_ui_action(show_result))
	button('WELTKARTE / BELOHNUNG',Vector2(680,945),Vector2(550,100),func():queue_ui_action(func():world_map.persist();arena_select(Arenas.IDS.find(arena_id))))
	button('AUFTRÄGE & PASS',Vector2(1270,945),Vector2(550,100),func():queue_ui_action(func():main_menu();reward_hub.show()))

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
	var tint = Color(2,2,2,1) if hurt_clock>.4 else Mastery.tint(Mastery.selected(saved,characters[selected].id))
	var rect = Rect2(Vector2(-48,-64-absf(stride)*3),Vector2(96,96))
	draw_texture_rect_region(CharacterArt.texture(characters[selected].id,true),rect,CharacterArt.body_region(characters[selected].id),tint)
	GearArt.dress(self,characters[selected].id,run_loadout,rect)
	Mastery.insignia(self,Vector2(6,-9-absf(stride)*3),Mastery.selected(saved,characters[selected].id),6)
	draw_set_transform(Vector2.ZERO)

func _draw():
	world_visuals.draw_arena()
	if state in [State.MAIN_MENU,State.CHARACTER_SELECT,State.ARENA_SELECT,State.BOOT]:
		for i in range(8):
			var kind=['grunt','runner','tank'][i%3]
			world_visuals.draw_enemy({'kind':kind,'pos':Vector2(250+i*240,650+sin(animation_clock+i)*180),'radius':38.0,'hit':0.0},true)
		return
	enemy_pack.draw()
	ravox.draw_floor()
	breaker.draw_floor()
	united.draw()
	bombs.draw_floor()
	twinkle.draw_floor()
	steelfist.draw_floor()
	vfx.draw_floor()
	encounters.draw_floor()
	enemy_roles.draw_floor()
	arena_hazards.draw()
	scrapyard_salvage.draw()
	if is_reactor():reactor_guardian.draw()
	world_visuals.draw_telegraph()
	enemy_roles.draw_telegraphs()
	world_visuals.draw_deaths()
	vfx.draw_particles()
	hero_ability.draw()
	for l in loot:
		var p: Vector2 = l.pos
		draw_circle(p,18,Color(0,.85,.8,.12))
		draw_colored_polygon(PackedVector2Array([p+Vector2(0,-13),p+Vector2(9,0),p+Vector2(0,13),p+Vector2(-9,0)]),TEAL)
		draw_line(p+Vector2(0,-9),p+Vector2(-5,0),Color.WHITE,3)
	# Keep the player visible in crowds, as in the accepted combat version.
	for e in enemies:
		world_visuals.draw_enemy(e)
		encounters.draw_elite(e)
		ravox.draw_name(e)
	combat_visuals.draw_weapons(true)
	draw_player_character()
	reward_hub.draw_cosmetics()
	combat_visuals.draw_weapons(false)
	bombs.draw()
	combat_visuals.draw_shots()
	specialized_combat.draw()
	combat_visuals.draw_effects()
	vfx.draw_front()
	hit_feedback.draw()
	for e in effects:
		if e.has('end'): draw_line(e.pos,e.end,e.color,5,true)
		else:
			draw_arc(e.pos,e.radius*(1.5-e.life),0,TAU,20,Color(e.color,e.life*2),4,true)
			if e.text!='': draw_string(UISkin.BODY,e.pos+Vector2(-12,-35*(1-e.life)),e.text,HORIZONTAL_ALIGNMENT_LEFT,-1,24,e.color)

func _exit_tree():
	if audio_director:audio_director.stop()
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

func is_reactor() -> bool:return arena_id in ['reactor','foundry']
func enemy_definition(kind: String) -> Dictionary:
	if united and united.enabled and kind in ['boss','champion','breaker_axel']:return united.bosses.profile()
	if kind=='breaker_axel':return breaker.data
	if enemy_roles.data.has(kind):return enemy_roles.data[kind]
	return arena_definition.boss if kind=='boss' and arena_definition.has('boss') else enemy_data[kind]
func choose_arena(id: String) -> bool:
	if not Arenas.IDS.has(id) or not Arenas.unlocked(saved,id):return false
	arena_id=id
	start_run()
	return true
func arena_select(index:int=-1):
	if index>=0:arena_cursor=posmod(index,Arenas.IDS.size())
	world_map.show()

func challenges_screen():
	backdrop('ZIELE & STILE','Nur Optik: Alle Ringe behalten die gleichen Kampfwerte.')
	var rows=[['gold','CHAMPIONRING','Gewinne einen Run.',saved.wins,1],['mayhem','MAYHEMRING','Besiege insgesamt 1.000 Gegner.',saved.kills,1000],['reactor','REAKTORSIEGEL','Besiege den Reaktorwächter.',saved.arena_records.reactor.wins,1]]
	for i in range(rows.size()):
		var r=rows[i]
		var y=280+i*190
		UISkin.panel(self,Rect2(95,y-15,1690,165))
		UISkin.image(self,UISkin.Icons.get_icon('trophy' if i<2 else 'world'),Rect2(1070,y+10,100,100))
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
		var x=110+(i%2)*865
		UISkin.panel(self,Rect2(x-10,245,825,695),Color(d.color))
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
	if not encounters.rewards.is_empty():encounters.reward_screen();return
	if state!=State.SHOP:return
	if not pending_specialization().is_empty():specialization_screen();return
	wave_number+=1
	prepare_wave()

func mastery_screen(index:int, preview:String=''):
	var hero=characters[index].id
	var current=Mastery.selected(saved,hero)
	var shown=current if preview=='' else preview
	backdrop('CHARAKTER-MEISTERSCHAFT','Dauerhafte Ziele / kosmetische Belohnungen / keine Werteboni')
	for i in range((index/6)*6,mini((index/6)*6+6,characters.size())):
		var tab_width=1720.0/6
		button(characters[i].name,Vector2(100+(i%6)*tab_width,230),Vector2(tab_width-18,75),func():mastery_screen(i),Color('#147F81') if i==index else Color('#243958'))
	button('WEITERE HELDEN',Vector2(110,320),Vector2(480,65),func():mastery_screen(6 if index<6 else 0))
	portrait(Vector2(130,390),index,1.1)
	# Preview can show a locked colour, but never equips it.
	var art=ui_root.get_child(ui_root.get_child_count()-1)
	art.outfit=shown
	label_at(Mastery.NAMES[shown]+(' / VORSCHAU' if shown!=current else ' / AKTIV'),Vector2(130,820),24,Mastery.accent(shown))
	var complete=Mastery.completed(saved,hero)
	label_at(Mastery.TITLES[hero] if complete==3 else 'MEISTERSCHAFT %d / 3' % complete,Vector2(130,875),28,GOLD)
	if Mastery.goals(saved,hero)[1].value>=250:label_at('JÄGERABZEICHEN / 250 KILLS',Vector2(130,925),19,TEAL)
	for i in range(3):
		var goal=Mastery.goals(saved,hero)[i]
		var y=345+i*145
		label_at(('✓ ' if goal.value>=goal.target else '')+goal.name,Vector2(720,y),27,GOLD if goal.value>=goal.target else TEAL)
		label_at('%s  /  %d von %d' % [goal.description,goal.value,goal.target],Vector2(720,y+40),23)
		var bar=ProgressBar.new()
		bar.position=Vector2(720,y+79);bar.size=Vector2(990,13);bar.max_value=goal.target;bar.value=goal.value;bar.show_percentage=false;bar.mouse_filter=Control.MOUSE_FILTER_IGNORE
		bar.add_theme_stylebox_override('background',UISkin.box(Color('#141326'),Color('#4B395F')))
		var fill=StyleBoxFlat.new();fill.bg_color=GOLD if goal.value>=goal.target else TEAL;fill.set_corner_radius_all(6)
		bar.add_theme_stylebox_override('fill',fill)
		ui_root.add_child(bar)
		label_at('BELOHNUNG: '+goal.reward,Vector2(720,y+97),18,TEAL)
	for i in range(3):
		var outfit=Mastery.STYLES[i]
		var available=Mastery.unlocked(saved,hero,outfit)
		button(Mastery.NAMES[outfit]+(' ✓' if current==outfit else (' / GESPERRT' if not available else '')),Vector2(720+i*350,815),Vector2(330,85),func():mastery_screen(index,outfit),Color('#147F81') if shown==outfit else Color('#243958'))
	button('ZURÜCK',Vector2(100,965),Vector2(400,85),func():character_select(index))
	var equip=button('AKTIV' if current==shown else ('AUSRÜSTEN' if Mastery.unlocked(saved,hero,shown) else 'NOCH GESPERRT'),Vector2(1180,965),Vector2(590,85),func():
		if Mastery.equip(saved,hero,shown):save_game();sound('buy');mastery_screen(index))
	equip.disabled=current==shown or not Mastery.unlocked(saved,hero,shown)

func endless_statistics(page:int=0):
	backdrop('ENDLOS-REKORDE','Endlos-Wertung separat / Meisterschaften zählen Kampagnen-Runs')
	for i in range(page*4,mini(page*4+4,Arenas.IDS.size())):
		var id=Arenas.IDS[i];var r=saved.endless_records[id];var x=110+(i%2)*870;var y=280+((i%4)/2)*290
		UISkin.panel(self,Rect2(x,y,810,255))
		label_at(Arenas.definition(id).name,Vector2(x+25,y+20),37,TEAL)
		label_at('Höchste Welle: %d\nRuns: %d / Kills: %d\nSpielzeit: %s' % [r.highest_wave,r.runs,r.kills,duration_text(r.time)],Vector2(x+25,y+85),29)
	button('ZURÜCK',Vector2(110,960),Vector2(600,90),statistics)
	button('VORHERIGE',Vector2(800,960),Vector2(430,90),func():endless_statistics(posmod(page-1,3)))
	button('NÄCHSTE',Vector2(1300,960),Vector2(480,90),func():endless_statistics(posmod(page+1,3)))

func motion_settings():
	backdrop('MENÜBEWEGUNG','Neigung bewegt nur Hintergrundbilder / Bedienelemente bleiben an ihrer Position')
	button('NEIGUNG: '+('AN' if saved.settings.tilt else 'AUS'),Vector2(160,320),Vector2(1500,110),func():saved.settings.tilt=not saved.settings.tilt;menu_motion.reset();save_game();motion_settings())
	button('RUHIGE MENÜS: '+('AN' if saved.settings.reduced_motion else 'AUS'),Vector2(160,470),Vector2(1500,110),func():saved.settings.reduced_motion=not saved.settings.reduced_motion;save_game();motion_settings())
	button('NEIGUNG NEU ZENTRIEREN',Vector2(160,620),Vector2(1500,110),func():menu_motion.reset();sound('click'))
	label_at('Halte das Handy bequem. Die aktuelle Haltung wird als Mitte übernommen.\nOhne Bewegungssensor bleibt die Darstellung stabil. Keine Sensorberechtigung nötig.',Vector2(160,790),29)
	button('ZURÜCK',Vector2(160,960),Vector2(650,90),func():settings(main_menu if state!=State.PAUSED else pause_menu))

func difficulty_select(page:int=0):
	backdrop('DEINE SCHWIERIGKEIT','Gleiche Warnzeiten / gleiche Gegnergrenze / eigene Rekorde je Stufe')
	for i in range(Difficulty.IDS.size()):
		var id=Difficulty.IDS[i];var d=Difficulty.definition(id);var x=100+i*585
		UISkin.panel(self,Rect2(x,260,550,650),Color(d.color))
		UISkin.image(self,load('res://assets/ui/difficulty/'+id+'.svg'),Rect2(x+185,285,180,140))
		label_at(d.name,Vector2(x+25,445),46,Color(d.color))
		var detail=label_at(d.description,Vector2(x+25,515),25);detail.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;detail.set_deferred('size',Vector2(490,110))
		label_at('Gegner-HP: +%d %% / Tempo: +%d %%\nKontaktschaden: +%d %%\nBoss-HP: +%d %% / Beute: +%d %%\nSpawnintervall: %d %%' % [roundi((d.hp-1)*100),roundi((d.speed-1)*100),roundi((d.damage-1)*100),roundi((d.boss_hp-1)*100),roundi((d.reward-1)*100),roundi((d.interval-1)*100)],Vector2(x+25,640),24)
		button('AKTIV' if selected_difficulty==id else 'AUSWÄHLEN',Vector2(x+25,795),Vector2(500,95),func():selected_difficulty=id;arena_select(page),Color(d.color).darkened(.65))
	button('ZURÜCK',Vector2(100,965),Vector2(550,85),func():arena_select(page))
func difficulty_statistics(id:String='normal',mode:String='campaign',page:int=0):
	backdrop('STUFEN-REKORDE',Difficulty.definition(id).name+' / '+('KAMPAGNE' if mode=='campaign' else 'ENDLOS'))
	for i in range(3):
		var key=Difficulty.IDS[i]
		button(Difficulty.definition(key).name,Vector2(100+i*440,240),Vector2(420,80),func():difficulty_statistics(key,mode),Color('#147F81') if key==id else Color('#243958'))
	button('MODUS WECHSELN',Vector2(1430,240),Vector2(390,80),func():difficulty_statistics(id,'endless' if mode=='campaign' else 'campaign'))
	for i in range(page*4,mini(page*4+4,Arenas.IDS.size())):
		var arena=Arenas.IDS[i];var r=saved.difficulty_records[id][mode][arena];var x=100+(i%2)*870;var y=355+((i%4)/2)*270
		UISkin.panel(self,Rect2(x,y,820,240))
		label_at(Arenas.definition(arena).name,Vector2(x+20,y+15),35,TEAL)
		var info='Runs: %d / Siege: %d / Welle: %d\nKills: %d / Zeit: %s\nSchnellster Sieg: %s' % [r.runs,r.wins,r.highest_wave,r.kills,duration_text(r.time),duration_text(r.fastest_victory) if r.fastest_victory>0 else '—']
		if mode=='endless':info='Runs: %d / Höchste Welle: %d\nKills: %d / Zeit: %s' % [r.runs,r.highest_wave,r.kills,duration_text(r.time)]
		label_at(info,Vector2(x+20,y+75),26)
	button('VORHERIGE',Vector2(850,965),Vector2(420,85),func():difficulty_statistics(id,mode,posmod(page-1,3)))
	button('NÄCHSTE',Vector2(1320,965),Vector2(480,85),func():difficulty_statistics(id,mode,posmod(page+1,3)))
	button('ZURÜCK',Vector2(100,965),Vector2(550,85),statistics)

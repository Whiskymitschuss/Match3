extends Node
# Training uses real combat/UI systems but never adds runs, coins or victories to records.
var game:Node2D
var active=false
var step=0
var done=false
var layer:CanvasLayer
var root:Control
var start_pos=Vector2.ZERO
var start_value=0
var paused_once=false
var previous={}
var TITLES:Array=[]
var TEXTS:Array=[]
func _init(g:Node2D):
	game=g
	for entry in game.read_data('tutorial/kicksy').steps:TITLES.append(entry.title);TEXTS.append(entry.text)
func frozen() -> bool:return active and (step in [0,11,12] or done)
func start():
	if active:return
	previous={'selected':game.selected,'arena':game.arena_id,'mode':game.run_mode}
	game.character_select();game.selected=1;game.arena_id='scrapyard';game.run_mode='tutorial';active=true;game.start_run();game.begin_wave()
	step=0;done=true
	layer=CanvasLayer.new();layer.layer=20;add_child(layer)
	root=Control.new();root.mouse_filter=Control.MOUSE_FILTER_IGNORE;layer.add_child(root)
	enter_step()
func stop(completed:bool):
	if not active:return
	active=false
	if is_instance_valid(layer):layer.queue_free()
	game.cleanup();game.selected=previous.selected;game.arena_id=previous.arena;game.run_mode=previous.mode
	if completed:
		game.saved.settings.tutorial_complete=true
		game.Unlocks.sync(game.saved)
		game.save_game()
	game.main_menu()
func next():
	if not active or not done:return
	if step==12:stop(true);return
	step+=1;enter_step()
func dummy(offset:Vector2,hp:float):
	game.spawn_enemy('grunt');var e=game.enemies.back();e.pos=game.player.position+offset;e.hp=hp;e.max_hp=hp;e.speed=0;e.damage=0
func enter_step():
	done=step in [0,11,12];start_pos=game.player.position
	game.remaining=99999;game.spawn_clock=99999
	match step:
		2:dummy(Vector2(160,0),12);start_value=game.kills
		3:
			start_value=game.xp
			if game.loot.is_empty():game.loot.append({'pos':game.player.position+Vector2(110,0),'xp':5})
		4:game.xp=game.required_xp();game.level_up()
		5:game.enemies.clear();dummy(Vector2(220,0),1000);game.hero_ability.cooldown=0;start_value=game.hero_ability.activations
		6:
			game.cleanup();game.wave_number=5;game.spawn_enemy('ravox');var e=game.enemies.back();e.pos=game.player.position+Vector2(260,0);e.ravox_clock=0;e.hp=1000000;e.max_hp=1000000
		7:
			game.cleanup();game.open_shop();game.coins=300;game.hp=game.max_hp-20
			game.offers=[{'type':'weapon','id':'blaster','name':'BLASTER','description':'Waffenstufe verbessern','price':25,'rarity':'STANDARD'},{'type':'upgrade','id':'damage','name':'HEAVY IMPACT','description':'+12 % Schaden','price':20,'rarity':'STANDARD'},{'type':'upgrade','id':'heal','name':'FIELD MEDIC','description':'Heilt 25 HP','price':15,'rarity':'STANDARD'},{'type':'upgrade','id':'rapid','name':'RAPID FIRE','description':'+10 % Angriffstempo','price':20,'rarity':'STANDARD'}];game.show_shop()
		8:start_value=game.rerolls
		9:start_value=game.weapon_level('blaster')
		10:paused_once=false
	redraw_card()
func _process(_dt):
	if not active:return
	root.position=game.ui_root.position;root.scale=game.ui_root.scale;root.size=Vector2(1920,1080)
	root.visible=game.state!=game.State.PAUSED or step==10
	if done:return
	var passed=false
	match step:
		1:passed=game.player.position.distance_to(start_pos)>120
		2:passed=game.kills>start_value
		3:passed=game.xp>start_value
		4:passed=game.state==game.State.COMBAT
		5:passed=game.hero_ability.activations>start_value
		6:
			for e in game.enemies:
				if e.kind!='ravox':continue
				if e.ravox_stage=='recovery':
					if not e.ravox_hit:passed=true
					else:e.pos=(game.player.position+Vector2(260,0)).clamp(Vector2(90,90),Vector2(2310,1510));e.ravox_stage='chase';e.ravox_clock=0;e.hp=1000000;e.max_hp=1000000
		7:
			for offer in game.offers:
				if offer.get('sold',false):passed=true
		8:passed=game.rerolls>start_value
		9:passed=game.weapon_level('blaster')>start_value
		10:
			if game.state==game.State.PAUSED:paused_once=true
			if game.state==game.State.COMBAT:game.remaining=99999;game.spawn_clock=99999
			passed=paused_once and game.state==game.State.COMBAT
	if passed:done=true;redraw_card()
func text(value:String,at:Vector2,width:float,font_size:int) -> Label:
	var label=Label.new();label.text=value;label.position=at;label.size=Vector2(width,100);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_override('font',game.UISkin.BODY);label.add_theme_font_size_override('font_size',font_size);label.mouse_filter=Control.MOUSE_FILTER_IGNORE;root.add_child(label);label.set_deferred('size',Vector2(width,100));return label
func control_button(value:String,at:Vector2,size:Vector2,action:Callable) -> Button:
	var b=Button.new();b.text=value;b.position=at;b.size=size;b.custom_minimum_size=size;b.add_theme_font_override('font',game.UISkin.HEADING);b.add_theme_font_size_override('font_size',25);b.add_theme_stylebox_override('normal',game.UISkin.box(Color('#38204F'),Color('#E879F9')));b.pressed.connect(action);root.add_child(b);return b
func redraw_card():
	for child in root.get_children():root.remove_child(child);child.queue_free()
	var full=step in [0,11,12]
	var shop=step in [7,8,9]
	var origin=Vector2(520,300) if full else (Vector2(510,0) if shop else Vector2(500,765))
	var size=Vector2(1240,440) if full else Vector2(920,255 if shop else 285)
	var panel=Panel.new();panel.position=origin;panel.size=size;panel.mouse_filter=Control.MOUSE_FILTER_STOP;panel.add_theme_stylebox_override('panel',game.UISkin.box(Color('#211631'),Color('#E879F9')));root.add_child(panel)
	var avatar=TextureRect.new();avatar.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;var face=AtlasTexture.new();face.atlas=game.CharacterArt.texture('kicksy');face.region=game.CharacterArt.region('kicksy');avatar.texture=face;avatar.position=origin+Vector2(18,20);avatar.size=Vector2(230,320) if full else Vector2(145,185);avatar.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED;avatar.mouse_filter=Control.MOUSE_FILTER_IGNORE;root.add_child(avatar)
	if not game.saved.settings.get('reduced_motion',false):
		avatar.pivot_offset=avatar.size*.5;avatar.scale=Vector2.ONE*.65;avatar.create_tween().tween_property(avatar,'scale',Vector2.ONE,.28).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	var offset=285 if full else 185
	text('KICKSY / %d VON %d' % [step+1,TITLES.size()],origin+Vector2(offset,14),size.x-offset-20,18).modulate=Color('#E879F9')
	text(TITLES[step],origin+Vector2(offset,42),size.x-offset-20,27).modulate=Color('#FFD166')
	text(TEXTS[step],origin+Vector2(offset,82),size.x-offset-25,27 if full else 22)
	var y=origin.y+size.y-85
	control_button('BEENDEN',Vector2(origin.x+18,y),Vector2(155,70),func():stop(false))
	var advance=control_button('ABSCHLIESSEN' if step==12 else ('WEITER' if done else 'JETZT ÜBEN'),Vector2(origin.x+size.x-230,y),Vector2(210,70),next);advance.disabled=not done

func blocks_touch(pos:Vector2) -> bool:
	if not active or not is_instance_valid(root) or not root.visible:return false
	for child in root.get_children():
		if child is Panel and Rect2(child.position,child.size).has_point(pos):return true
	return false

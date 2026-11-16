extends RefCounted
const HEADING=preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf')
const BODY=preload('res://assets/ui/fonts/Barlow-SemiBold.ttf')
const LOGO=preload('res://assets/branding/mayhem_wordmark.png')
const STUDIO=preload('res://assets/branding/rf_worlds.svg')
const ICON=preload('res://assets/branding/app_icon.png')
static func box(color:Color,accent:Color=Color('#667080')) -> StyleBoxFlat:
	var s=StyleBoxFlat.new();s.bg_color=color
	s.border_color=accent;s.border_width_left=3;s.border_width_right=2;s.border_width_top=2;s.border_width_bottom=4
	s.set_corner_radius_all(12);s.shadow_color=Color(0,0,0,.45);s.shadow_size=5;s.shadow_offset=Vector2(0,5)
	s.content_margin_left=24;s.content_margin_right=24
	return s
static func image(game:Node2D,texture:Texture2D,rect:Rect2) -> TextureRect:
	var view=TextureRect.new();view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.texture=texture;view.position=rect.position;view.size=rect.size;view.mouse_filter=Control.MOUSE_FILTER_IGNORE;game.ui_root.add_child(view);return view
static func background(game:Node2D):
	var bg=Control.new();bg.name='FullBleedBackdrop';bg.set_script(preload('res://scripts/ui/presentation_backdrop.gd'));bg.game=game
	bg.position=game.ui_bleed.position;bg.size=game.ui_bleed.size
	game.ui_root.add_child(bg)
static func brand(game:Node2D):
	image(game,STUDIO,Rect2(1595,158,220,60))
static func menu(game:Node2D):
	game.clear_ui();background(game)
	image(game,STUDIO,Rect2(105,60,245,100))
	game.label_at('ANDROID ALPHA 0.8  /  OFFLINE',Vector2(1340,88),25,Color('#AAB4C5'))
	image(game,LOGO,Rect2(75,170,970,430))
	game.label_at('DEIN HELD. DEIN BUILD. DEIN MAYHEM.',Vector2(125,605),31,Color('#FFE2AA'))
	game.button('▶  SPIELEN',Vector2(110,675),Vector2(850,115),game.character_select,Color('#A74713'))
	game.button('CHARAKTERE',Vector2(110,815),Vector2(410,90),game.character_select)
	game.button('ZIELE & STILE',Vector2(550,815),Vector2(410,90),game.challenges_screen)
	game.button('STATISTIK',Vector2(110,930),Vector2(410,85),game.statistics)
	game.button('EINSTELLUNGEN',Vector2(550,930),Vector2(410,85),func():game.settings(game.main_menu))
	game.label_at('DIE MAYHEM CREW',Vector2(1190,275),50,Color('#FFAE35'))
	game.label_at('DREI HELDEN. KEIN RÜCKZUG.',Vector2(1180,340),27,Color('#AAB4C5'))
	game.portrait(Vector2(1050,505),0,.95)
	game.portrait(Vector2(1500,520),2,.92)
	game.portrait(Vector2(1245,430),1,1.22)
	game.label_at('10 WELLEN  /  2 ARENEN  /  DEIN ÜBERLEBEN',Vector2(1100,955),27,Color('#AAB4C5'))
	reveal(game)

static func reveal(game:Node2D):
	if game.test_mode or game.saved.settings.quality=='LOW':return
	for node in game.ui_root.get_children():
		if node is Control and node.name!='FullBleedBackdrop':
			node.modulate.a=0
			var tween=node.create_tween();tween.tween_property(node,'modulate:a',1.0,.22)

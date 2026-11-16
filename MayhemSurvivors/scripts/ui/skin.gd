extends RefCounted
const HEADING=preload('res://assets/ui/fonts/BarlowCondensed-Bold.ttf')
const BODY=preload('res://assets/ui/fonts/Barlow-SemiBold.ttf')
const LOGO=preload('res://assets/branding/mayhem_wordmark.png')
const STUDIO=preload('res://assets/branding/rf_worlds.svg')
const Icons=preload('res://scripts/ui/icon_catalog.gd')
const ICON=preload('res://assets/branding/app_icon.png')
static func box(color:Color,accent:Color=Color('#795396')) -> StyleBoxFlat:
	var s=StyleBoxFlat.new();s.bg_color=Color(color.r*.78,color.g*.65,maxf(.12,color.b*.95),.96)
	s.border_color=accent;s.border_width_left=3;s.border_width_right=2;s.border_width_top=2;s.border_width_bottom=4
	s.set_corner_radius_all(16);s.shadow_color=Color(.03,.005,.065,.65);s.shadow_size=8;s.shadow_offset=Vector2(0,5)
	s.content_margin_left=24;s.content_margin_right=24
	return s
static func image(game:Node2D,texture:Texture2D,rect:Rect2) -> TextureRect:
	var view=TextureRect.new();view.expand_mode=TextureRect.EXPAND_IGNORE_SIZE;view.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	view.texture=texture;view.position=rect.position;view.size=rect.size;view.mouse_filter=Control.MOUSE_FILTER_IGNORE;game.ui_root.add_child(view);return view
static func background(game:Node2D,home:bool=false):
	var bg=Control.new();bg.name='FullBleedBackdrop';bg.set_script(preload('res://scripts/ui/presentation_backdrop.gd'));bg.game=game;bg.is_home=home
	bg.position=game.ui_bleed.position;bg.size=game.ui_bleed.size
	game.ui_root.add_child(bg)
static func brand(game:Node2D):
	image(game,STUDIO,Rect2(1595,164,220,54))
static func panel(game:Node2D,rect:Rect2,accent:Color=Color('#795396')) -> Panel:
	var card=Panel.new();card.position=rect.position;card.size=rect.size;card.mouse_filter=Control.MOUSE_FILTER_IGNORE
	card.add_theme_stylebox_override('panel',box(Color('#201832'),accent));game.ui_root.add_child(card);return card
static func menu(game:Node2D):
	game.clear_ui();background(game,true)
	image(game,STUDIO,Rect2(105,48,250,100))
	game.label_at('ÜBERLEBE DAS CHAOS',Vector2(1490,82),25,Color('#D6C4E6'))
	image(game,LOGO,Rect2(75,160,950,425))
	game.label_at('DEIN HELD. DEIN BUILD. DEIN MAYHEM.',Vector2(125,590),29,Color('#F1DEF9'))
	game.button('SPIELEN',Vector2(115,655),Vector2(830,115),game.character_select,Color('#9C247D'))
	game.button('CHARAKTERE',Vector2(115,800),Vector2(400,95),game.character_select)
	game.button('ZIELE & STILE',Vector2(545,800),Vector2(400,95),game.challenges_screen)
	game.button('STATISTIK',Vector2(115,925),Vector2(400,90),game.statistics)
	game.button('EINSTELLUNGEN',Vector2(545,925),Vector2(400,90),func():game.settings(game.main_menu))
	game.label_at('DIE MAYHEM CREW',Vector2(1240,265),43,Color('#FFE4B7'))
	game.label_at('10 WELLEN. EIN ZIEL: ÜBERLEBEN.',Vector2(1160,325),25,Color('#EDCEFB'))
	game.portrait(Vector2(1045,535),0,.97)
	game.portrait(Vector2(1490,540),2,.94)
	game.portrait(Vector2(1230,440),1,1.25)
	game.label_at('3 HELDEN   /   2 ARENEN   /   DEINE WAHL',Vector2(1145,980),25,Color('#E7D7F3'))
	game.label_at('v0.13  /  RF WORLDS',Vector2(1560,1030),18,Color('#D6C4E6'))
	game.schedule_menu_reveal()
static func decorate_screen(game:Node2D,title:String):
	if title=='EINSTELLUNGEN':panel(game,Rect2(90,260,1460,415))
	elif title=='DEIN BUILD':
		panel(game,Rect2(90,260,500,600));panel(game,Rect2(620,260,570,350));panel(game,Rect2(1210,260,570,350));panel(game,Rect2(620,620,1160,210))
	elif title.contains('STATISTIK'):
		panel(game,Rect2(90,335,830,510));panel(game,Rect2(950,335,850,510))
	elif title.contains('GEMEISTERT') or title=='DAS WAR EIN MAYHEM!':panel(game,Rect2(85,260,1160,460))
	elif title in ['DURCHATMEN','RUN WIRKLICH BEENDEN?']:
		panel(game,Rect2(85,270,700,560));image(game,LOGO,Rect2(1110,285,620,300));game.portrait(Vector2(1250,545),game.selected,.85)
static func reveal(game:Node2D,revision:int):
	if revision!=game.ui_revision or game.test_mode or game.saved.settings.quality=='LOW' or game.state==game.State.COMBAT:return
	var index=0
	for node in game.ui_root.get_children():
		if node is Control and node.name!='FullBleedBackdrop':
			if node is Label:node.mouse_filter=Control.MOUSE_FILTER_IGNORE
			var target=node.position
			node.modulate.a=0;node.position.y+=12
			var tween=node.create_tween().set_parallel(true)
			var delay=minf(.09,index*.005)
			tween.tween_property(node,'modulate:a',1.0,.22).set_delay(delay)
			tween.tween_property(node,'position',target,.27).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_delay(delay)
			index+=1

static func wrap_text(text:String,font:Font,font_size:int,width:float) -> String:
	var lines=PackedStringArray()
	for paragraph in text.split('\n'):
		var line=''
		for word in paragraph.split(' ',false):
			var candidate=word if line.is_empty() else line+' '+word
			if not line.is_empty() and font.get_string_size(candidate,HORIZONTAL_ALIGNMENT_LEFT,-1,font_size).x>width:
				lines.append(line);line=word
			else:line=candidate
		lines.append(line)
	return '\n'.join(lines)

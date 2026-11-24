extends RefCounted
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var arena='scrapyard'
var difficulty='normal'
var revision=-1
func refresh():
	if is_instance_valid(game) and revision==game.ui_revision:show()
func _init(g:Node):game_ref=weakref(g)
func button(value:String,rect:Rect2,action:Callable):return game.button(value,rect.position,rect.size,func():game.queue_ui_action(action))
func text(value:String,rect:Rect2,font:int=30,color:Color=Color.WHITE):
	var l=game.label_at(value,rect.position,font,color);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.set_deferred('size',rect.size)
func show():
	if not game.play_games.allowed():return
	game.backdrop('DEINE REKORDE / BESTENLISTEN','Dein lokales Profil bleibt unabhängig von Google Play Games')
	revision=game.ui_revision
	button('ARENA: '+game.Arenas.definition(arena).name,Rect2(100,245,900,85),func():arena=game.Arenas.IDS[(game.Arenas.IDS.find(arena)+1)%10];show())
	button('STUFE: '+game.Difficulty.definition(difficulty).name,Rect2(1040,245,780,85),func():difficulty=['normal','veteran','mayhem'][(['normal','veteran','mayhem'].find(difficulty)+1)%3];show())
	for i in range(2):
		var mode=['campaign','endless'][i];var x=100+i*875;var r=game.saved.difficulty_records[difficulty][mode][arena]
		game.UISkin.panel(game,Rect2(x,365,835,400),game.TEAL)
		text('KAMPAGNE / SIEGZEIT' if i==0 else 'ENDLOS / GESCHAFFTE WELLEN',Rect2(x+30,395,770,75),39,game.GOLD)
		text(('Bester Sieg: '+game.duration_text(r.fastest_victory) if r.fastest_victory>0 else 'Noch kein Sieg in dieser Kategorie.') if i==0 else 'Höchste erreichte Welle: %d' % r.highest_wave,Rect2(x+30,505,770,100),34)
		text('%d gespielte Runs / %d Kills insgesamt' % [r.runs,r.kills],Rect2(x+30,620,770,70),29)
		var key=game.play_games.Scores.board_key(mode,arena,difficulty)
		if game.play_games.ready() and game.play_games.boards().has(key):
			button('ONLINE-BESTENLISTE',Rect2(x+30,675,770,70),func():game.play_games.show_board(key)).disabled=not game.play_games.bound() or game.play_games.request!=''
	var online=game.play_games
	text(online.message if online.message!='' else ('Freiwillig verbinden: Übermittelt werden nur Spielerkennung, Kategorie und neue Run-Ergebnisse. Kein Upload deiner Sammlung oder Profilnamen.' if online.ready() else 'Persönliche Rekorde sind vollständig offline verfügbar. Google-Play-Ranglisten sind in dieser Version noch nicht freigeschaltet.'),Rect2(110,790,1700,110),28,game.TEAL)
	button('ZURÜCK',Rect2(100,965,500,85),func():game.extras.show())
	if online.ready():
		button('GOOGLE PLAY VERBINDEN',Rect2(640,965,700,85),func():online.connect_player();show()).disabled=online.request!=''
		button('AUSSCHALTEN',Rect2(1380,965,440,85),func():online.disable_profile();show()).disabled=not game.saved.online_scores.enabled
	else:button('ALLE STATISTIKEN',Rect2(1180,965,640,85),game.statistics)
	game.ui_back_action=func():game.extras.show();game.ui_back_priority=3

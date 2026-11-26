extends RefCounted
const Model=preload('res://scripts/progression/loadout_presets.gd')
var game_ref:WeakRef
var game:
	get:return game_ref.get_ref()
var hero=0
var message=''
func _init(g:Node):game_ref=weakref(g)
func allowed() -> bool:return game.state in [game.State.MAIN_MENU,game.State.CHARACTER_SELECT] and not game.practice.active
func button(value:String,rect:Rect2,action:Callable):return game.button(value,rect.position,rect.size,func():game.queue_ui_action(action))
func text(value:String,rect:Rect2,font:int=28,color:Color=Color.WHITE):
	var l=game.label_at(value,rect.position,font,color);l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;l.set_deferred('size',rect.size)
func show(index:int=-1):
	if not allowed():return
	hero=clampi(index if index>=0 else hero,0,game.characters.size()-1)
	var fighter=game.characters[hero];var owned=game.saved.collection.heroes.has(fighter.id)
	game.backdrop('BUILDS / '+fighter.name,'Drei gespeicherte Builds je Fighter / Ausrüstung gilt ab dem nächsten Run')
	button('‹',Rect2(100,245,100,85),func():show(posmod(hero-1,15)))
	button('›',Rect2(1720,245,100,85),func():show(posmod(hero+1,15)))
	text('Aktuelle Ausrüstung in einem Slot sichern, später mit einem Tippen anlegen.',Rect2(240,260,1420,60),29,game.TEAL)
	var entries=Model.rows(game.saved,fighter.id)
	for i in range(3):
		var x=100+i*585;var empty:bool=entries[i].is_empty()
		game.UISkin.panel(game,Rect2(x,350,550,560),game.TEAL if not empty else Color('#795396'))
		text('BUILD %d' % (i+1),Rect2(x+25,375,490,65),45,game.GOLD)
		var lines='Noch kein Build gespeichert.' if empty else ''
		if not empty:
			for slot in game.Collection.SLOTS:
				var id=entries[i].get(slot,'')
				if id!='':lines+=game.Collection.catalog().items[id].name+'\n'
		text(lines,Rect2(x+25,470,490,230),29)
		button('ANLEGEN',Rect2(x+25,720,500,75),func():transact('apply',i)).disabled=empty or not owned
		button('AKTUELLES SPEICHERN',Rect2(x+25,815,500,75),func():confirm_store(i)).disabled=not owned
	text(message if owned else 'Diesen Fighter musst du zuerst freischalten.',Rect2(110,925,1700,45),26,game.TEAL if owned else game.GOLD)
	button('ZURÜCK',Rect2(100,970,530,85),func():game.extras.show())
	button('ZUR GARAGE',Rect2(1230,970,590,85),func():game.garage.show(hero))
	game.ui_back_action=func():game.extras.show();game.ui_back_priority=3
func confirm_store(index:int):
	if not allowed():return
	if Model.rows(game.saved,game.characters[hero].id)[index].is_empty():transact('store',index);return
	game.backdrop('BUILD %d ERSETZEN?' % (index+1),'Deine aktuelle Ausrüstung ersetzt diesen gespeicherten Build.')
	button('ABBRECHEN',Rect2(200,620,650,110),func():show())
	button('AKTUELLES SPEICHERN',Rect2(1000,620,720,110),func():transact('store',index))
	game.ui_back_action=func():show();game.ui_back_priority=3
func transact(action:String,index:int) -> bool:
	if not allowed():return false
	var before=game.saved.duplicate(true);var selected=game.selected;var id=game.characters[hero].id
	var ok=Model.store(game.saved,id,index) if action=='store' else Model.apply(game.saved,id,index)
	if not ok:return false
	if action=='apply':game.selected=hero
	if not game.save_game():game.saved=before;game.selected=selected;message=game.save_error;show();return false
	message='Build %d %s. Dein gespeicherter Run bleibt unverändert.' % [index+1,'gespeichert' if action=='store' else 'angelegt']
	game.sound('skin_equip');show();return true

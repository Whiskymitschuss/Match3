extends RefCounted
const Data=preload('res://scripts/progression/recap_data.gd')
const ICON=preload('res://assets/ui/icons/analysis.svg')
const Compare=preload('res://scripts/progression/run_comparison.gd')
const MODULES={'bruiser':'fault_core','sparky':'ion_relay','shade':'umbra_spool'}
const OUTCOMES={'cleared':'GESCHAFFT','defeat':'GEFALLEN','timeout':'ZEIT ABGELAUFEN','abandoned':'BEENDET','interrupted':'UNTERBROCHEN'}
var owner_ref:WeakRef
var game:Node2D:
	get:return owner_ref.get_ref()
var report:Dictionary={}
var analysis:Dictionary={}
var back:Callable
var tab='overview'
var page=0
var only_bosses=false
var compare_index=0
func _init(g:Node2D):owner_ref=weakref(g)
static func time_text(seconds:float) -> String:
	var tenths=roundi(seconds*10)
	return '%02d:%02d,%d' % [tenths/600,(tenths/10)%60,tenths%10]
func text(value:String,rect:Rect2,font:int=28,color:Color=Color.WHITE):
	var label=game.label_at(value,rect.position,font,color);label.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART;label.set_deferred('size',rect.size);return label
func action(label:String,rect:Rect2,callback:Callable,color:Color=Color('#2F2044')) -> Button:
	return game.button(label,rect.position,rect.size,func():game.queue_ui_action(callback),color)
func dispose():
	back=Callable();report.clear();analysis.clear()
func leave():
	var target=back;back=Callable();report.clear();analysis.clear()
	if target.is_valid():target.call()
	else:game.main_menu()
func show_current():
	if game.state not in [game.State.VICTORY,game.State.GAME_OVER]:return
	show({'character':game.characters[game.selected].id,'arena':game.arena_id,'difficulty':game.run_difficulty,'mode':game.run_mode,'won':game.state==game.State.VICTORY,'wave':game.wave_number,'time':game.run_time,'level':game.level,'kills':game.kills,'damage':game.dealt,'coins':game.earned,'weapons':game.weapons.duplicate(true),'items':game.run_items.owned.duplicate(),'analysis':game.recap.snapshot()},game.show_result)
func show(run:Dictionary,return_to:Callable):
	if game.state not in [game.State.MAIN_MENU,game.State.VICTORY,game.State.GAME_OVER]:return
	report=game.RunRecords.clean_run(run);analysis=Data.clean(report.get('analysis'));back=return_to;tab='overview';page=0;only_bosses=false;compare_index=0;render()
func select(value:String):tab=value;page=0;render()
func render():
	if report.is_empty():return
	var hero=game.RunRecords.CHARACTERS.find(report.character)
	var mode='ENDLOS' if report.get('mode','campaign')=='endless' else 'KAMPAGNE'
	game.backdrop('DEINE RUN-ANALYSE',game.characters[hero].name+' / '+game.Arenas.definition(report.arena).name+' / '+mode+' / '+game.Difficulty.definition(report.get('difficulty','normal')).name)
	for i in range(4):
		var key=['overview','waves','module','compare'][i]
		action(['ÜBERBLICK','WELLEN & BOSSE','KLASSENMODUL','VERGLEICH'][i],Rect2(100+i*435,245,410,80),func():select(key),Color('#64417C') if tab==key else Color('#2F2044'))
	action('ZURÜCK',Rect2(100,960,480,90),leave)
	if analysis.is_empty():
		game.UISkin.panel(game,Rect2(100,370,1720,530),game.TEAL)
		game.UISkin.image(game,ICON,Rect2(170,430,220,220))
		text('DIESER RUN HAT NOCH KEINE MESSDATEN',Rect2(470,430,1250,80),42,game.GOLD)
		text('Detaillierte Wellenbilanzen werden ab Version 0.26 aufgezeichnet. Deine bisherigen Bestwerte bleiben erhalten. Spiele einen neuen Run, um Kampfzeiten, HP-Verlust und Modulwirkung anzusehen.',Rect2(470,540,1180,240),34)
		return
	if tab=='overview':overview()
	elif tab=='waves':waves()
	elif tab=='compare':comparison()
	else:module()
func comparison_reference(character:int=-1,arena_filter:String='all') -> Dictionary:
	for run in game.saved.recent_runs:
		if (character<0 or run.character==game.characters[character].id) and (arena_filter=='all' or run.arena==arena_filter) and not Data.clean(run.get('analysis')).is_empty():return run
	return {}
func show_recent_compare(character:int=-1,arena_filter:String='all'):
	if game.state not in [game.State.MAIN_MENU,game.State.VICTORY,game.State.GAME_OVER]:return
	var reference=comparison_reference(character,arena_filter)
	if reference.is_empty():return
	show(reference,func():game.statistics(character,arena_filter));tab='compare';render()
func comparison_card(run:Dictionary,at:Vector2,title:String):
	var hero=game.RunRecords.CHARACTERS.find(run.character);var m=Compare.metrics(run)
	game.UISkin.panel(game,Rect2(at,Vector2(835,470)),Color(game.characters[hero].color))
	text(title,Rect2(at+Vector2(25,18),Vector2(780,40)),25,game.TEAL)
	text(game.characters[hero].name+' / '+('SIEG' if run.won else 'WELLE %d' % run.wave),Rect2(at+Vector2(25,65),Vector2(780,60)),42,game.GOLD)
	var values=[['KAMPFZEIT',time_text(m.seconds)],['HP-VERLUST','%.1f HP' % m.received],['SCHADEN / SEKUNDE','%.1f' % m.dps],['KILLS / RUN-COINS','%d / %d' % [m.kills,m.coins]]]
	for i in range(values.size()):
		text(values[i][0],Rect2(at+Vector2(25,150+i*54),Vector2(440,46)),26)
		text(values[i][1],Rect2(at+Vector2(490,145+i*54),Vector2(310,50)),32,game.TEAL)
	var equipment=' / '.join(run.weapons.map(func(w):return game.weapon_data[w.id].name+' Lv.'+str(w.level)))
	text(equipment,Rect2(at+Vector2(25,385),Vector2(780,65)),24)
func comparison():
	var options=Compare.candidates(game.saved.recent_runs,report)
	if options.is_empty():
		game.UISkin.panel(game,Rect2(100,370,1710,500),game.TEAL)
		text('DEIN NÄCHSTER VERGLEICH BRAUCHT EINEN ZWEITEN RUN',Rect2(145,420,1620,100),42,game.GOLD)
		text('Spiele dieselbe Arena mit derselben Schwierigkeit und demselben Modus erneut. Du kannst dabei einen anderen Kämpfer ausprobieren. Danach lassen sich hier deine tatsächlichen Kampfzeiten, HP-Verluste und Builds nebeneinander ansehen.\n\nNur gespeicherte Messdaten werden verwendet. Kampagne und Endlos werden getrennt verglichen.',Rect2(145,550,1530,260),32)
		return
	compare_index=posmod(compare_index,options.size());var other=options[compare_index]
	comparison_card(report,Vector2(100,360),'AUSGEWÄHLTER RUN');comparison_card(other,Vector2(975,360),'FRÜHERER RUN %d / %d' % [compare_index+1,options.size()])
	text('Gleiche Arena, Schwierigkeit und gleicher Modus. Builds, Ausbau, Spielweise und Spielversion können abweichen. Die Werte sind kein automatisches Stärke-Ranking.',Rect2(115,850,1660,88),25,game.TEAL)
	action('FRÜHEREN RUN WECHSELN',Rect2(975,960,835,90),func():compare_index+=1;render()).disabled=options.size()<2
func metric(rect:Rect2,title:String,value:String,detail:String,color:Color):
	game.UISkin.panel(game,rect,color)
	text(title,Rect2(rect.position+Vector2(25,17),Vector2(rect.size.x-50,50)),26,color)
	text(value,Rect2(rect.position+Vector2(25,60),Vector2(rect.size.x-50,70)),52,game.GOLD)
	text(detail,Rect2(rect.position+Vector2(25,137),Vector2(rect.size.x-50,40)),23)
func overview():
	var t=analysis.totals
	metric(Rect2(100,360,835,200),'AKTIVE KAMPFZEIT',time_text(t.seconds),'Pause, Shop und Upgrade-Auswahl zählen nicht.',game.TEAL)
	metric(Rect2(975,360,835,200),'TATSÄCHLICHER HP-VERLUST','%.1f HP' % t.received,'%d Treffer nach Rüstung und Schutz.' % t.hits,Color('#FF6376'))
	metric(Rect2(100,595,835,200),'DEIN SCHADEN','%d' % t.damage,'%d Kills / %d verdiente Run-Coins' % [t.kills,t.coins],Color('#FF9F1C'))
	metric(Rect2(975,595,835,200),'DEIN KLASSENMODUL','%d Zusatzschaden' % t.combo_damage,'%d Auslösungen / %d aktive Fähigkeiten' % [t.procs,t.abilities],Color('#A55EEA'))
	var equipment=' / '.join(report.weapons.map(func(w):return game.weapon_data[w.id].name+' Lv.'+str(w.level)+(' · '+game.Specs.label(w) if not game.Specs.label(w).is_empty() else '')))
	text('DEIN BUILD: '+equipment+'\nWELLEN & BOSSE zeigt Kampfzeiten und HP-Verlust. KLASSENMODUL erklärt den zusätzlich verursachten Schaden.',Rect2(115,825,1660,110),26,game.TEAL)
func filtered_waves() -> Array:
	return analysis.waves.filter(func(row):return not only_bosses or row.boss)
func waves():
	var rows=filtered_waves();var pages=maxi(1,ceili(rows.size()/5.0));page=clampi(page,0,pages-1)
	action('ALLE WELLEN' if only_bosses else 'NUR BOSSE',Rect2(1420,340,390,65),func():only_bosses=not only_bosses;page=0;render())
	text('WELLE / AUSGANG',Rect2(125,362,560,40),25,game.GOLD)
	for i in range(3):text(['KAMPFZEIT','SCHADEN','HP-VERLUST'][i],Rect2(720+i*235,362,225,40),23,game.TEAL)
	for i in range(5):
		var index=page*5+i
		if index>=rows.size():break
		var row=rows[index];var y=430+i*97;var color=game.GOLD if row.boss else game.TEAL
		game.UISkin.panel(game,Rect2(100,y,1710,85),color)
		text('%d / %s' % [row.wave,OUTCOMES[row.outcome]],Rect2(125,y+8,560,34),28,color)
		text(row.boss_name if row.boss else '%d Kills / %d Run-Coins / %d Fähigkeiten' % [row.kills,row.coins,row.abilities],Rect2(125,y+46,560,30),20)
		for j in range(3):text([time_text(row.seconds),str(roundi(row.damage)),'%.1f' % row.received][j],Rect2(720+j*235,y+24,220,45),30)
		text('%d MODUL\n%d BONUS' % [row.procs,row.combo_damage],Rect2(1450,y+10,330,65),23,Color('#BB9FDE'))
	if rows.is_empty():text('In diesem Run wurde noch keine Bosswelle begonnen.',Rect2(125,490,1500,100),34)
	if analysis.omitted>0:text('Letzte 50 Wellen. Gesamtwerte enthalten auch %d frühere Wellen.' % analysis.omitted,Rect2(110,922,1600,35),22,game.TEAL)
	var previous=action('VORHERIGE',Rect2(700,960,390,90),func():page-=1;render());previous.disabled=page==0
	text('%d / %d' % [page+1,pages],Rect2(1130,980,160,45),28,game.GOLD)
	var next=action('NÄCHSTE',Rect2(1360,960,450,90),func():page+=1;render());next.disabled=page>=pages-1
func module():
	var id=MODULES.get(report.character,'');var owned=report.get('items',[]).has(id);var t=analysis.totals
	game.UISkin.panel(game,Rect2(100,370,530,550),Color('#A55EEA'))
	game.UISkin.image(game,game.run_items.icon(id) if not id.is_empty() else ICON,Rect2(245,400,240,220))
	text('MODUL GEKAUFT' if owned else 'KEIN MODUL GEKAUFT',Rect2(130,655,460,60),30,game.GOLD)
	text('%d Auslösungen\n%d tatsächlicher Zusatzschaden' % [t.procs,t.combo_damage],Rect2(130,730,455,140),30,game.TEAL)
	game.UISkin.panel(game,Rect2(680,370,1130,550),game.TEAL)
	var title=game.run_items.data[id].name if not id.is_empty() else 'DEINE FÄHIGKEITEN'
	text(title,Rect2(715,400,1060,70),44,game.GOLD)
	var body=game.run_items.data[id].details if not id.is_empty() else 'Deine aktive Fähigkeit wurde %d Mal eingesetzt. Pro Run kannst du Waffen, Entwicklungen und Gegenstände kombinieren. Die drei Klassenmodule in diesem Update gehören zu Bruiser, Sparky und Shade.' % t.abilities
	text(body,Rect2(715,495,1040,270),29)
	var note='Zusatzschaden zählt nur zusätzlich entfernte Gegner-HP. Ein ohnehin tödlicher Grundtreffer zählt keinen Bonus. Relais-Auslösungen ohne weitere Ziele sind möglich.'
	if not owned and not id.is_empty():note='Für deinen nächsten Run: Dieses Modul ist für deine Klasse im Wellenshop garantiert erhältlich, solange du die passende Hauptwaffe trägst.'
	text(note,Rect2(715,800,1040,105),25,game.TEAL)

extends RefCounted
const R=preload('res://scripts/core/roster.gd')
const DIFFICULTIES=['normal','veteran','mayhem']
const MODES=['campaign','endless']
const LIMIT=20
static func defaults() -> Dictionary:return {'enabled':false,'player_id':'','outbox':[],'sent':[],'ticket':{}}
static func board_key(mode:String,arena:String,difficulty:String) -> String:return mode+':'+arena+':'+difficulty
static func valid_key(value) -> bool:
	if not value is String:return false
	var p=value.split(':');return p.size()==3 and p[0] in MODES and p[1] in R.ARENAS and p[2] in DIFFICULTIES
static func run_id(value) -> bool:return value is String and value.length()==32 and value.is_valid_hex_number(false)
static func value_ok(value,key:String) -> bool:
	if not (value is int or value is float) or not is_finite(float(value)) or float(int(value))!=value:return false
	return value>=1 and value<=(7200000 if key.begins_with('campaign:') else 1000000)
static func clean(source) -> Dictionary:
	var d=defaults()
	if not source is Dictionary:return d
	if source.get('player_id') is String and source.player_id.length()<=128:d.player_id=source.player_id
	d.enabled=source.get('enabled')==true and d.player_id!=''
	if source.get('sent') is Array:
		for id in source.sent:
			if run_id(id) and not d.sent.has(id):d.sent.append(id)
			if d.sent.size()>=64:break
	if source.get('outbox') is Array:
		var seen=[]
		for e in source.outbox:
			if not e is Dictionary or not run_id(e.get('run')) or not valid_key(e.get('board')) or not value_ok(e.get('score'),e.board) or e.get('player')!=d.player_id or seen.has(e.run) or d.sent.has(e.run):continue
			d.outbox.append({'run':e.run,'board':e.board,'score':int(e.score),'player':d.player_id});seen.append(e.run)
			if d.outbox.size()>=LIMIT:break
	var t=source.get('ticket')
	if t is Dictionary and run_id(t.get('run')) and valid_key(t.get('board')) and t.get('player')==d.player_id and t.get('version')==1 and t.get('hero') in R.HEROES:d.ticket=t.duplicate(true)
	return d
static func begin(saved:Dictionary,id:String,mode:String,arena:String,difficulty:String,hero:String,boards:Dictionary):
	var d=saved.online_scores;d.ticket={};var key=board_key(mode,arena,difficulty)
	if not d.enabled or d.player_id=='' or not run_id(id) or not boards.has(key) or not valid_key(key):return
	d.ticket={'run':id,'board':key,'player':d.player_id,'version':1,'hero':hero}
static func finish(saved:Dictionary,id:String,mode:String,arena:String,difficulty:String,hero:String,won:bool,time:float,waves:int) -> bool:
	var d=saved.online_scores;var ticket=d.ticket;d.ticket={}
	var key=board_key(mode,arena,difficulty)
	if ticket.is_empty() or not d.enabled or ticket.run!=id or ticket.board!=key or ticket.hero!=hero or ticket.player!=d.player_id or d.sent.has(id) or d.outbox.any(func(e):return e.run==id):return false
	if mode=='campaign' and not won:return false
	var score=roundi(time*1000) if mode=='campaign' else waves
	if not value_ok(score,key):return false
	if d.outbox.size()>=LIMIT:d.outbox.pop_front()
	d.outbox.append({'run':id,'board':key,'score':score,'player':d.player_id});return true
static func acknowledge(saved:Dictionary,id:String):
	var d=saved.online_scores
	d.outbox=d.outbox.filter(func(e):return e.run!=id)
	if not d.sent.has(id):d.sent.append(id)
	while d.sent.size()>64:d.sent.pop_front()
static func portable(saved:Dictionary) -> Dictionary:
	var copy=saved.duplicate(true);copy.online_scores=defaults();return copy

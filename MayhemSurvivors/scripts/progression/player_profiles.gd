extends RefCounted
const Save=preload('res://scripts/autoload/save_manager.gd')
const Store=preload('res://scripts/autoload/local_store.gd')
const LIMIT=5
var root:String
var index:Dictionary
var error=''
var notice=''
var load_status:Dictionary={}
func _init(base:String='user://'):
	root=base.trim_suffix('/')+'/'
	var result=Store.read(index_path(),valid_index)
	index=result.data if not result.data.is_empty() else rebuild()
	if result.status=='recovered':notice='Profilübersicht aus Sicherung wiederhergestellt.'
	elif result.status=='damaged':notice='Profilübersicht aus vorhandenen Spielständen wiederhergestellt.'
static func number(id:String) -> int:
	if not id.begins_with('player_'):return 0
	var digits=id.trim_prefix('player_')
	if not digits.is_valid_int():return 0
	var n=int(digits)
	return n if n>=1 and n<=1000000 and str(n)==digits else 0
static func clean_name(value:String) -> String:
	var out=''
	for character in value:
		if character.unicode_at(0)>=32 and character.unicode_at(0)!=127:out+=character
	return out.strip_edges().substr(0,18)
static func valid_index(value:Dictionary) -> bool:
	if value.get('version')!=1 or not value.get('profiles') is Array or value.profiles.is_empty() or value.profiles.size()>LIMIT:return false
	var seen=[];var names=[]
	for entry in value.profiles:
		if not entry is Dictionary or not entry.get('id') is String or number(entry.id)==0 or seen.has(entry.id) or not entry.get('name') is String:return false
		if entry.name.is_empty() or entry.name!=clean_name(entry.name) or names.has(entry.name.to_lower()):return false
		seen.append(entry.id);names.append(entry.name.to_lower())
	return seen.has('player_1') and seen.has(value.get('active')) and (value.get('next') is int or value.get('next') is float) and is_finite(float(value.next)) and value.next>=2 and value.next<=1000001
func index_path() -> String:return root+'profiles/index.json'
func path_for(id:String) -> String:
	var n=number(id)
	return '' if n==0 else (root+'save.json' if n==1 else root+'profiles/'+id+'.json')
func active_path() -> String:return path_for(index.active)
func active_name() -> String:
	for entry in index.profiles:
		if entry.id==index.active:return entry.name
	return 'Spieler 1'
func has(id:String) -> bool:return index.profiles.any(func(p):return p.id==id)
func rebuild() -> Dictionary:
	var entries=[{'id':'player_1','name':'Spieler 1'}];var next=2
	var folder=DirAccess.open(root+'profiles')
	if folder:
		var names=folder.get_files();names.sort()
		for file in names:
			var id=file.trim_suffix('.json');var n=number(id)
			if n<2 or not file.ends_with('.json') or Store.parse(path_for(id),Save.valid_file).is_empty():continue
			next=maxi(next,n+1)
			if entries.size()<LIMIT:entries.append({'id':id,'name':'Spieler '+str(n)})
	return {'version':1,'active':'player_1','profiles':entries,'next':next}
func commit(updated:Dictionary) -> bool:
	if DirAccess.make_dir_recursive_absolute(root+'profiles')!=OK:error='Der lokale Speicher ist nicht beschreibbar.';return false
	if Store.write(updated,index_path(),valid_index)!=OK:error='Profiländerung konnte nicht gespeichert werden. Bitte erneut versuchen.';return false
	index=updated;error='';return true
func load_active() -> Dictionary:
	var saved=Save.load_local(active_path());load_status=Save.last_load.duplicate(true)
	if load_status.get('status')=='recovered':notice='Dein Spielstand wurde automatisch aus der Sicherung wiederhergestellt.'
	elif load_status.get('status')=='damaged':notice='Spielstand und Sicherung waren beschädigt. Ein gesicherter Fehlerstand bleibt erhalten; Standardfortschritt geladen.'
	return saved
func save_active(saved:Dictionary) -> bool:
	var result=Save.save_local(saved,active_path())
	error='' if result==OK else 'Spielstand konnte nicht gespeichert werden. Bitte Speicherplatz prüfen und erneut versuchen.'
	return result==OK
func available_name(value:String,except_id:String='') -> bool:
	return not value.is_empty() and not index.profiles.any(func(p):return p.id!=except_id and p.name.to_lower()==value.to_lower())
func create(value:String,initial:Dictionary={}) -> String:
	var name=clean_name(value)
	if index.profiles.size()>=LIMIT:error='Alle fünf Profilplätze sind belegt.';return ''
	if not available_name(name):error='Bitte einen freien Namen mit 1–18 Zeichen eingeben.';return ''
	var n=int(index.next)
	while n<=1000000 and (has('player_'+str(n)) or FileAccess.file_exists(path_for('player_'+str(n))) or FileAccess.file_exists(path_for('player_'+str(n))+'.removed')):n+=1
	if n>1000000:error='Kein freier Profilplatz gefunden.';return ''
	var id='player_'+str(n)
	var data=Save.defaults() if initial.is_empty() else Save.sanitize(initial)
	if not data.active_run.is_empty():data.active_run.owner=id
	if DirAccess.make_dir_recursive_absolute(root+'profiles')!=OK or Save.save_local(data,path_for(id))!=OK:error='Neues Profil konnte nicht gespeichert werden.';return ''
	var updated=index.duplicate(true);updated.profiles.append({'id':id,'name':name});updated.next=n+1
	if not commit(updated):DirAccess.remove_absolute(path_for(id));return ''
	return id
func rename(id:String,value:String) -> bool:
	var name=clean_name(value)
	if not has(id) or not available_name(name,id):error='Bitte einen freien Namen mit 1–18 Zeichen eingeben.';return false
	var updated=index.duplicate(true)
	for entry in updated.profiles:
		if entry.id==id:entry.name=name
	return commit(updated)
func switch_to(id:String,current:Dictionary) -> bool:
	if not has(id):error='Dieses Profil ist nicht verfügbar.';return false
	if not save_active(current):return false
	if id==index.active:return true
	var updated=index.duplicate(true);updated.active=id
	return commit(updated)
func remove(id:String) -> bool:
	if id in ['player_1',index.active] or not has(id):error='Das aktive Profil und das Startprofil bleiben erhalten.';return false
	var updated=index.duplicate(true);updated.profiles=updated.profiles.filter(func(p):return p.id!=id)
	if not commit(updated):return false
	# Keep removed saves under a non-discoverable archive name until explicitly replaced.
	for path in [path_for(id),Store.sidecar(path_for(id),'backup')]:
		if FileAccess.file_exists(path):DirAccess.rename_absolute(path,path+'.removed')
	return true
func restore() -> bool:
	var backup=Store.parse(Store.sidecar(active_path(),'backup'),Save.valid_file)
	if backup.is_empty():error='Keine gültige Sicherung für dieses Profil vorhanden.';return false
	if Save.save_local(backup.data,active_path())!=OK:error='Sicherung konnte nicht wiederhergestellt werden.';return false
	notice='Letzter Sicherungsstand geladen.';error='';return true

func import_new(value:String,data:Dictionary) -> String:
	if not Save.valid_file(data):error='Ungültiger Spielstand.';return ''
	var base=clean_name(value)
	if base=='':base='Import'
	var name=base;var suffix=2
	while not available_name(name):
		var tail=' ('+str(suffix)+')';name=base.substr(0,18-tail.length())+tail;suffix+=1
	var imported=data.duplicate(true);imported.online_scores=preload('res://scripts/progression/online_scores.gd').defaults()
	return create(name,imported)

extends RefCounted
# A valid primary is authoritative. Backups never receive malformed data.
static func sidecar(path:String,suffix:String) -> String:return path.get_basename()+'.'+suffix+'.json'
static func parse(path:String,valid:Callable) -> Dictionary:
	if not FileAccess.file_exists(path):return {}
	var file=FileAccess.open(path,FileAccess.READ)
	if not file:return {}
	if file.get_length()>8*1024*1024:file.close();return {}
	var raw=file.get_as_text();file.close();var parser=JSON.new()
	if parser.parse(raw)!=OK or not parser.data is Dictionary or not valid.call(parser.data):return {}
	return {'data':parser.data,'raw':raw}
static func write_raw(raw:String,path:String) -> Error:
	var f=FileAccess.open(path,FileAccess.WRITE)
	if not f:return FileAccess.get_open_error()
	f.store_string(raw);f.flush();var error=f.get_error();f.close();return error
static func archive_corrupt(path:String):
	if FileAccess.file_exists(path):DirAccess.copy_absolute(path,sidecar(path,'corrupt'))
static func read(path:String,valid:Callable) -> Dictionary:
	var main=parse(path,valid)
	if not main.is_empty():return {'data':main.data,'raw':main.raw,'status':'ok','source':path,'repair':OK}
	for candidate in [sidecar(path,'backup'),path+'.tmp']:
		var alternate=parse(candidate,valid)
		if alternate.is_empty():continue
		archive_corrupt(path)
		var repair=write_raw(alternate.raw,path+'.recover')
		if repair==OK:repair=DirAccess.rename_absolute(path+'.recover',path)
		if repair!=OK:DirAccess.remove_absolute(path+'.recover')
		return {'data':alternate.data,'raw':alternate.raw,'status':'recovered','source':candidate,'repair':repair}
	var exists=FileAccess.file_exists(path)
	if exists:archive_corrupt(path)
	return {'data':{},'raw':'','status':'damaged' if exists else 'new','source':path,'repair':OK}
static func write(data:Dictionary,path:String,valid:Callable) -> Error:
	if not valid.call(data):return ERR_INVALID_DATA
	var temp=path+'.tmp';var raw=JSON.stringify(data);var error=write_raw(raw,temp)
	if error!=OK:DirAccess.remove_absolute(temp);return error
	if parse(temp,valid).is_empty():DirAccess.remove_absolute(temp);return ERR_FILE_CORRUPT
	var previous=parse(path,valid)
	if not previous.is_empty():
		var backup=sidecar(path,'backup');error=write_raw(previous.raw,backup+'.tmp')
		if error==OK:error=DirAccess.rename_absolute(backup+'.tmp',backup)
		if error!=OK:DirAccess.remove_absolute(temp);DirAccess.remove_absolute(backup+'.tmp');return error
	elif FileAccess.file_exists(path):archive_corrupt(path)
	error=DirAccess.rename_absolute(temp,path)
	if error!=OK:DirAccess.remove_absolute(temp)
	return error

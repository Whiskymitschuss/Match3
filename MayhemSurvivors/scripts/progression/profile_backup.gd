extends RefCounted
const Save=preload('res://scripts/autoload/save_manager.gd')
const MAX_BYTES=8*1024*1024
const FORMAT='RFWorlds.MayhemSurvivors.Profile'
static func encode(saved:Dictionary,name:String) -> String:
	if not Save.valid_file(saved):return ''
	var payload=JSON.stringify({'name':name,'save':saved})
	var text=JSON.stringify({'format':FORMAT,'version':1,'created_at':int(Time.get_unix_time_from_system()),'payload':payload,'sha256':payload.sha256_text()})
	return text if text.to_utf8_buffer().size()<=MAX_BYTES else ''
static func decode(text:String) -> Dictionary:
	if text.to_utf8_buffer().size()>MAX_BYTES:return {'error':'Die Sicherungsdatei ist zu groß.'}
	var parser=JSON.new()
	if parser.parse(text)!=OK or not parser.data is Dictionary:return {'error':'Die Datei ist keine gültige Sicherung.'}
	var wrapper:Dictionary=parser.data
	if wrapper.get('format')!=FORMAT or wrapper.get('version')!=1:return {'error':'Dieses Sicherungsformat wird nicht unterstützt.'}
	if not wrapper.get('payload') is String or wrapper.get('sha256')!=wrapper.payload.sha256_text():return {'error':'Die Sicherung ist beschädigt oder unvollständig.'}
	if parser.parse(wrapper.payload)!=OK or not parser.data is Dictionary:return {'error':'Die Sicherung enthält keine gültigen Profildaten.'}
	var payload:Dictionary=parser.data
	if not payload.get('name') is String or not payload.get('save') is Dictionary or not Save.valid_file(payload.save):return {'error':'Die enthaltene Spielstand-Version wird nicht unterstützt.'}
	if payload.name.is_empty() or payload.name.length()>18:return {'error':'Ungültiger Profilname in der Sicherung.'}
	for character in payload.name:
		if character.unicode_at(0)<32 or character.unicode_at(0)==127:return {'error':'Ungültiger Profilname in der Sicherung.'}
	var cleaned=Save.sanitize(payload.save)
	if payload.save.get('active_run') is Dictionary and not payload.save.active_run.is_empty() and cleaned.active_run.is_empty():return {'error':'Der gespeicherte Run ist beschädigt oder gehört zu einer anderen Version.'}
	return {'name':payload.name,'save':cleaned,'error':''}
static func write_file(text:String,path:String) -> Error:
	if decode(text).get('error','')!='':return ERR_INVALID_DATA
	var file=FileAccess.open(path,FileAccess.WRITE)
	if not file:return FileAccess.get_open_error()
	file.store_string(text);file.flush();var error=file.get_error();file.close()
	if error!=OK:return error
	# Native Android streams do not expose every write failure via get_error().
	var verify=FileAccess.open(path,FileAccess.READ)
	if not verify:return ERR_FILE_CANT_READ
	if verify.get_length()>MAX_BYTES:verify.close();return ERR_FILE_CORRUPT
	var actual=verify.get_as_text();verify.close()
	return OK if actual==text else ERR_FILE_CORRUPT
static func read_file(path:String) -> Dictionary:
	var file=FileAccess.open(path,FileAccess.READ)
	if not file:return {'error':'Die Datei konnte nicht geöffnet werden.'}
	if file.get_length()>MAX_BYTES:file.close();return {'error':'Die Sicherungsdatei ist zu groß.'}
	var text=file.get_as_text();file.close();return decode(text)

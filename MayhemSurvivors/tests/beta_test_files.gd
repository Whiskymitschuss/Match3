extends RefCounted
static func clear(path:String):
	assert(path.begins_with('user://beta_test_') or path.begins_with('user://integration_beta_test'))
	var folder=DirAccess.open(path)
	if not folder:return
	for file in folder.get_files():DirAccess.remove_absolute(path.path_join(file))
	for directory in folder.get_directories():clear(path.path_join(directory))
	DirAccess.remove_absolute(path)
static func raw(path:String,value:String):
	var file=FileAccess.open(path,FileAccess.WRITE);assert(file);file.store_string(value);file.close()

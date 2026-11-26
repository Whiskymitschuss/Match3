@tool
extends EditorPlugin
var exporter:EditorExportPlugin
func _enter_tree():exporter=GamesExport.new();add_export_plugin(exporter)
func _exit_tree():remove_export_plugin(exporter);exporter=null
class GamesExport extends EditorExportPlugin:
	func _get_name() -> String:return 'RFPlayGames'
	func enabled() -> bool:
		var c=JSON.parse_string(FileAccess.get_file_as_string('res://data/network/play_games.json'))
		return c is Dictionary and c.get('provider')=='google_play' and str(c.get('project_id','')).is_valid_int() and int(c.project_id)>0 and not c.get('boards',{}).is_empty()
	func _supports_platform(platform:EditorExportPlatform) -> bool:return platform is EditorExportPlatformAndroid and enabled()
	func _get_android_libraries(_platform:EditorExportPlatform,_debug:bool) -> PackedStringArray:return PackedStringArray(['res://addons/rf_play_games/RFPlayGames-release.aar']) if enabled() else PackedStringArray()
	func _get_android_dependencies(_platform:EditorExportPlatform,_debug:bool) -> PackedStringArray:return PackedStringArray(['com.google.android.gms:play-services-games-v2:21.0.0']) if enabled() else PackedStringArray()

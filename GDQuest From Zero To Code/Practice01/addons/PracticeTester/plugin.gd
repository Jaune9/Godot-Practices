tool
extends EditorPlugin

const UIpracticesDock := preload("editor_ui/UIPracticesDock.gd")
const UIPracticesDockScene := preload("editor_ui/UIPracticesDock.tscn")

const UserProfiles := preload("UserProfiles.gd")

var _dock: Control
var _profile := UserProfiles.new()


func _enter_tree() -> void:
	add_autoload_singleton("UserProfiles", UserProfiles.resource_path)

	var practices := _load_csv_data()
	_profile.setup(practices)

	for practice_name in _profile.get_completed_practices():
		if not practice_name in practices:
			continue
		practices[practice_name].completed = true

	_dock = UIPracticesDockScene.instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, _dock)
	_dock.setup(get_editor_interface(), practices)
	_dock.connect("reset_progress_confirmed", _profile, "erase_progress")
	_dock.connect("practice_state_reset", _profile, "mark_incomplete")


func _exit_tree() -> void:
	remove_autoload_singleton("UserProfiles")
	remove_control_from_docks(_dock)
	if _dock and is_instance_valid(_dock):
		_dock.queue_free()


# Loads the CSV file and turns its contents into a Dictionary.
func _load_csv_data() -> Dictionary:
	var out := {}
	var file := File.new()
	var path := _to_absolute_path("practices_meta.csv")

	var error_code := file.open(path, File.READ)
	if error_code != OK:
		printerr("Error opening file %s, unable to load data from CSV table." % path)
		return {}

	var header := file.get_csv_line()
	while not file.eof_reached():
		var line := file.get_csv_line()
		if line.size() < 5:
			break

		var name: String = line[0]
		out[name] = {
			scene = line[1],
			description = line[2],
			goals = line[3],
			project = line[4],
			completed = false
		}
	return out


func _to_absolute_path(relative_path: String) -> String:
	var this_directory: String = get_script().resource_path
	this_directory = this_directory.rsplit("/", true, 1)[0]
	return this_directory.plus_file(relative_path)

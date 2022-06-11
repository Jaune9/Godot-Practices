tool
extends Control

signal reset_progress_confirmed
signal practice_state_reset(practice_name)

const UIPracticeItemScene := preload("UIPracticeItem.tscn")

const UIPracticeItem := preload("UIPracticeItem.gd")
const UIResetButton := preload("UIResetButton.gd")

# Path used by the UserProfile resource to pass a newly completed practice.
const COMPLETED_PATH := "user://new_completed_practices.cache"

var _editor_interface: EditorInterface
var _filesystem_dock: FileSystemDock

var _practice_to_item := {}

# Used to read newly completed practices.
var _file := File.new()
var _directory := Directory.new()

var _practice_reverter := preload("PracticeReverter.gd").new()

var _practice_count := 0
var _completed_practices := 0

onready var _column := $Column/ScrollContainer/Column as VBoxContainer
onready var _reset_button := $Column/UIResetButton as UIResetButton
onready var _poll_timer := $PollTimer as Timer
onready var _success_label := $Column/SuccessLabel
onready var _progress_bar := $Column/PanelContainer/ProgressBar


func _ready() -> void:
	_reset_button.connect("reset_progress_confirmed", self, "_erase_progress")


func setup(editor_interface: EditorInterface, data: Dictionary) -> void:
	_poll_timer.connect("timeout", self, "_on_PollTimer_timeout")
	_editor_interface = editor_interface
	_filesystem_dock = _editor_interface.get_file_system_dock()

	var project_number := 1
	var practice_number := 1
	var project := ""
	
	_practice_count = data.size()
	for practice_name in data:
		var practice_data: Dictionary = data[practice_name]

		if practice_data.project != project:
			project = practice_data.project
			var label := Label.new()
			label.text = "%d. %s" % [project_number, project.capitalize()]
			label.align = Label.ALIGN_CENTER
			_column.add_child(label)
			_column.add_child(HSeparator.new())
			practice_number = 1
			project_number += 1

		var instance: UIPracticeItem = UIPracticeItemScene.instance()
		instance.setup(practice_name, practice_data.completed)
		instance.connect(
			"scene_open_requested", self, "open_scene", [practice_data.scene]
		)
		instance.connect(
			"scene_revert_requested", self, "_revert_practice", [practice_name, practice_data.scene]
		)

		_column.add_child(instance)
		_practice_to_item[practice_name] = instance
		practice_number += 1
		if practice_data.completed:
			_completed_practices += 1
	update_progress_display()


func update_progress_display() -> void:
	_progress_bar.value = float(_completed_practices) / _practice_count


func open_scene(scene_path: String) -> void:
	_editor_interface.open_scene_from_path(scene_path)
	_filesystem_dock.navigate_to_path(scene_path)
	ProjectSettings.set_setting("application/run/main_scene", scene_path)
	ProjectSettings.save()


func mark_as_completed(practice_name: String) -> void:
	if not _practice_to_item.has(practice_name):
		printerr(
			"Trying to update UIPracticeItem for practice '%s' but it was not found" % practice_name
		)
		return
	var instance: UIPracticeItem = _practice_to_item[practice_name]
	if instance.is_completed():
		return
	instance.mark_as_completed()
	_completed_practices += 1
	update_progress_display()


func _erase_progress() -> void:
	emit_signal("reset_progress_confirmed")
	for item in _practice_to_item.values():
		item.remove_completed_mark()
	_success_label.display("Progress reset successfully")
	_completed_practices = 0
	update_progress_display()


func _on_PollTimer_timeout() -> void:
	if _file.file_exists(COMPLETED_PATH):
		var error := _file.open(COMPLETED_PATH, File.READ)
		if error != OK:
			printerr("Could not open file '%s' to read newly completed practices." % COMPLETED_PATH)
			return

		var practice_names := _file.get_as_text().split("\n")
		for name in practice_names:
			if name.empty():
				break
			mark_as_completed(name)

		_file.close()
		var remove_error := _directory.remove(COMPLETED_PATH)
		if remove_error != OK:
			printerr("Could not delete file '%s' after consuming newly completed practices." % COMPLETED_PATH)
		


func _revert_practice(practice_name: String, scene: String) -> void:
	var success := _practice_reverter.revert(scene)
	if success:
		_success_label.display("Practice reverted successfully")
		_completed_practices -= 1
	else:
		_success_label.display("Practice could not be reverted", false)
	emit_signal("practice_state_reset", practice_name)

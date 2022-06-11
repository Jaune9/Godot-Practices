tool
extends Control

signal scene_open_requested
# Emitted when the user presses the revert button.
signal scene_revert_requested

const CHECKMARK_BULLET := preload("checkmark_none.svg")
const CHECKMARK_CHECKED := preload("checkmark_valid.svg")

const COLOR_CHECKED := Color(0.239216, 1, 0.431373)

onready var _label := $Row/Panel/Row/Label as Label
onready var _icon := $Row/Panel/Row/Icon as TextureRect

onready var _scene_button := $Row/Panel/SceneButton as Button
onready var _revert_button := $Row/RevertButton as Button

onready var _confirm_dialog := $ConfirmationDialog


func _ready() -> void:
	_confirm_dialog.set_as_toplevel(true)

	_scene_button.connect("pressed", self, "emit_signal", ["scene_open_requested"])
	_revert_button.connect("pressed", _confirm_dialog, "popup_centered")
	_confirm_dialog.connect("confirmed", self, "emit_signal", ["scene_revert_requested"])
	_confirm_dialog.connect("confirmed", self, "remove_completed_mark")


func setup(text: String, completed := false) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	_label.text = text
	_confirm_dialog.dialog_text = _confirm_dialog.dialog_text % text
	if completed:
		mark_as_completed()


func mark_as_completed() -> void:
	_icon.texture = CHECKMARK_CHECKED
	_icon.modulate = COLOR_CHECKED


func remove_completed_mark() -> void:
	_icon.texture = CHECKMARK_BULLET
	_icon.modulate = Color.white


func is_completed() -> bool:
	return _icon.texture == CHECKMARK_CHECKED

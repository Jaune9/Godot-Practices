extends Panel

export var character_stats: Resource = null

onready var strength_spinbox := $VBoxContainer/HBoxContainer/StrengthSpinBox
onready var endurance_spinbox := $VBoxContainer/HBoxContainer2/EnduranceSpinBox
onready var intelligence_spinbox := $VBoxContainer/HBoxContainer3/IntelligenceSpinBox


func _ready() -> void:
	strength_spinbox.connect("value_changed", self, "_on_StrengthSpinBox_value_changed")
	endurance_spinbox.connect("value_changed", self, "_on_EnduranceSpinBox_value_changed")
	intelligence_spinbox.connect("value_changed", self, "_on_IntelligenceSpinBox_value_changed")


func _on_StrengthSpinBox_value_changed(new_value: int) -> void:
	character_stats.strength = new_value


func _on_EnduranceSpinBox_value_changed(new_value: int) -> void:
	character_stats.endurance = new_value


func _on_IntelligenceSpinBox_value_changed(new_value: int) -> void:
	character_stats.intelligence = new_value

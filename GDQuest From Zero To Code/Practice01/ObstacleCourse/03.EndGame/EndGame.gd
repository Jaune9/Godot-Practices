extends YSort

onready var godot: KinematicBody2D = $Godot
onready var robot_statue: Area2D = $RobotStatue

# Make this screen visible when touching the statue.
onready var finish_screen: Control = $CanvasLayer/FinishScreen


func _ready() -> void:
	pass


func _on_RobotStatue_body_entered(body: Node) -> void:
	pass

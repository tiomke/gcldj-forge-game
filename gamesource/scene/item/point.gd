extends Control

@onready var pointNode = %Point
@onready var animation_player :AnimationPlayer= %AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

	
func set_point(point):
	pointNode.text = str(point)
	
func shake():
	animation_player.play("point_shake")


func _on_button_pressed():
	shake()


func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.

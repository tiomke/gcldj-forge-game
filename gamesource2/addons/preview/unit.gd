@tool
class_name Unit extends VBoxContainer

@export var _title:String

var hp:
	set(_hp):
		%Hp.text = str(_hp)

var attack:
	set(_attack):
		%Attack.text = str(_attack)

var defend:
	set(_defend):
		%Defend.text = str(_defend)
#func _process(delta):
	#print("run _process")
	
func _init():
	print("unit.gd:_init")
# Called when the node enters the scene tree for the first time.
func _ready():
	print("unit.gd:_ready")
	if Engine.is_editor_hint():
		print("run in editor")
	%Desc.text = _title
	%Hp.text = "0"
	%Attack.text = "0"
	%Defend.text = "0"

	

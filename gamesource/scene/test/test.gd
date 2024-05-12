extends Node2D


var tween
var bflag
# Called when the node enters the scene tree for the first time.
func _ready():
	PubSub.sub("test_button_press",Callable(self,"pressed"))
	#tween = create_tween()
	do_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func do_tween():
	tween = create_tween().set_loops()
	tween.tween_property($VBoxContainer/Sprite2D,"position",Vector2(100,100),1)
	tween.tween_interval(0.5)
	tween.tween_property($VBoxContainer/Sprite2D,"position",Vector2(120,120),1)
	prints("is running",tween.is_running())

func pressed(args):
	prints("pressed>>",args)
	if bflag:
		bflag = false
		do_tween()
	else:
		bflag = true
		tween.stop()
	#var tween = create_tween()
	#tween.tween_property($VBoxContainer/Sprite2D,"position",Vector2(100,100),1)
	#tween.tween_interval(0.5)
	#tween.tween_property($VBoxContainer/Sprite2D,"position",Vector2(120,120),1)
	#prints("is running",tween.is_running())
	

func _on_button_pressed():
	print("_on_button_pressed")
	PubSub.pub("test_button_press",{"test":998})

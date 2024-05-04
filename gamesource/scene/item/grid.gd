class_name Grid extends Control

@onready var num :Label= $MarginContainer/Num
@onready var img :TextureRect= $MarginContainer/MarginContainer/Img
@onready var frame = $Frame
@onready var background = $MarginContainer/Background
@onready var select = $Select

# Called when the node enters the scene tree for the first time.
func _ready():
	num.text=""
	img.texture = null
	select.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_num(value):
	num.text = value

func set_grade(grade):
	var level = C.ROAMAN_NUM_LIST[grade]
	num.text = level

func set_img(texture:Texture2D):
	img.texture = texture


func set_frame_color(color):
	frame.color = color

func set_background_color(color):
	background.color = color

func enable_select(bSelect):
	select.visible = bSelect

class_name Grid extends Control

@onready var num :Label= $MarginContainer/Num
@onready var img :TextureRect= $MarginContainer/MarginContainer/Img
@onready var frame = $Frame
@onready var background = $MarginContainer/Background
@onready var select = $Select
@onready var back_img = $MarginContainer/BackImg
@onready var button = $Button
@onready var mask = $Mask


@export var _selectType:C.GridSelectType
@export var _parent:Control
@export var _disable:bool
@export var _bSelectDisable:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	num.text=""
	img.texture = null
	select.visible = false
	disable(_disable)
	if _bSelectDisable:
		print("button select disabled!")
		button.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_select_type(eType):
	_selectType = eType
	
func set_num(value):
	num.text = str(value)

func set_grade(grade):
	var level = C.ROAMAN_NUM_LIST[grade]
	num.text = level

func set_img(path):
	var texture = ResourceLoader.load(path)
	if texture == null:
		C.dprint("debug","Grid:set_img>> fail to load texture:{0}".format([path]))
	img.texture = texture
	
func set_backimg(path):
	var texture = ResourceLoader.load(path)
	if texture == null:
		C.dprint("debug","Grid:set_backimg>> fail to load texture:{0}".format([path]))
	back_img.texture = texture


func set_frame_color(color):
	frame.color = color

func set_background_color(color):
	background.color = color

func enable_select(bSelect):
	select.visible = bSelect

func disable_select():
	_bSelectDisable = true
	button.disabled = true
	
func disable(bDisable=true):
	button.disabled = bDisable
	mask.visible = bDisable

#region 
# load planet
func show_planet_img(idx,bPirate=false):
	var path = "res://res/img/planet/{0}.png".format([idx])
	if bPirate:
		path = "res://res/img/planet/pirate.png"
	set_img(path)
	
# load unit
func show_unit_img(tid):
	var data = Design.getcfg("unit",tid)
	set_img(data["Path"])
	
# load gem	
func show_gem_img(tid):
	var data = Design.getcfg("gem",tid)
	set_img(data["Path"])
	
# load blueprint
func show_blueprint_img(tid):
	var data = Design.getcfg("blueprint",tid)
	if data["Type"] != "wash":
		var unitTid = data["RelateKey"]
		var unitData = Design.getcfg("unit",unitTid)
		set_backimg(data["BackgroundPath"])
		set_img(unitData["Path"])
	else:
		set_img("res://res/img/reset.png")
#endregion


func _on_button_pressed():
	C.dprint("debug","Grid:_on_button_pressed>>")
	if _bSelectDisable:
		C.dprint("debug","Grid:_on_button_pressed>>select disabled")
		return
	if !button.button_pressed: # 如果这次是取消按下，那么就不再选中
		G.CrntSelectGrid = null
		enable_select(false)
		return
	var old = G.CrntSelectGrid
	if old != null:
		old.enable_select(false)
	enable_select(true)
	G.CrntSelectGrid = self
	C.dprint("debug","Grid:_on_button_pressed>>CrntSelectGrid:",G.CrntSelectGrid)

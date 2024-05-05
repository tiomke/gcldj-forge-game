extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var scene = preload("res://scene/item/grid.tscn") 
	var node :Grid= scene.instantiate()
	var node2 :Grid= scene.instantiate()
	add_child(node)
	add_child(node2)
	
	node.set_frame_color(Color(0.9,0.9,0))
	node.set_background_color(Color(0.5,0.5,0))
	var tex = preload("res://addons/gloot/images/icon_item_slot.svg")
	node.set_img(tex)
	var tex2 = preload("res://res/img/gem/blue.png")
	node2.set_img(tex2)
	node2.enable_select(true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

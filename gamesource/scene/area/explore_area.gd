class_name ExploreArea extends CenterContainer

@onready var container = %HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# 清理所有节点
func clear_planets():
	for child in container.get_children():
		container.remove_child(child)
# 添加星球
func add_planet(node):
	container.add_child(node)


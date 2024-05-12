class_name FightListItem extends HBoxContainer

@onready var unit_grid :Grid= %UnitGrid
@onready var attack = %Attack
@onready var point_list = [%Point1,%Point2,%Point3,%Point4,%Point5,%Point6]

var _maxSize = 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_unit(id):
	var unit = G.Player.get_unit(id) as Unit
	unit_grid.show_unit_img(unit.tid)
	attack.text = str(unit.fightscore)
	var prop :Dictionary= unit.fightprop
	for i in range(_maxSize):
		var point = prop.get(i)
		var pointNode = point_list[i]
		if point:
			pointNode.set_point(point)
			pointNode.visible = true
		else:
			pointNode.visible = false
	
func shake_all_point():
	for node in point_list:
		if node.visible:
			(node as Point).shake()
	
	

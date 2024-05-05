class_name ForgeArea extends CenterContainer

@onready var blueprint_grid = %BlueprintGrid
@onready var gem_container = %GemHBoxContainer
@onready var output_container = %OutputMarginContainer
@onready var output_planet_grid = %OutputPlanetGrid
@onready var need_unit_margin_container = %NeedUnitMarginContainer
@onready var need_unit_container = %NeedUnitHBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	G.ForgeAreaNode = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func assemble(nType:C.GridSelectType,tid):
	C.dprint("debug","Grid:assemble>>selectType,gridid",nType,tid)
	if nType == C.GridSelectType.PersonalBlueprint:
		assemble_blueprint(tid)
# 放入蓝图
func assemble_blueprint(tid):
	# 先隐藏输入
	for child in gem_container.get_children():
		child.visible = false
	# 显示蓝图按钮
	blueprint_grid.show_blueprint_img(tid)
	# 更新显示蓝图所需的宝石
	var data = Design.getcfg("blueprint",tid)
	var inputlist = data["InputGems"]
	var idx = 0
	for input:Array in inputlist:
		var needtid = input[0]
		var needcnt = input[1]
		var cnt = G.Player.get_gem_count(needtid)
		var child = gem_container.get_child(idx)
		child.visible = true
		child.show_gem_img(needtid)
		child.set_num("{0}/{1}".format([cnt,needcnt]))
		if cnt < needcnt:
			child.set_mask_color(Color(0.8,0,0))
	# 更新显示产物物品
	var outputTid = data["OutputId"]
	if outputTid:
		output_container.visible=true
		output_planet_grid.show_unit_img(outputTid)
	else:
		output_container.visible=false
	# 更新输入
	var inputunits = data["InputUnits"] as Array
	if inputunits.is_empty():
		need_unit_margin_container.visible = false
	else:
		need_unit_margin_container.visible = true
		for i in range(need_unit_container.get_child_count()):
			var node = need_unit_container.get_child(i)
			node.visible = i < inputunits.size()

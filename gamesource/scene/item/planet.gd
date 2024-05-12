class_name Planet extends MarginContainer

@onready var planet_name = %Name
@onready var planet_grid :Grid= %PlanetGrid
@onready var gem_list = %GemList

var _gemlist
var _blueprintlist
var _name:=""
var _idx:=0

var idx:
	get:
		if _idx == 0:
			_idx = randi_range(1,36) # TODO 配表
		return _idx

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_planetname(name):
	_name=name
func set_blueprintlist(list):
	_blueprintlist = list	
func set_gemlist(list):
	_gemlist = list
func update_info():
	planet_name.text = _name
	planet_grid.show_planet_img(idx)
	for child in gem_list.get_children():
		gem_list.remove_child(child)
	for value in _gemlist:
		var tid = value[0]
		var num = value[1]
		var grid = G.GridScn.instantiate() as Grid
		gem_list.add_child(grid)
		grid.set_select_type(C.GridSelectType.ExploreGem)
		grid.set_num(num)
		grid.show_gem_img(tid)
func set_enemy_base():
	planet_name.text += "（海盗）"
	planet_grid.set_img("res://res/img/enemybase.png")
	planet_grid.set_planet_type(PlanetGrid.PlanetType.Enemy)
	
# 把物品掉落给玩家
func drop_item():
	C.dprint("debug","Planet:drop_item>>")
	var list = []
	for value in _gemlist:
		var tid = value[0]
		var num = value[1]
		C.dprint("debug","Planet:drop_item>>gem:tid,num",tid,num)
		G.Player.add_gem(tid,num)
		var ttid = Design.get_tid("gem",tid)
		var cfg = Design.getcfg("gem",tid)
		var name = cfg["Name"]
		list.append({"ttid":ttid,"tid":tid,"name":name})
	for tid in _blueprintlist:
		C.dprint("debug","Planet:drop_item>>blueprint:tid",tid)
		G.Player.add_blueprint(tid)
		var ttid = Design.get_tid("blueprint",tid)
		var cfg = Design.getcfg("blueprint",tid)
		var name = cfg["Name"]
		list.append({"ttid":ttid,"tid":tid,"name":name})
	PubSub.pub(EPubSub.GetItem,{"list":list})
	

extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# 添加一些默认资源
	var player :Personal = G.Player
	player.add_blueprint("HuWei")
	#player.add_unit("HuWeiJian")
	player.add_gem("BlueStone")
	player.add_gem("RedStone")

	# 尝试合成
	var bp = Blueprint.new()
	bp.craft("HuWei")
	print(player._unitDict)


extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# 添加一些默认资源
	var player :Personal = G.Player
	player.add_blueprint("ji_feng")
	#player.add_unit("HuWeiJian")
	player.add_gem("blue_green",10)
	player.add_gem("amber",10)
	#player.add_gem("black",10)

	# 尝试合成
	var bp = Blueprint.new()
	bp.craft("gang_tie")
	print(player._unitDict)


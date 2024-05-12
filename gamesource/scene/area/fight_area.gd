class_name FightArea extends CenterContainer

@onready var fight_unit_list = [%FightUnit1,%FightUnit2,%FightUnit3]
@onready var fight_unit_1 = %FightUnit1
@onready var fight_unit_2 = %FightUnit2
@onready var fight_unit_3 = %FightUnit3
@onready var enemy_hp = %EnemyHp
@onready var enemy_grid = %EnemyGrid

var _enemyBasePath = "res://res/img/enemybase.png"
var _enemyPlanetPath = "res://res/img/planet/pirate.png"

#region 战斗逻辑

#endregion

#region 展示区域
func set_enemy(hp,bBoss=false):
	enemy_hp.text = str(hp)
	if bBoss:
		enemy_grid.set_img(_enemyPlanetPath)
	else:
		enemy_grid.set_img(_enemyBasePath)

func update_enemy_hp(hp):
	enemy_hp.text = hp

func set_fight_units(idlist:Array):
	idlist.resize(3)
	for i in range(3):
		var fightUnit = fight_unit_list[i]
		var id = idlist[i]
		if id :
			fightUnit.set_unit(id)
			fightUnit.visible = true
		else:
			fightUnit.visible = false
#endregion


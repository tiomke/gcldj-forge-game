class_name FightArea extends CenterContainer

@onready var fight_unit_list = [%FightUnit1,%FightUnit2,%FightUnit3]
@onready var enemy_hp = %EnemyHp
@onready var enemy_grid = %EnemyGrid
@onready var enemy_target_anim = %EnemyTargetAnim


var _enemyBasePath = "res://res/img/enemybase.png"
var _enemyPlanetPath = "res://res/img/planet/pirate.png"

func _ready():
	#init_fight_tween()
	PubSub.sub(EPubSub.Fight_Fail,Callable(self,"on_fail"))
	#PubSub.sub(EPubSub.Fight_HitEnemyDone,Callable(self,"on_hit_done"))
#region 战斗逻辑

#endregion

#region 展示区域
var _fight_id_list:Array
var _crnt_fight_unit_idx:int
var _crnt_harm:int

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
	_fight_id_list = idlist
	for i in range(3):
		var fightUnit = fight_unit_list[i]
		var id = idlist[i]
		if id :
			fightUnit.set_unit(id)
			fightUnit.visible = true
		else:
			fightUnit.visible = false
#endregion

#region Animation 战斗动画

var fightTween:Tween
#func init_fight_tween():
	#fightTween = create_tween()
func stop_fighting_anim():
	fightTween.stop()
	
func play_fighting_anim():
	_crnt_fight_unit_idx = 0
	play_unit_animation()

func on_hit_done():
	_crnt_fight_unit_idx += 1
	play_unit_animation()
	
func on_fail():
	stop_fighting_anim()

# 播放当前单位的动画
func play_unit_animation():
	var idx = _crnt_fight_unit_idx
	var node = fight_unit_list[idx]
	var id = _fight_id_list[idx]
	var unit = G.Player.get_unit(id) as Unit
	if !unit:
		PubSub.pub(EPubSub.Fight_Fail,{"reson":"no unit","idx":idx})
		return
	(node as FightListItem).shake_all_point()
	fightTween = create_tween()
	fightTween.tween_interval(0.5)
	
	#fightTween.tween_callback(func():PubSub.pub(EPubSub.Fight_HitEnemy,{"harm":unit.fightscore}))
	fightTween.tween_callback(func():enemy_target_anim.play("hit"))
	_crnt_harm = unit.fightscore

#endregion


func _on_enemy_target_anim_animation_finished(anim_name):
	if anim_name == "hit":
		var ori_hp = int(enemy_hp.text)
		var new_hp = maxi(0,ori_hp-_crnt_harm)
		fightTween = create_tween()
		fightTween.tween_method(func(val): enemy_hp.text = str(val),ori_hp,new_hp,0.5)
		await fightTween.finished
		if new_hp == 0:
			enemy_target_anim.play("die")
		else:
			on_hit_done()
			
	elif  anim_name == "die":
		print("PubSub.pub(EPubSub.Fight_Win)")
		PubSub.pub(EPubSub.Fight_Win)
		
		

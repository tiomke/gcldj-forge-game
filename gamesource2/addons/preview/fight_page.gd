class_name FightPage extends VBoxContainer

@onready var player_area = %PlayerArea
@onready var enemy_area = %EnemyArea
@onready var card_list = [%Card1,%Card2,%Card3,%Card4,%Card5]
#@onready var point = %Point
#@onready var card_num = %CardNum

var point:
	set(v):
		%Point.text = "可用点数："+str(v)
var cardNum:
	set(v):
		%CardNum.text = "卡牌数量："+str(v)

# 修改的卡片索引；对应的卡牌id，卡牌描述
func set_card(idx,id,desc):
	print("fight_page.gd:set_card")
	card_list[idx].set_info(id,desc)

func _on_turn_end_button_pressed():
	PubSub.pub(PubSub.Key.EndTurn)

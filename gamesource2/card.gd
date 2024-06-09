extends Button

var _cardid=0


func _ready():
	self.pressed.connect(_on_pressed)

func set_info(id,desc):
	#print("card:set_info>>id,desc",id,desc)
	disabled = false
	_cardid = id
	text = str(desc)

# 消耗掉卡牌
func _on_pressed():
	disabled = true
	PubSub.pub(PubSub.Key.ApplyCard,{"id":_cardid,"wnd":self})
	

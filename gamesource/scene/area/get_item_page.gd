extends CenterContainer

@onready var title = %Title
@onready var itemlist = [%GetItem1,%GetItem2,%GetItem3]

func set_title(name):
	title.text = name

func set_item(index,name,selectType,tid,id):
	itemlist[index].set_item(name,selectType,tid,id)

func _on_close_button_pressed():
	self.visible = false

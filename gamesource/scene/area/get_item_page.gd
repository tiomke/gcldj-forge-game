extends CenterContainer

@onready var title = %Title
@onready var itemlist = [%GetItem1,%GetItem2,%GetItem3]

func set_title(name):
	title.text = name

# [{ttid,tid,name},...]
func set_items(list:Array):
	prints("GetItemPage:set_items>>list",list)
	list.resize(3) # TODO 实际给的物品可能超过3个
	var cnt = 0
	for dict in list:
		if dict:
			var ttid = dict["ttid"]
			var name = dict["name"]
			itemlist[cnt].visible=true
			var node = (itemlist[cnt] as Node)
			var grid = node.get_node("%Grid")
			grid.show_img(ttid)
			var label = node.get_node("%Label") as Label
			label.text = name
		else:
			itemlist[cnt].visible=false
		cnt += 1
			
		
		
func set_item(index,name,selectType,tid,id):
	itemlist[index].set_item(name,selectType,tid,id)

func _on_close_button_pressed():
	self.visible = false

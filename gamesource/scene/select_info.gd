extends VBoxContainer

@onready var nameTxt = $Name
@onready var descTxt = $MarginContainer/Desc

func set_title(txt):
	nameTxt.text = txt
	
func set_desc(txt):
	descTxt.text = txt

func show_desc(selectType:C.GridSelectType,tid,id=0):
	if tid.is_empty():
		return
	var tp = C.GridSelectType
	if selectType == tp.PersonalUnit or selectType == tp.ForgeUnit or selectType == tp.FightUnit:
		var data = Design.getcfg("unit",tid)
		var unit = G.Player.get_unit(id)
		var grade = C.ROAMAN_NUM_LIST[unit.grade]
		set_title("{0}·{1}级".format([data["Name"],grade]))
		var dict = unit.fightprop
		var score = unit.fightscore
		var sType = data["Type"]
		var typeName = C.UNIT_TYPE_NAME_DICT.get(sType)
		set_desc("{0}型战舰\n战舰战力：{1}\n战舰能力值：{2}\n注：数字越大，相同数字越多，战力越强；不同类型的战舰之间存在克制关系".format([typeName,score,str(dict.values())]))
	elif  selectType == tp.ExploreGem or selectType == tp.ForgeGem or selectType == tp.PersonalGem:
		var data = Design.getcfg("gem",tid)
		set_title(data["Name"])
		set_desc("收集更多宝石来锻造你心仪的战舰吧！")
	elif selectType == tp.ForgeBlueprint or selectType == tp.PersonalBlueprint:
		var data = Design.getcfg("blueprint",tid)
		set_title(data["Name"])
		var sType = data["Type"]
		var desc = "基础蓝图"
		if sType == "levelup":
			desc = "进阶蓝图，需要消耗低阶战舰才能合成对应战舰"
		elif sType == "gradeup":
			desc = "升级蓝图，对现有战舰进行升级改造，提升战力"
		elif sType == "wash":
			desc = "精密蓝图，从机器人海盗中获得，机器人的控制芯片，使用后可能会提升战力，也可能降低"
		set_desc("{0}\n拥有蓝图才能建造对应的战舰。探索星球或者击败海盗都有几率掉落蓝图。".format([desc]))
		
		

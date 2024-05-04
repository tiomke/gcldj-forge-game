extends Node2D


func _ready():
	#var example = preload("res://res/design/unit-data.csv")
	#example.setup() # 需要手动setup，否则不会加载数据
	#print(example.records)
	#print(example.keys())
	#var shooter = example.fetch(1000001)#fetch row data by primary key
	#print(shooter)
	#print(example.fetch("RedStone"))
	#var data = Design.getcfg("unit","RedStone")
	var data = Design.getcfg("blueprint","ji_feng")
	print(data)
	var list = data["InputGems"]
	print("list[0][0]==blue_green",list[0][0]=="blue_green")
	C.dprint("debug","debug print")
	#print(data.InputIds[0])
	#var data = Design.getcfg("unit",1001001)

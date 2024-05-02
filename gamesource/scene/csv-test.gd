extends Node2D


func _ready():
	var example = preload("res://res/design/unit-data.csv")
	example.setup() # 需要手动setup，否则不会加载数据
	print(example.records)
	print(example.keys())
	var shooter = example.fetch(1000001)#fetch row data by primary key
	print(shooter)

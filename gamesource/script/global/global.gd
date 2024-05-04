extends Node

var Player:Personal


# 一些全局初始化工作都放这里
func _init():
	C.dprint("debug","init Global")
	Player = Personal.new()
	

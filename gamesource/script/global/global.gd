extends Node


var Player:Personal
var CrntSelectGrid:Grid

@onready var PlanetScn:=preload("res://scene/item/planet.tscn")
@onready var GridScn:=preload("res://scene/item/grid.tscn")

# 一些全局初始化工作都放这里
func _init():
	C.dprint("debug","init Global")
	Player = Personal.new()
	

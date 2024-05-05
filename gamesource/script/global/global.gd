extends Node


var Player:Personal
var CrntSelectGrid:Grid
# var ForgeAreaNode:ForgeArea
#var GameplayNode:Gameplay

@onready var PlanetScn:=preload("res://scene/item/planet.tscn")
@onready var GridScn:=preload("res://scene/item/grid.tscn")

# 一些全局初始化工作都放这里
func _init():
	C.dprint("debug","init Global")
	Player = Personal.new()

func get_gameplay_node():
	return get_tree().get_root().get_node("Demo")

func get_forge_area():
	var play = get_gameplay_node()
	return play.get_node("%ForgeArea")


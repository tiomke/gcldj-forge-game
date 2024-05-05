class_name Gameplay extends Control

@onready var forge_area = %ForgeArea
@onready var explore_area :ExploreArea= %ExploreArea
@onready var main_tab_container = %MainTabContainer
@onready var button_1 = %Button1
@onready var button_2 = %Button2

# 玩家拥有蓝图区域
@onready var blueprint_tab_bar = %BlueprintTabBar
@onready var blueprint_tab_container = %BlueprintTabContainer
@onready var craft_container = $Container/VBoxContainer/CenterContainer2/VBoxContainer/BlueprintTabContainer/MarginContainer/GridContainer
@onready var gradeup_container = $Container/VBoxContainer/CenterContainer2/VBoxContainer/BlueprintTabContainer/MarginContainer2/GridContainer
@onready var wash_container = $Container/VBoxContainer/CenterContainer2/VBoxContainer/BlueprintTabContainer/MarginContainer3/GridContainer
# 玩家拥有宝石区域
@onready var gem_container = $Container/VBoxContainer/MarginContainer/GridContainer
# 玩家拥有战舰区域
@onready var speed_container = %SpeedHBoxContainer
@onready var heavy_container = %HeavyHBoxContainer
@onready var strategy_container = %StrategyHBoxContainer


enum Stage{
	Explore = 0, # 采集
	Forge, # 锻造
	Fight, # 战斗
}

var _crntStage:=Stage.Explore
var _crntRound:=1 # 轮次，一次海盗算一个轮次
var _crntTurn:=1 # 回合，一次选择算一个回合
# var _crntPlanets

#region Agenda 流程控制
	
func agenda_new_round():
	pass
	
func agenda_new_turn():
	agenda_enter_planet()

func agenda_enter_planet():
	_crntStage = Stage.Explore
	# 切页
	switch_play_area()
	update_button()
	# 生成新的行星信息并显示相应页面
	explore_area.clear_planets()
	generate_planet(explore_area)
	
func agenda_enter_forge():
	_crntStage = Stage.Forge
	switch_play_area()
	update_button()
	# 生成锻造信息
	# TODO
	pass

func agenda_enter_fight():
	pass

#endregion


#region Explore 探索

func generate_planet(exploreArea:ExploreArea):
	# 确定行星数量
	var planet_num = randi_range(1,Design.MAX_PLANET_NUM)
	for i in range(planet_num):
		var name = Design.generate_planet_name()
		var gemlist = Design.generate_planet_gems(_crntRound,_crntTurn)
		var blueprintlist = Design.generate_planet_blueprint(_crntRound,_crntTurn)
		var planet = G.PlanetScn.instantiate() as Planet
		planet.set_planetname(name)
		planet.set_gemlist(gemlist)
		planet.set_blueprintlist(blueprintlist)
		exploreArea.add_planet(planet)
		planet.update_info()

# 
func exec_explore():
	C.dprint("debug","Gameplaye:exec_explore>>")
	var selectGrid = G.CrntSelectGrid
	# 判断选择的内容 CrntSelectGrid
	if !selectGrid:
		C.dprint("debug","Gameplaye:exec_explore>>nothing selected")
		return
	if selectGrid._selectType == C.GridSelectType.ExplorePlanet:
		selectGrid.get_parent_node().drop_item()
		update_personal_info()
		agenda_enter_forge()

#endregion

#region Forge
func exec_forge():
	forge_area.forge()
	update_personal_info()
#endregion
#region Fight
func exec_fight():
	pass
#endregion


func personal_init_gems():
	for i in range(Design.GEM_TYPE_NUM):
		var tid = Design.GEM_BASE_TID + i + 1
		var key = Design.get_key("gem",tid)
		G.Player.add_gem(key,10)
	
func switch_play_area():
	main_tab_container.current_tab = _crntStage

func update_personal_info():
	# 蓝图
	update_personal_blueprint()
	update_personal_gem()
	update_personal_unit()
	pass # TODO
	
func update_personal_blueprint():
	C.dprint("debug","gameplay:update_personal_blueprint>>")
	var tabidx = blueprint_tab_bar.current_tab
	if tabidx == 0: # 铸造
		for i in range(craft_container.get_child_count()):
			var child = craft_container.get_child(i)
			var baseId = Design.BLUEPRINT_TYPE_NUM["craft"][0]
			var nsize = Design.BLUEPRINT_TYPE_NUM["craft"][1]
			var bias = i+1
			if bias > nsize:
				baseId = Design.BLUEPRINT_TYPE_NUM["levelup"][0]
				bias -= nsize
			baseId+=bias
			var key = Design.get_key("blueprint",baseId)
			var bOwn = G.Player.has_blueprint(key)
			child.disable(!bOwn)
			child.show_blueprint_img(key)
	elif  tabidx == 1: # 升级
		for i in range(gradeup_container.get_child_count()):
			var child = gradeup_container.get_child(i)
			var baseId = Design.BLUEPRINT_TYPE_NUM["gradeup"][0]
			baseId+=i+1
			var key = Design.get_key("blueprint",baseId)
			var bOwn = G.Player.has_blueprint(key)
			child.disable(!bOwn)
			child.show_blueprint_img(key)
	elif tabidx == 2: # 重置
		var baseId = Design.BLUEPRINT_TYPE_NUM["wash"][0]+1
		var key = Design.get_key("blueprint",baseId)
		var bOwn = G.Player.has_blueprint(key)
		var child = wash_container.get_child(0)
		child.disable(!bOwn)
		child.show_blueprint_img(key)
	
func update_personal_gem():
	C.dprint("debug","gameplay:update_personal_blueprint>>")
	for i in range(gem_container.get_child_count()):
		var child = gem_container.get_child(i)
		var tid = Design.GEM_BASE_TID+i+1
		var key = Design.get_key("gem",tid)
		child.show_gem_img(key)
		var cnt = G.Player.get_gem_count(key)
		child.set_num(cnt)
			
func update_personal_unit():
	# 先清空
	for child in speed_container.get_children():
		speed_container.remove_child(child)
	for child in heavy_container.get_children():
		heavy_container.remove_child(child)
	for child in strategy_container.get_children():
		strategy_container.remove_child(child)
	# 重刷
	var speedlist:=[]
	var heavylist:=[]
	var strategylist:=[]
	for unit in G.Player._unitDict.values():
		var data = Design.getcfg("unit",unit.tid)
		var unitType :String= data["Type"]
		if unitType == "speed":
			speedlist.append(unit)
		elif unitType == "heavy":
			heavylist.append(unit)
		elif unitType == "strategy":
			strategylist.append(unit)
	speedlist.sort_custom(func(a, b): return a._fightscore > b._fightscore)
	heavylist.sort_custom(func(a, b): return a._fightscore > b._fightscore)
	strategylist.sort_custom(func(a, b): return a._fightscore > b._fightscore)
	
	add_personal_unit(speedlist,speed_container)
	add_personal_unit(heavylist,heavy_container)
	add_personal_unit(strategylist,strategy_container)

func add_personal_unit(list,container):
	for unit in list:
		var grid = G.GridScn.instantiate() as Grid
		container.add_child(grid)
		grid.set_select_type(C.GridSelectType.PersonalUnit)
		prints("grid,unit.tid",grid,unit.tid,unit.id)
		grid.show_unit_img(unit.tid)
		grid.set_id(unit.id)
	

func update_button():
	if _crntStage == Stage.Explore:
		button_1.text = "探索该行星"
		button_1.visible = true
		button_2.visible = false
	elif _crntStage == Stage.Forge:
		button_1.text = "锻造"
		button_1.visible = true
		button_2.text = "继续前行"
		button_2.visible = true
	elif _crntStage == Stage.Fight:
		button_1.text = "迎接挑战"
		button_1.visible = true
		button_2.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	#G.GameplayNode = self
	personal_init_gems() # 开门送宝石
	agenda_enter_planet()
	update_personal_info()


func _on_button_1_pressed():
	if _crntStage == Stage.Explore:
		exec_explore()
	elif _crntStage == Stage.Forge:
		exec_forge()
	elif _crntStage == Stage.Fight:
		exec_fight()
	


func _on_button_2_pressed():
	if _crntStage == Stage.Forge:
		agenda_new_turn()


func _on_blueprint_tab_bar_tab_changed(tab):
	blueprint_tab_container.current_tab = blueprint_tab_bar.current_tab
	update_personal_blueprint()

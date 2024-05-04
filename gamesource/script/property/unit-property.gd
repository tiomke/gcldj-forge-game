# unit 的存储结构

class_name UnitProperty

var _tid:String="" # 模板id
var _id:=0 # 实例id
var _fightProp:=[] # 战斗属性 [num1,num2,num3,...]
var _grade:=1 # 等级
var _level:=1 # 品阶
var _createtime:=0


func _init():
	reset()
	
func reset():
	_fightProp = []
	_grade = 1
	_level = 1
	_createtime = 0

func set_tid(tid):
	_tid = tid
	
func set_id(id):
	_id = id
	
func set_fightprop(index,value):
	_fightProp.insert(index,value)
func get_fightprop():
	return _fightProp
	
func set_createtime(time):
	_createtime = time

# 不传参数升一级，传参数则直接设置等级
func grade_up(grade=null):
	_grade = grade or (_grade + 1)
		
func level_up(level=null):
	_level = level or (_level + 1)
	
func serialize():
	pass
func deserialize():
	pass
	

	


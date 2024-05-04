# 作战单位，身上的点数及点数关系决定作战单位的战力

extends Entity

class_name Unit

#region 实例 Id 生成
static var _idSn:=0 # 实例化序列号

# 生成自增实例id
static var _sn:
	get:
		_idSn += _idSn
		return _idSn
#endregion

var _fightscore:=0 # 战力
var _property:UnitProperty # 存盘数据

#region property accessor
var id:
	get:
		return _property._id
var tid:
	get:
		return _property._tid
var grade:
	get:
		return _property._grade
var level:
	get:
		return _property._level
var createtime:
	get:
		return _property._createtime
var fightprop:
	get:
		return _property.get_fightprop()
#endregion

# 根据模板id实例化一个对象出来
func _init(tid):
	var time = G.now
	_property = UnitProperty.new()
	_property.set_createtime(time)
	_property.set_tid(tid)
	_property.set_id(_sn)
	_property.set_fightprop(1,1) # 初始 1,1 TODO 统一放到一个数值计算的地方
	_update_fightscore()


# 给随机的一个维度值加一
func upgrade():
	var prop :Array = _property.get_fightprop()
	var index = randi_range(1,prop.size())
	_property.grade_up()
	_property.set_fightprop(index,prop[index]+1)
	_update_fightscore()

# 洗配置（将一部分数值从一个维度向另一个维度转移
# 存在洗配置前后点数不变的情况
func wash():
	var prop:Array=_property.get_fightprop()
	var list = G.randfetch(prop.size(),2)
	var prevalue1 = prop[list[0]]
	var prevalue2 = prop[list[1]]
	var retain = randf_range(1,prevalue1) # 原位置至少保留一点
	_property.set_fightprop(list[0],retain)
	_property.set_fightprop(list[1],prevalue2-(prevalue2-retain))
	_update_fightscore()

# 更新战斗力
func _update_fightscore():
	# 单牌 1*1 ，对子 10*2，三条 20*3，四条 30*5  （这里假设单牌数字不超过10
	var chiplist := [[1,1],[10,2],[20,3],[30,5]]
	# 筹码*倍率
	var prop = _property.get_fightprop()	
	var dict := {} # [num]=cnt,统计各个面值的数量
	for num in prop:
		dict[num] = (dict[num] or 0) + 1
	var fightscore = 0
	for num in dict.keys():
		var cnt = dict[num]
		var chip = chiplist[cnt]
		fightscore += (chip[0]+num*cnt)*chip[1] # 筹码累加，倍率相乘
	_fightscore = fightscore







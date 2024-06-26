class_name C

enum GridSelectType{
	PersonalBlueprint, # 玩家拥有的蓝图
	PersonalGem, # 玩家的宝石列表
	PersonalUnit, # 玩家拥有的战舰
	ExplorePlanet, # 探索时的星球
	ExploreGem, # 探索时的宝石
	ForgeUnit, # 锻造时的战舰
	ForgeGem,# 锻造时的宝石
	ForgeBlueprint,# 锻造时的蓝图
	ForgeOutput,# 锻造的产出
	FightUnit,# 战斗时的单位
}

static var ROAMAN_NUM_LIST:=["0","I","II","III","IV","V","VI","VII","VIII","IX","X"]
static var UNIT_TYPE_NAME_DICT:={"speed":"敏捷","heavy":"重装","strategy":"诡谲"}
static func _static_init():
	dpset("debug") # 开启调试print
	dprint("debug","debug print open")
	
static var now:
	get:
		return Time.get_unix_time_from_system()

# 从 1-n 中随机选取k个值，返回一个list 
# generate by gpt-3.5
static func randfetch(n, k):
	var numbers = []
	for i in range(1, n + 1):
		numbers.append(i)

	var selectedNumbers = []
	for i in range(k):
		var index = randi() % numbers.size()
		var selectedNumber = numbers[index]
		selectedNumbers.append(selectedNumber)
		numbers[index] = numbers[numbers.size() - 1]
		numbers.pop_back()

	return selectedNumbers

#region 调试用print
static var _dpset:={}
static func dpset(key):
	_dpset[key]=true
static func dpunset(key):
	if not _dpset.has(key):
		return
	_dpset[key]=null
	
# 没找到不定参数如何定义，先临时处理
static func dprint(key,a=null,b=null,c=null,d=null,e=null,f=null,g=null,h=null,i=null,j=null,k=null,l=null,m=null,n=null):
	var tbl:Array=[a,b,c,d,e,f,g,h,i,j,k,l,m,n]
	var ret:=[]
	for v in tbl:
		if v != null:
			ret.append(v)
	if _dpset.has(key):
		print(", ".join(ret))
#endregion



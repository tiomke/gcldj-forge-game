class_name Design
# 加载策划表

# 策划表配置
#const DESIGNDATA_PATH_UNIT:String = "res://res/design/unit-data.csv"
#const DESIGNDATA_PATH_BLUEPRINT:String = "res://res/design/blueprint-data.csv"

const DesignDataFileTable = {
	"unit": "res://res/design/unit-data.csv", #DESIGNDATA_PATH_UNIT,
	"gem":"res://res/design/gem-data.csv",
	"blueprint": "res://res/design/blueprint-data.csv",#DESIGNDATA_PATH_BLUEPRINT
}

# 全局策划表
static var DesignData = {}

# 获取 tableName 表中键为 key 的记录
# 返回一个字典，字典中的键为列名，例如 {"Key":"Value",...}
static func getcfg(tableName, key):
	if not DesignData.has(tableName):
		return
	return DesignData[tableName].fetch(key)

static func get_tid(tableName,key):
	if not DesignData.has(tableName):
		return
	return DesignData[tableName].key2id(key)

static func get_key(tableName,tid):
	if not DesignData.has(tableName):
		return
	return DesignData[tableName].id2key(tid)

static func load_all_design_data():
	for designName in DesignDataFileTable.keys():
		var path = DesignDataFileTable[designName]
		var res = ResourceLoader.load(path)
		res.setup()
		DesignData[designName] = res
		
static func _static_init():
	load_all_design_data()


#region planet
const MAX_PLANET_NUM:=3 # 一回合内行星的数量上限
const GEM_TYPE_NUM:=9  # 宝石种类
const GEM_BASE_TID:=3000000 # 宝石id编号
const PLANET_NAMELIST:=["新伊卡鲁斯","塞拉菲斯","埃杜尔","阿玛尔","塔希提","卡尔","泰坦","亚历山大"
,"伊甸园","雷登","赛伯利亚","塔拉","艾达","萨尔","奥德赛","奥米斯特","帕尔维达","塞勒斯","塔拉金"
,"卡西","姆斯","伊娃","罗塔","艾玛","塞拉","奥斯卡","艾莉森","埃德加","欧文","塔伦"]
# craft levelup gradeup wash
const BLUEPRINT_TYPE_NUM:={
	"craft":[2000000,3,0.8], # id字段，记录条目数量，获得概率
	"levelup":[2001000,6,0.5],
	"gradeup":[2002000,9,0.8],
	"wash":[2003000,1,0.1]
}

static func generate_planet_name():
	var num = randi_range(1,110) # 星系编号
	var name = PLANET_NAMELIST.pick_random()
	return "M{0}·{1}星".format([num,name])

# 根据轮次和回合来确定行星的资源
# 返回 [[key,cnt],[key,cnt],...]
static func generate_planet_gems(nRound,turn)->Array:
	# TODO 需要确定具体轮次和回合跟资源的关系
	var cnt = randi_range(1,nRound*2+2)
	var list = C.randfetch(GEM_TYPE_NUM,3)
	var ret :=[]
	for gemidx in list:
		if cnt > 0:
			var id = GEM_BASE_TID+gemidx
			var key = get_key("gem",id)
			var num = randi_range(1,cnt)
			cnt -= num
			ret.append([key,num])
	return ret
# 返回 [key,key,...]
static func generate_planet_blueprint(nRound,turn)->Array:
	var ret := []
	for value in BLUEPRINT_TYPE_NUM.values():
		var id = value[0]
		var size = value[1]
		var rate = value[2]
		if randf() < rate :
			id += randi_range(1,size)
			var key = get_key("blueprint",id)
			ret.append(key)
	return ret
#endregion

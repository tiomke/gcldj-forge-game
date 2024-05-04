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

static func get_tbl(tableName):
	return DesignData[tableName]

# 获取 tableName 表中键为 key 的记录
# 返回一个字典，字典中的键为列名，例如 {"Key":"Value",...}
static func getcfg(tableName, key):
	if not DesignData[tableName]:
		return
	return DesignData[tableName].fetch(key)

static func get_tid(tableName,key):
	if not DesignData[tableName]:
		return
	return DesignData[tableName].id2key(key)

static func get_key(tableName,tid):
	if not DesignData[tableName]:
		return
	return DesignData[tableName].key2id(tid)

static func LoadAllDesignData():
	for designName in DesignDataFileTable.keys():
		var path = DesignDataFileTable[designName]
		var res = ResourceLoader.load(path)
		res.setup()
		DesignData[designName] = res
		
static func _static_init():
	LoadAllDesignData()


extends Node
# 加载策划表

# 策划表配置
#const DESIGNDATA_PATH_UNIT:String = "res://res/design/unit-data.csv"
#const DESIGNDATA_PATH_BLUEPRINT:String = "res://res/design/blueprint-data.csv"

const DesignDataFileTable = {
	"Unit": "res://res/design/unit-data.csv", #DESIGNDATA_PATH_UNIT,
	"BluePrint": "res://res/design/blueprint-data.csv",#DESIGNDATA_PATH_BLUEPRINT
}

# 全局策划表
static var DesignData = {}

func GetCfg(tableName, key):
	if not DesignData[tableName]:
		return
	return DesignData[tableName].fetch(key)

func LoadAllDesignData():
	for designName in DesignDataFileTable.keys():
		var path = DesignDataFileTable[designName]
		var res = ResourceLoader.load(path)
		res.setup()
		DesignData[designName] = res
		
func _ready():
	LoadAllDesignData()


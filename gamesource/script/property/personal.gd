extends Entity

class_name Personal

var _blueprintDict:={} # [tid]=true，蓝图没数量
var _gemDict:={} # [tid]=num，宝石只有数量，本身没别的属性
var _unitDict:={} # [id]=unit，玩家可以拥有同tid的不同属性作战单位


func reset():
	_blueprintDict={}
	_gemDict={}
	_unitDict={}
	
func add_blueprint(tid):
	_blueprintDict[tid]=true

#region 宝石操作
func add_gem(tid):
	_gemDict[tid]=(_gemDict[tid] or 0)+1
func get_gem_count(tid):
	if not _gemDict.get(tid):
		return 0
	return _gemDict[tid]
func set_gem_count(tid,cnt):
	_gemDict[tid]=cnt
#endregion

func add_unit(unit):
	_unitDict[unit.id]=unit
func rm_unit(unit):
	_unitDict[unit.id]=null
	

	

	






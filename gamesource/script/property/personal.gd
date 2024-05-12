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
func has_blueprint(tid):
	return true
	# return _blueprintDict.has(tid)
#region 宝石操作
func add_gem(tid,cnt=1):
	_gemDict[tid]=_gemDict.get(tid,0)+cnt
func get_gem_count(tid):
	return _gemDict.get(tid,0)
func set_gem_count(tid,cnt):
	_gemDict[tid]=cnt
#endregion

func add_unit(unit):
	_unitDict[unit.id]=unit
func rm_unit(unit):
	_unitDict[unit.id]=null
func get_unit(id):
	return _unitDict.get(id)
func get_units():
	return _unitDict.values()
	

	

	






# 蓝图，指导物品合成
class_name Blueprint extends Entity

# 物品合成
# unitlist 是传入的作战单位列表，这个接口假设传进来的
static func craft(blueprintTid,unitlist=[]):
	C.dprint("debug","blueprint:craft()>> bluprintTid:{0}".format([blueprintTid]))
	# 判断玩家是否拥有这个蓝图
	if not G.Player.has_blueprint(blueprintTid):
		C.dprint("debug","blueprint:craft()>>no bluprint:{0}".format([blueprintTid]))
		return false
	var designData = Design.getcfg("blueprint",blueprintTid)
	var sType = designData["Type"]
	# 判断作战单位的数量和id是否都符合
	var tidlist := []
	for unit in unitlist:
		tidlist.append(unit.tid)
	var inputunits = designData["InputUnits"]
	for needtid in inputunits:
		if not tidlist.has(needtid):
			C.dprint("debug","blueprint:craft()>>lack of unit",blueprintTid,needtid)
			return false
		tidlist.erase(needtid) # 从列表移除找到的第一个needtid
	
	# 如果 tidlist 正好删空，说明列表满足需求
	if not tidlist.is_empty():
		C.dprint("error","blueprint:craft()>>unit more than need",blueprintTid,str(tidlist))
		return false
			
	# 判断身上的宝石是否足够
	var inputlist = designData["InputGems"]
	for input:Array in inputlist:
		var needtid = input[0]
		var needcnt = input[1]
		var cnt = G.Player.get_gem_count(needtid)
		if cnt < needcnt:
			C.dprint("debug","blueprint:craft()>>lack of gem !! blueprintTid:{0},\
			gem key:{1},need gem cnt:{2},has gem cnt:{3}".format([blueprintTid,needtid,needcnt,cnt]))
			return false
	# 消耗宝石
	for input:Array in inputlist:
		var needtid = input[0]
		var needcnt = input[1]
		var cnt = G.Player.get_gem_count(needtid)
		G.Player.set_gem_count(needtid,cnt-needcnt)
	if sType == "craft" or sType == "levelup":
		# 消耗单位
		for unit in unitlist:
			G.Player.rm_unit(unit)
		# 合成新的物品
		var unitTid = designData["OutputId"]
		if unitTid and !unitTid.is_empty():
			var unit = Unit.new(unitTid)
			#print("unit.id",unit.id)
			G.Player.add_unit(unit)
			var ttid = Design.get_tid("unit",unitTid)
			var cfg = Design.getcfg("unit",unitTid)
			var name = cfg["Name"]
			PubSub.pub(EPubSub.GetItem,{"list":[{"ttid":ttid,"name":name,"tid":unitTid}]})
	elif sType == "gradeup":
		for unit in unitlist:
			unit.upgrade()
	elif sType == "wash":
		for unit in unitlist:
			unit.wash()

	return true
	
static func levelup(blueprintTid,unitlist=[]):
	pass

static func gradeup(blueprintTid,unitlist=[]):
	pass

static func wash(blueprintTid,unit):
	pass
	
	

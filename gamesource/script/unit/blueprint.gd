# 蓝图，指导物品合成

extends Entity

# 物品合成
# unitlist 是传入的作战单位列表，这个接口假设传进来的
func craft(blueprintTid,unitlist):
	var designData = Design.getcfg("blueprint",blueprintTid)
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
	var inputlist = designData.fetch("InputGems")
	for input:Array in inputlist:
		var needtid = input[0]
		var needcnt = input[1]
		var cnt = G.Player.get_gem_count(needtid)
		if cnt < needcnt:
			C.dprint("debug","blueprint:craft()>>lack of gem !! blueprintTid:{0},\
			gem key:{1},need gem cnt:{2},has gem cnt:{3}".format([blueprintTid,needtid,needcnt,cnt]))
			return false
	# 消耗单位和宝石
	for unit in unitlist:
		G.Player.rm_unit(unit)
	for input:Array in inputlist:
		var key = input[0]
		var needcnt = input[1]
		var tid = Design.get_tid("gem",key)
		var cnt = G.Player.get_gem_count(tid)
		G.Player.set_gem_count(tid,cnt-needcnt)
	# 合成新的物品
	var unitTid = designData["OutputId"]
	var unit = Unit.new(unitTid)
	G.Player.add_unit(unit)
	
	
	
	

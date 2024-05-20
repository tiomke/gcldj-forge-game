_SN = 0
function GenUnitSn()
    _SN = _SN + 1
    return _SN
end
CUnit = class()
RegMember(CUnit,"m_Id")
RegMember(CUnit,"m_Type")
RegMember(CUnit,"m_PointList")
RegMember(CUnit,"m_FightScore")

function CUnit:Ctor(unitType)
    self.m_Id = GenUnitSn()
    self.m_PointList = {}
    self.m_Type = unitType
end

local chiplist = {{1,1},{10,2},{20,3},{30,5}}
function CUnit:GetFightScore()
    -- 单牌 1*1 ，对子 10*2，三条 20*3，四条 30*5  （这里假设单牌数字不超过10
	-- 筹码*倍率
    local dict = {}
    for i,point in ipairs(self.m_PointList) do
        dict[point] = (dict[point] or 0) + 1
    end
    local score = 0
    for point,cnt in pairs(dict) do
        local chip,multi = unpack(chiplist[cnt])
        score = score + (chip+point*cnt)*multi
    end
    return score
end
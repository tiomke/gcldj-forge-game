
-- 双向映射
function dict2list(dict)
    local list = {}
    for key,idx in pairs(dict) do
        list[idx] = key
    end
    for k,v in pairs(list) do
        dict[k] = v
    end
end
-- region 全局数据
EGem = {
    Blue = 1,
    Yellow = 2,
    Red = 3,
}
dict2list(EGem)

EUnit = {
    Speed = 1,
    Heavy = 2,
    Strategy = 3,
}
dict2list(EUnit)

-- 探索时的出场阵容
EPlanet = {
    Planet = 1,
    Pirate = 2,
    Boss = 3,
}
dict2list(EPlanet)

-- 一回合内的不同操作阶段
EStage = {
    Select = 1, -- 做选择
    Fight = 2, -- 如果选的海盗需要战斗
    Forge = 3, -- 战斗完开始装配
    Finish = 4, -- 回合结束阶段（展示胜利失败）
}
dict2list(EStage)
-- endregion


-- region 数值设计
Cfg = {}
-- 关卡产出
Cfg.Level = {}
Cfg.Level.TurnNum = 5
Cfg.Level.RoundNum = 2
Cfg.Level.SelectNumPerTurn = 3 -- 每回合三个选项
Cfg.Level.GemNumPerPlanet = 3 -- 每个提供几个宝石
Cfg.Level.PirateAppearRateListPerRound = {0,0.5} -- 每一轮出现小海盗的几率
Cfg.Level.BossHpListPerRound = {5,10} -- 每一轮Boss的血量
Cfg.Level.Round={}
Cfg.Level.Round[2]={}
Cfg.Level.Round[2].PirateHpListPerTurn = {1,1,1,1,1} -- 每个回合小海盗的防御力（数组大小跟 TurnNum 有关）



-- 战舰合成
Cfg.Unit = {}
Cfg.Unit.Craft = {
    [EUnit.Speed]={[EGem.Blue]=2,[EGem.Yellow]=1},
    [EUnit.Heavy]={[EGem.Yellow]=2,[EGem.Red]=1},
    [EUnit.Strategy]={[EGem.Red]=2,[EGem.Blue]=1}
}
-- endregion

-- 当前的数据
-- region 玩家数据
PlayerInfo = {}
PlayerInfo.PlayInfo = {} -- 单次游戏的数据
PlayerInfo.PlayInfo.Units = {} -- {Id:{Type:EUnit,Points:[]}}
PlayerInfo.PlayInfo.Gems = {} -- {EGem:Count}
-- endregion

LevelInfo = {}
LevelInfo.CrntRound = 0 -- 1表示第一轮
LevelInfo.RoundInfo = {}
LevelInfo.RoundInfo.CrntTurn = 0
LevelInfo.RoundInfo.TurnInfo = {} -- PlanetList,Stage,SelectIndex


-- 生成行星的产出资源
-- @return table {EGem:count}
function gen_turn_gem()
    local ret = {}
    local remain = Cfg.Level.GemNumPerPlanet
    for typeIndex,typeName in ipairs(EGem) do
        if remain <= 0 then break end
        local cnt = math.random(0,remain)
        if typeIndex == #EGem then
            cnt = remain
        end
        if cnt > 0 then
            ret[typeIndex]=cnt
            remain = remain - cnt
        end
    end
    return ret
end
function gemlist_to_string(gemlist)
    local tbl = {}
    for typeIndex,typeName in ipairs(EGem) do
        local cnt = gemlist[typeIndex] or 0
        table.insert(tbl,EGem[typeIndex]..":"..cnt)
    end
    return table.concat(tbl,",")
end

-- region 关卡流程
function restart()
    PlayerInfo.PlayInfo = {}
    PlayerInfo.PlayInfo.Units = {} -- {Id:{Type:EUnit,Points:[]}}
    PlayerInfo.PlayInfo.Gems = {} -- {EGem:Count}
    LevelInfo.CrntRound = 0 -- 1表示第一轮
    LevelInfo.RoundInfo = {}
    LevelInfo.RoundInfo.CrntTurn = 0
    LevelInfo.RoundInfo.TurnInfo = {} -- PlanetList,Stage,SelectIndex
    next_round()
end

function next_round()
    if LevelInfo.CrntRound >= Cfg.Level.RoundNum then
        ShowMessage("You Win!!Pass all level!!","restart")
        return
    end
    LevelInfo.CrntRound = LevelInfo.CrntRound + 1
    LevelInfo.RoundInfo.TurnInfo = {}
    LevelInfo.RoundInfo.CrntTurn = 0
    next_turn()
end

function next_turn()
    -- 回合结束
    local crntTurn = LevelInfo.RoundInfo.CrntTurn
    if crntTurn == Cfg.Level.TurnNum then
        next_round()
        return
    end
    local nextTurn = crntTurn + 1
    local bGoLastTurn = crntTurn + 1 == Cfg.Level.TurnNum
    local planetList = {}
    if not bGoLastTurn then
        -- 随机出行星或者海盗
        local pirateRate = Cfg.Level.PirateAppearRateListPerRound[LevelInfo.CrntRound]
        local pirateNum = 0
        if math.random() < pirateRate then
            pirateNum = 1
            local roundCfg = Cfg.Level.Round[2]
            local hp = roundCfg and roundCfg.PirateHpListPerTurn[nextTurn]
            table.insert(planetList,{PlanetType=EPlanet.Pirate,GemList=gen_turn_gem(),Hp=hp})
        end

        local otherNum = Cfg.Level.SelectNumPerTurn - pirateNum
        for i=1,otherNum do
            table.insert(planetList,{PlanetType=EPlanet.Planet,GemList=gen_turn_gem()})
        end
    else
        local hp = Cfg.Level.BossHpListPerRound[LevelInfo.CrntRound]
        table.insert(planetList,{PlanetType=EPlanet.Boss,GemList=gen_turn_gem(),Hp=hp})
    end
    LevelInfo.RoundInfo.TurnInfo.PlanetList = planetList
    LevelInfo.RoundInfo.TurnInfo.Stage = EStage.Select
    LevelInfo.RoundInfo.CrntTurn = nextTurn
end

-- 选择对象
function stage_select(index)
    LevelInfo.RoundInfo.TurnInfo.SelectIndex = index
    local planet = LevelInfo.RoundInfo.TurnInfo.PlanetList[index]
    if planet.PlanetType == EPlanet.Planet then
        -- 给角色添加宝石
        local str = "Get Gem"
        for gemType,count in pairs(planet.GemList) do
            local precnt = PlayerInfo.PlayInfo.Gems[gemType] or 0
            PlayerInfo.PlayInfo.Gems[gemType] = precnt + count
            str = str ..","..EGem[gemType]..":"..count
        end
        ShowMessage(str)
        LevelInfo.RoundInfo.TurnInfo.Stage = EStage.Forge
    else
        LevelInfo.RoundInfo.TurnInfo.Stage = EStage.Fight
    end
end

-- 开始战斗
function stage_fight()
    local index = LevelInfo.RoundInfo.TurnInfo.SelectIndex
    local planet = LevelInfo.RoundInfo.TurnInfo.PlanetList[index]
    local pirateHp = planet.Hp
    -- 自动选参战单位
    local units = PlayerInfo.PlayInfo.Units
    local unitlist = {}
    for id,unit in pairs(units) do
        table.insert(unitlist,{id,unit:GetFightScore(),unit.m_PointList})
    end
    table.sort(unitlist,function(a,b) return a[2]>b[2] end)
    -- 结算
    local remainHp = pirateHp
    for i=1,3 do
        local fightscore = unitlist[i] and unitlist[i][2]
        remainHp = remainHp - fightscore
    end
    print("pirate remain hp",remainHp)
    if remainHp > 0 then
        ShowMessage("You Lose!!","restart")
        return
    else
        ShowMessage("You Win!!","callback",function()
            -- 发奖励
            -- 给角色添加宝石
            local str = "Get Gem"
            for gemType,count in pairs(planet.GemList) do
                local precnt = PlayerInfo.PlayInfo.Gems[gemType] or 0
                PlayerInfo.PlayInfo.Gems[gemType] = precnt + count
                str = str ..","..EGem[gemType]..":"..count
            end
            ShowMessage(str)
            -- 进入锻造阶段
            LevelInfo.RoundInfo.TurnInfo.Stage = EStage.Forge
        end)
    end
end
-- 锻造
function stage_forge(unitType)
    local gemdict = Cfg.Unit.Craft[unitType]
    -- check
    for gemType,gemCount in pairs(gemdict) do
        local count = PlayerInfo.PlayInfo.Gems[gemType] or 0
        if count < gemCount then
            ShowMessage("Not enough gem:"..EGem[gemType])
            return
        end
    end
    -- consume
    for gemType,gemCount in pairs(gemdict) do
        local count = PlayerInfo.PlayInfo.Gems[gemType] or 0
        PlayerInfo.PlayInfo.Gems[gemType] = count - gemCount
    end
    -- add
    local unit = CUnit:new(unitType)
    unit.m_PointList={1} -- 初始点数
    PlayerInfo.PlayInfo.Units[unit.m_Id] = unit
    print("unit score:",unit:GetFightScore())
    ShowMessage("Get New Unit:"..EUnit[unitType])
end
-- endregion


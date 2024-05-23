require("class")
require("unit")
require("logic")
local Slab = require 'Slab'

function ShowMessage(message,confirmName,callback)
    MessageBox = true
    Message = message
    if confirmName then
        MessageBoxOptions = {Buttons={confirmName}}
    else
        MessageBoxOptions = nil
    end
    MessageOkCallback = callback
end
function MessageCallback(result)
    if result == "restart" then
        restart()
    elseif result == "callback" then
        MessageOkCallback()
    end
end

function love.load(args)
	love.graphics.setBackgroundColor(0.4, 0.88, 1.0)
	Slab.Initialize(args)
    -- 初始化关卡
    restart()
end

function love.update(dt)
	Slab.Update(dt)
  
	Slab.BeginWindow('Property', {Title = "Property"})
    -- 列出各个战舰的数量
    Slab.BeginListBox('UnitList')
    for id,unit in pairs(PlayerInfo.PlayInfo.Units) do
        Slab.BeginListBoxItem('UnitList_Item:'..id)
        Slab.Text(EUnit[unit.m_Type].."("..unit.m_Id.."):[score:"..unit:GetFightScore().."]")
        Slab.EndListBoxItem()
    end
    Slab.EndListBox()
    -- 列出各个宝石的数量
    Slab.BeginListBox('EGemList')
    for gemType,count in pairs(PlayerInfo.PlayInfo.Gems) do
        Slab.BeginListBoxItem('EGemList_Item:'..gemType)
        Slab.Text(EGem[gemType]..":"..count)
        Slab.EndListBoxItem()
    end
    Slab.EndListBox()
	Slab.EndWindow()

    -- 
    Slab.BeginWindow('Level',{Title = "Level:"..LevelInfo.CrntRound})
    local stage = LevelInfo.RoundInfo.TurnInfo.Stage
    Slab.Text("Stage:"..EStage[stage])
    Slab.Text("Turn:"..LevelInfo.RoundInfo.CrntTurn)
    if stage == EStage.Select then
        -- 列出各个选择
        local list = LevelInfo.RoundInfo.TurnInfo.PlanetList
        for i,v in ipairs(list) do
            local str = EPlanet[v.PlanetType]
            if v.PlanetType ~= EPlanet.Planet then
                str = str..":[Hp:"..v.Hp.."]"
            end
            if Slab.Button(str..":"..gemlist_to_string(v.GemList)) then
                stage_select(i)
            end
        end
    elseif stage == EStage.Fight then
        if Slab.Button("Fight") then
            stage_fight()
        end
    elseif stage == EStage.Forge then
        for unitType,name in ipairs(EUnit) do
            local gemlist = Cfg.Unit.Craft[unitType]
            if Slab.Button(EUnit[unitType].." need:"..gemlist_to_string(gemlist)) then
                stage_forge(unitType)
            end
        end
        if Slab.Button("Next Turn") then
            next_turn()
        end
    end
    Slab.EndWindow()
    if MessageBox then
        local Result = Slab.MessageBox("Info", Message, MessageBoxOptions)

        if Result ~= "" then
            MessageCallback(Result)
            MessageBox = false
        end
    end
end

function love.draw()
	Slab.Draw()
end

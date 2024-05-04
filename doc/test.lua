-- 测试用代码

DesignDataFileTable = {
    Unit = "res://res/design/unit-data.csv",
    BluePrint = "res://res/design/blueprint-data.csv",
}
DesignData = {}

function GetCfg(tableName,key)
    return DesignData[tableName] and DesignData[tableName]:fetch(key)
end

function LoadAllDesignData()
    for designName,path in pairs(DesignDataFileTable) do
        local res = preload(path)
        res:setup()
        DesignData[designName] = res.data
    end
end

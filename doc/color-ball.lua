local color = {1,2,3,4} -- 分别代表红黄蓝，权值，10,100,1000
local num = #color
function _cal(c)
    if c == num+1-4 then
        return 1000,"绿"
    elseif c == num+1-3 then
        return 100,"红"
    elseif c == num+1-2 then
        return 10,"黄"
    elseif c == num+1-1 then
        return 1,"蓝"
    end
end
function _calname(c)
    if c == num+1-4 then
        return "绿"
    elseif c == num+1-3 then
        return "红"
    elseif c == num+1-2 then
        return "黄"
    elseif c == num+1-1 then
        return "蓝"
    end
end

local map = {} -- 频数
local list = {} -- 组合情况

for i=1,num do
    for j=1,num do
        for k=1,num do
            for l=1,num do
                local total = _cal(i)+_cal(j)+_cal(k)+_cal(l)
                if not map[total] then
                    map[total] = 0
                    table.insert( list,{total,i,j,k,l} )
                end
                map[total]=map[total] + 1
            end
        end
    end
end

table.sort(list,function(a,b) return a[1] < a[2] end)

for k,v in pairs(list) do
    local total,i,j,k,l = unpack(v)
    local cnt = map[total]
    print(_calname(i),_calname(j),_calname(k),_calname(l),string.format("%04d",total),cnt,cnt/(num^num))
end



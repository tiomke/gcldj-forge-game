local __classRegTbl = {}
function class()
	-- 返回一个表
	-- 提供 new 方法
	local class = {} -- 表示一个类型
	__classRegTbl[class]={} -- 初始化注册表
	class.new = function ( c, ... )
		-- 检查参数
		local obj = {} -- 表示一个类对象
		obj._class = class

		if c.Ctor then
			c.Ctor( obj,... )
		end
		local tbl = class

		setmetatable(obj,{
				__index = tbl,
				__newindex = function (t,k,v)
					local regTbl =  __classRegTbl[t._class]
					if regTbl[k] then
						tbl[k] = v
					end
					print("unregister member:",k)
				end	
			})
		return obj
	end
	return class
end

function RegMember(class,key)
	__classRegTbl[class][key] = true
end
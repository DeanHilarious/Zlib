local mt={}
mt.__index=table
setmetatable(mt,mt)

--- mt.concat 连接字符串(改良版,自动调用tostring)
-- @param t table
-- @param s 连接符
function mt.concat(t,s)
	local tt={}
	for i=1,#t do
		tt[i]=tostring(t[i])
	end
	return table.concat(tt,s)
end
--- mt.deepcopy 深度拷贝
-- @param obj object
function mt.deepcopy(obj)
	local lookup_table = {}
	local function _copy(object)
		if type(object) ~= "table" then
			return object
		elseif lookup_table[object] then
			return lookup_table[object]
		end
		local new_table = {}
		lookup_table[object] = new_table
		for index, value in pairs(object) do
			new_table[_copy(index)] = _copy(value)
		end
		return setmetatable(new_table, getmetatable(object))
	end

	return _copy(obj)
end
--- mt.simplecopy 浅拷贝
-- @param tbl table
function mt.simplecopy(tbl)
	local newtbl={}
	for k,v in pairs(tbl) do
		if type(v)=='table' then
			newtbl[k]=mt.simplecopy(v)
		else
			newtbl[k]=v
		end
	end
	return newtbl
end
--- mt.shuffle 打乱数组顺序(洗牌算法),返回一个新的数组
-- @param tbl 数组
function mt.shuffle(tbl)
	tbl=mt.simplecopy(tbl)
	local newtbl={}
	local num=#tbl
	local num2=num
	for i=1,num do
		table.insert(newtbl,table.remove(tbl,math.random(1,num2)))
		num2=num2-1
	end
	return newtbl
end
--- mt.fromfile 逐行读取文件并保存到table中返回
-- @param path 文件路径
function mt.fromfile(path)
	local Lines = {}
	local f = io.open(path, "r")
	if f == nil then
		return nil
	end
	for v in f:lines() do
		table.insert(Lines, v)
	end
	f:close()
	return Lines
end
--- mt.writefile 将数组保存到文件中,逐行保存
-- @param path 文件路径,会覆盖原有文件
-- @param tbl  数组
function mt.writefile(path,tbl)
	tbl=table.concat(tbl,"\r\n")
	local f = io.open(path, "w")
	f:write(tbl)
	f:close()
end

function mt.print( t )
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end

return mt
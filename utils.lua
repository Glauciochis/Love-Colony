local utils = {}


--- Checks if two tables (or values) are identical.
function utils.same(a, b)
	if a == b then return true
	elseif not a or not b then return true
	elseif type(a) ~= type(b) then return false
	elseif type(a) == 'table' then
		if #a ~= #b then return false end
		local count, total = 0, 0
		for k, v in pairs(a) do
			if utils.same(v, b[k]) then
				count = count + 1
			end
			total = total + 1
		end
		if total == count then return true end
	end
	return false
end
--- Checks if a table contains all requirements (ipairs).
function utils.containsAll(t, requirements)
	local count, total = 0, 0
	for i, k in ipairs(requirements) do
		if t[k] ~= nil then count = count + 1 end
		total = total + 1
	end
	return total == count
end
--- Checks if a table contains the value.
function utils.contains(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then return true end
	end
	return false
end


return utils
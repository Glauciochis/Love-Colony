local system = {}
local _system = {}


-- general
--- Imports systems from a given path.
--- @param directory string The directory to scan for systems in
function system.importSystems(directory)
	local priority_list = {}
	-- import all systems found in directory
	for i, file in ipairs(love.filesystem.getDirectoryItems(directory)) do
		if file:find('%.lua') then
			local name = file:gsub('%.lua', '')
			if system.importSystem(name, directory..'/'..file) then
				table.insert(priority_list, {_system[name].priority or 100, name})
			end
		end
	end
	
	-- sort loaded systems by priority
	table.sort(priority_list, function(a, b) return a[1] < b[1] end)
	-- call initialise on all systems
	for i, c in ipairs(priority_list) do
		print('Initialising system "'..c[2]..'".')
		if _system[ c[2] ].initialise then
			_system[ c[2] ].initialise()
		end
	end
end
--- Imports a system based on the path given.
--- @param name string The name the system will be under
--- @param path string The path to the .lua file
--- @return boolean success
function system.importSystem(name, path)
	local chunk, err = love.filesystem.load(path)
	if chunk then
		local status, result = pcall(chunk)
		if status then
			_system[name] = result
			return true
		else
			print('Error running chunk for system', err)
			return false
		end
	else
		print('Error loading file for system: ', err)
		return false
	end
end


return system
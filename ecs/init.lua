local thisFolder = ((...)..'.') or ''
local ecs = {
	entity = require(thisFolder..'entity')
	,query = require(thisFolder..'query')
	,system = require(thisFolder..'system')
}


function ecs.initialise()
	ecs.system.importSystems('systems')
end

function ecs.update(dt)
	ecs.entity.update()
	ecs.query.update()
end


return ecs
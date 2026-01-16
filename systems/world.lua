-- 	Handles the simulation of, lifecycle of and manipulation of worlds
-- this includes setting tiles, keeping track of entities in partitions
-- and more.
local world = {}
local _world = {}
world.partition_size = 18 -- size in tiles
world.tile_size = 32
world.partition_coord_bits = 32
world.is_3d = true



function world.initialise()
	world.ts_calc = 1 / world.tile_size
	world.ps_calc = 1 / (world.partition_size * world.tile_size)
	world.partition_coord_chunk = math.floor(world.partition_coord_bits / 3)
end

--- Initialises a world instance.
--- @param name string Name for the world
--- @param params table Parametres for the world to follow
function world.initialiseWorld(name, params)
	if _world[name] then return end
	params = params or {}
	local w = {}
	w.bounds = {params.width or false, params.height or false, params.depth or false}
	w.seed = params.seed or os.time()
end
function world.getPartitionCoord(x, y, z)
	local p = 0
	x, y, z = x
end

event_handler.subscribe('render', function(v, ww, wh)
	local sh, qu = resources.getSprite({'agent', 'kobold', 1})
	love.graphics.draw(sh, qu)
	
	local mx, my = v.mx, v.my
	local xx, yy = math.floor(mx*world.ts_calc), math.floor(my*world.ts_calc)
	love.graphics.rectangle('line', xx*world.tile_size, yy*world.tile_size, world.tile_size, world.tile_size)
end, 'world')


return world
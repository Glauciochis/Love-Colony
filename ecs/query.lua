local query = {}
local queries = {}
local query_changes = {}
query.QUERY_COMMAND = {
	deletion = 1
}
query.__index = query

--- @alias table query


-- general
--- Updates state of queries based on changes.
function query.update()
	-- make sure the changes are in query index order
	table.sort(query_changes, function(a, b) return a[2]<b[2] end)
	
	while #query_changes > 0 do
		local command = table.remove(query_changes)
		if command[1] == QUERY_COMMAND.deletion then
			table.remove(queries, command[2])
		end
	end
end
--- Removes or adds entities to queries based on component changes.
--- @param entity_id integer ID of entity being updated
--- @param comp_id integer|string Component ID of component being changed
function query.updateEntityComponent(entity_id, comp_id)
	local was_added = not ecs.entity.hasComponent(entity_id, comp_id)
	for i, q in ipairs(queries) do
		if utils.contains(q.components, comp_id) then
			if was_added then
				local ent = ecs.entity.get(entity_id)
				if utils.containsAll(ent.components, q.components) then
					local ind = utils.contains(q.cache, entity_id)
					if not ind then
						table.insert(q.cache, ind)
					end
				end
			else
				local ind = utils.contains(q.cache, entity_id)
				if ind then
					table.remove(q.cache, ind)
				end
			end
		end
	end
end
--- Removes entity from query caches it is in.
--- @param entity_id integer ID of the entity being removed
function query.removeEntity(entity_id)
	for i, q in ipairs(queries) do
		local ind = utils.contains(q.cache)
		if ind then table.remove(q.cache, ind) end
	end
end
--- Calls the function for each entity in the query.
--- @param fun function Function to use with each entity with the arguments being (integer entity_id)
function query:iterate(fun)
	for _, id in ipairs(self.cache) do
		fun(id)
	end
end
--- Fills in the query's cache based on it's requirements.
function query:initialiseCache()
	-- clear the cache of this query if there are any
	if #self.cache > 0 then
		for i=#self.cache, 1, -1 do
			table.remove(self.cache, i)
		end
	end
	
	-- add all entity ids of entities with the required components
	for id, ent in pairs(ecs.entity.getAllEntities()) do
		if utils.containsAll(ent.components, self.components) then
			table.insert(self.cache, id)
		end
	end
end

-- lifecycle
--- Gets or creates a query then returns it.
--- @param ... string|integer|table Component names, ids, or lists
--- @return query query
function query.new(...)
	-- compile components into a simple table
	local comps = {}
	for i=1, select('#', ...), 1 do
		local v = select(i, ...)
		if type(v) == 'table' then
			for j, c in ipairs(v) do
				table.insert(comps, ecs.getComponentID(c))
			end
		else
			table.insert(comps, ecs.getComponentID(v))
		end
	end
	table.sort(comps)
	
	-- if a matching query already exists: return it
	for i, q in ipairs(queries) do
		if utils.same(q[1], comps) then
			q.users = q.users + 1
			return q
		end
	end
	
	-- otherwise: create a new query and return it
	local q = {}
	setmetatable(q, query)
	q.components = comps
	q.cache = {}
	q.users = 1
	q:initialiseCache()
	table.insert(queries, q)
end
--- Attempt to dispose of a query.
function query:dispose()
	self.users = self.users - 1
	if self.users == 0 then
		local ind = utils.contains(queries, self)
		table.insert(query_changes, {1, ind})
	end
end


return query
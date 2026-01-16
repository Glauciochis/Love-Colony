local entity = {}
-- lists
local _entity = {}
local _component = {}
-- id stuff
local last_id = 0
local free_ids = {}
-- comp registry
local last_component_id = 0
local comp_registry = {}
-- stacks
--- @enum entity_command
entity.ENTITY_COMMAND = {
	deletion = 1,
	add_component = 2,
	remove_component = 3
}
local entity_changes = {}



-- general
--- Returns entire entity list.
function entity.getAllEntities() return _entity end
--- Updates the state of the ecs.
function entity.update()
	
	while #entity_changes > 0 do
		local command = table.remove(entity_changes)
		local ent_id, command_type = command[1], command[2]
		
		-- TODO: add hooks for event handler events
		
		if command_type == entity.ENTITY_COMMAND.deletion then
			
			if _entity[ent_id] then
				ecs.query.removeEntity(ent_id)
				-- TODO: do event handler stuff HERE
				entity[ent_id] = nil
				ecs.freeID(ent_id)
			end
			
		elseif command_type == entity.ENTITY_COMMAND.add_component then
			
			local comp_id = command[3]
			-- TODO: do event handler stuff HERE
			ecs.query.updateEntityComponent(ent_id, comp_id)
			
		elseif command_type == entity.ENTITY_COMMAND.remove_component then
			
			local comp_id = command[3]
			-- TODO: do event handler stuff HERE before the component is removed in full
			_component[comp_id][ent_id] = nil
			ecs.query.updateEntityComponent(ent_id, comp_id)
			
		end
	end
	
end
--- Returns entity with ID.
--- @param ent_id integer ID of entity to return
function entity.get(ent_id)
	return _entity[ent_id]
end

-- IDs
--- Allocates a new ID for an entity.
--- @return integer id
function entity.allocID()
	if #free_ids > 0 then
		return table.remove(free_ids)
	else
		last_id = last_id + 1
		return last_id
	end
end
--- Frees up an ID for future use.
--- @param id integer The id to be freed
function entity.freeID(id)
	if id == last_id then
		last_id = last_id - 1
		if #free_ids > 0 then
			local remove_free = {}
			table.sort(free_ids)
			-- remove sequential ids that are free
			for i=#free_ids, 1, -1 do
				local free_id = free_ids[i]
				if free_id == last_id then
					last_id = last_id - 1
					table.remove(free_ids, i)
				else
					break
				end
			end
		end
	else
		table.insert(free_ids, id)
	end
end
--- Gets the integer ID for a component.
--- Returns the first argument if it is a number.
--- @param component_name string Name of the component to get
--- @param dont_assign? boolean True to not assign an id if non-existant.
--- @return integer comp_id Numeric ID of the component
function entity.getComponentID(component_name, dont_assign)
	if type(component_name) == 'number' then return component_name end
	if comp_registry[component_name] then
		return comp_registry[component_name]
	elseif dont_assign then
		return component_name
	else
		last_component_id = last_component_id + 1
		comp_registry[component_name] = last_component_id
		return last_component_id
	end
end

-- Life Cycle
--- Adds a new entity to the ecs.
--- @param data table Component data (sparse table or name indexed table)
--- @return integer id ID of the created entity
function entity.add(data)
	local id = ecs.allocID()
	
	_entity[id] = {
		id = id
		,components = {}
	}
	for compname, compdata in pairs(data) do
		local compid = entity.getComponentID(compname)
		-- if the component list doesn't exist: create it
		if not _component[compid] then _component[compid] = {} end
		_component[compid][id] = compdata
		table.insert(_entity[id].components, compid)
	end
	
	return id
end
--- Adds an entity to the deletion pool for removal on the next ecs update.
--- @param id integer ID of entity to remove
function entity.remove(id)
	if _entity[id] then table.insert(entity_changes, {entity.ENTITY_COMMAND.deletion, id}) end
end

-- Component
--- Adds a component to an entity.
--- @param ent_id integer ID of entity.
--- @param comp_id integer|string Component id of the component being added
--- @param data table Data of the component being added
function entity.addComponent(ent_id, comp_id, data)
	-- 	Since this component may be indexed or used by the
	-- code adding it, add it to the entity now then do
	-- more proper reactions to this in update.
	if not _component[comp_id] then _component[comp_id] = {} end
	_component[comp_id][ent_id] = data
	table.insert(_entity[ent_id].components, comp_id)
	if _entity[ent_id] then table.insert(entity_changes, {entity.ENTITY_COMMAND.add_component, ent_id, comp_id}) end
end
--- Removes a component from an entity.
--- @param ent_id integer ID of entity
--- @param comp_id integer|string Component id of the component being removed
function entity.removeComponent(ent_id, comp_id)
	if _entity[ent_id] then table.insert(entity_changes, {entity.ENTITY_COMMAND.remove_component, ent_id, comp_id}) end
end
--- Checks if an entity has a component.
--- @param ent_id integer ID of entity
--- @param comp_id integer Component ID of component to check for
function entity.hasComponent(ent_id, comp_id)
	return _component[comp_id] and (_component[comp_id][ent_id] ~= nil)
end



-- Utilities
local util_entity = {}
function util_entity:__index(key)
	if type(key) == 'string' then key = entity.getComponentID(key) end
	return _component[key] and _component[key][rawget(self, 1)] or util_entity[key]
end
function util_entity:__newindex(key, value)
	key = ecs.getComponentID(key)
	if value == nil then
		ecs.removeComponent(rawget(self, 1), key)
	else
		ecs.addComponent(rawget(self, 1), key, value)
	end
end
function util_entity:remove() entity.remove(rawget(self, 1)) end
--- Creates a utility entity for more easy entity usage.
--- @param id integer ID of the entity to make the object of.
--- @return table entity_instance
function entity.getHelper(id)
	local instance = {id}
	setmetatable(instance, util_entity)
	return instance
end



return entity
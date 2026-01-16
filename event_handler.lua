local event_handler = {}
local _event = {}
local _component_event = {}


-- events
--- Subscribes a function to an event.
--- @param event_name string Name of the event to subcribe to
--- @param fun function Function to subscribe
--- @param owner string|integer Owner ID 
function event_handler.subscribe(event_name, fun, owner, priority)
	if not _event[event_name] then _event[event_name] = {} end
	table.insert(_event[event_name], {priority or 100, fun, owner})
	table.sort(_event[event_name], function(a, b) return a[1] < b[1] end)
end
--- Unsubscribes from all events with the given owner.
--- @param event_name string
--- @param owner string
function event_handler.unsubscribe(event_name, owner)
	for n, eve in pairs(_event) do
		for i=#eve, 1, -1 do
			if sub[3] == owner then
				table.remove(eve, i)
			end
		end
	end
end
--- Emits an event; calling all functions subscribed to it.
--- @param event_name string
--- @param ... any Arguments to forward to the event functions.
function event_handler.emit(event_name, ...)
	if not _event[event_name] then
		-- print('Warning: emitting an event with no subscribers.', event_name)
		return
	end
	for i, f in ipairs(_event[event_name]) do
		f[2](...)
	end
end


return event_handler
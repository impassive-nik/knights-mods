local custom_handlers = {
}

local function get_or_create_handler_table(action)
  local t = custom_handlers[action]
  if t ~= nil then
    return t
  end
  custom_handlers[action] = {
    ordered_ids = {},
    handlers = {}
  }
  return custom_handlers[action]
end

------ Public API ------

--- @enum ActionType
ActionType = {
  GAME_PREPARE = "GAME_PREPARE", -- called before the dungeon generation. No parameter
  GAME_START = "GAME_START", -- called when the match starts. No parameter
  RESPAWN = "RESPAWN" -- called when a knight is preparing to spawn. Passes a player as the parameter
}

Actions = {
}

--- Register a listener for the action_type
--- @param action string: either ActionType or your own action id
--- @param id string: the unique (per action type) id of your listener
--- @param listener function: an action listener, which accepts a two parameter (a value from action emitter and the current result, returned from other listeners) and returns either nil or the value to be passed back to the action emitter
function Actions.Listen(action, id, listener)
  local l_table = get_or_create_handler_table(action)
  if Config.debug then
    DebugPrint("Action listener registered - '" .. action .. "/" .. id .. "'")
  end
  if (l_table.handlers[id] == nil) then
    table.insert(l_table.ordered_ids, id)
  end
  l_table.handlers[id] = {handler=listener, enabled=true}
end

--- Disable specific action listener
--- @param action string: either ActionType or your own action id
--- @param id string: the unique (per action type) id of your listener
--- @return boolean: true if the listener was successfully disabled
function Actions.DisableListener(action, id)
  local l_table = get_or_create_handler_table(action)
  if (l_table.handlers[id] == nil) then
    return false
  end
  l_table.handlers[id].enabled = false
  return true
end

--- Enable specific action listener
--- @param action string: either ActionType or your own action id
--- @param id string: the unique (per action type) id of your listener
--- @return boolean: true if the listener was successfully enabled
function Actions.EnableListener(action, id)
  local l_table = get_or_create_handler_table(action)
  if (l_table.handlers[id] == nil) then
    return false
  end
  l_table.handlers[id].enabled = true
  return true
end

--- Check whether the specified listener exists and is enabled
--- @param action string: either ActionType or your own action id
--- @param id string: the unique (per action type) id of your listener
--- @return boolean: true if the specified handler exists and is enabled, false otherwise
function Actions.IsEnabled(action, id)
  local l_table = get_or_create_handler_table(action)
  if (l_table.handlers[id] == nil) then
    return false
  end
  return l_table.handlers[id] ~= nil and l_table.handlers[id].enabled
end

--- Emit an action and receive an answer from the listeners
--- @param action string: either ActionType or your own action id
--- @param parameter any: any value you want to pass to the listeners
--- @return any: either the last non-nil value, returned by the listeners, or nil
function Actions.Emit(action, parameter)
  local l_table = get_or_create_handler_table(action)
  local result = nil
  for _i=1,#l_table.ordered_ids do
    local listener = l_table.handlers[l_table.ordered_ids[_i]]
    if listener.enabled then
      local res = listener.handler(parameter, result)
      if res ~= nil then
        result = res
      end
    end
  end
  return result
end

------ End of the public API ------


-- Retranslate some of the hooks as actions

local function respawn_function(player, _)
  Actions.Emit(ActionType.RESPAWN, player)
end

Hooks.Register(HookType.GAME_PREPARE, "toolbox:action", function() kts.SetRespawnFunction(respawn_function); Actions.Emit(ActionType.GAME_PREPARE, nil) end)
Hooks.Register(HookType.GAME_START,   "toolbox:action", function() Actions.Emit(ActionType.GAME_START, nil) end)

local custom_handlers = {
}

------ Public API ------

--- @enum HookType
HookType = {
  CREATURE_SQUELCH = "CREATURE_SQUELCH",
  SHOOT = "SHOOT",
  WEAPON_PARRY = "WEAPON_PARRY",
  MISSILE_MISS = "MISSILE_MISS",
  KNIGHT_DAMAGE = "KNIGHT_DAMAGE",
  WEAPON_DOWNSWING = "WEAPON_DOWNSWING",
  GAME_START = "GAME_START",
  GAME_PREPARE = "GAME_PREPARE",
}

Hooks = {
}

--- Register the function to listen to kts.HOOK_* event
--- @param hook HookType: one of the supported hook types
--- @param id string: the unique (per current hook type) id of your handler
--- @param handler function: your handler function. It should not expect parameters nor return values
function Hooks.Register(hook, id, handler)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' does not exist")
  assert(h_table.handlers[id] == nil or h_table.handlers[id].enabled == false, "Hook '" .. hook .. "' already contains the handler '" .. id .. "'")
  if Config.debug then
    DebugPrint("hook handler registered - '" .. hook .. "/" .. id .. "'")
  end
  if (h_table.handlers[id] == nil) then
    table.insert(h_table.ordered_ids, id)
  end
  h_table.handlers[id] = {handler=handler, enabled=true}
end

--- Disable a previously registered hook handler
--- @param hook HookType: one of the supported hook types
--- @param id string: the unique id of your handler
function Hooks.Disable(hook, id)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' does not exist")
  assert(h_table.handlers[id] ~= nil, "Hook '" .. hook .. "' does not have the handler '" .. id .. "'")
  h_table.handlers[id].enabled = false
end

--- Enable a previously registered hook handler
--- @param hook HookType: one of the supported hook types
--- @param id string: the unique id of your handler
function Hooks.Enable(hook, id)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' does not exist")
  assert(h_table.handlers[id] ~= nil, "Hook '" .. hook .. "' does not have the handler '" .. id .. "'")
  h_table.handlers[id].enabled = true
end

--- Check whether the specified handler exists and is enabled
--- @param hook HookType: one of the supported hook types
--- @param id string: the unique id of your handler
--- @return boolean: true if the specified handler exists and is enabled, false otherwise
function Hooks.IsEnabled(hook, id)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' does not exist")
  return h_table.handlers[id] ~= nil and h_table.handlers[id].enabled
end

------ End of the public API ------


local function override_hook(name, original)
  assert(original ~= nil, "No original hook provided")
  HookType[name] = name
  custom_handlers[name] = {
    ordered_ids = {},
    handlers = {}
  }
  Hooks.Register(name, "base:default", original)
  if Config.debug then
    DebugPrint("hook overriden - '" .. name .. "'")
  end
  return function()
    local h_table = custom_handlers[name]
    for _i=1,#h_table.ordered_ids do
      local handler = h_table.handlers[h_table.ordered_ids[_i]]
      if handler.enabled then
        handler.handler()
      end
    end
  end
end

-- override all kts.HOOK_* functions and add them to the hooks list
kts.MENU.start_game_func = override_hook(HookType.GAME_START, kts.MENU.start_game_func)
kts.MENU.prepare_game_func = override_hook(HookType.GAME_PREPARE, kts.MENU.prepare_game_func)

for key, value in pairs(kts) do
  if type(key) == "string" and key:match("^HOOK_") then
    local name = key:sub(6)
    kts[key] = override_hook(name, value)
  end
end

-- Known hooks in the latest version of knights:
--   CREATURE_SQUELCH
--   SHOOT
--   WEAPON_PARRY
--   MISSILE_MISS
--   KNIGHT_DAMAGE
--   WEAPON_DOWNSWING

local custom_handlers = {
}

-- Public API --

function RegisterHook(hook, id, func)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' is not found")
  assert(h_table.handlers[id] == nil or h_table.handlers[id].enabled == false, "Hook '" .. hook .. "' already contains the handler '" .. id .. "'")
  if (h_table.handlers[id] == nil) then
    table.insert(h_table.ordered_ids, id)
  end
  h_table.handlers[id] = {handler=func, enabled=true}
end

function DisableHook(hook, id)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' is not found")
  assert(h_table.handlers[id] ~= nil, "Hook '" .. hook .. "' does not have the handler '" .. id .. "'")
  h_table.handlers[id].enabled = false
end

DeleteHook = DisableHook -- a simple alias for backward compatibility

function EnableHook(hook, id)
  local h_table = custom_handlers[hook]
  assert(h_table ~= nil, "Hook '" .. hook .. "' is not found")
  assert(h_table.handlers[id] ~= nil, "Hook '" .. hook .. "' does not have the handler '" .. id .. "'")
  h_table.handlers[id].enabled = true
end

function HasHook(hook, id)
  local h_table = custom_handlers[hook]
  if h_table == nil then
    return false
  end
  if id == nil then
    return true
  end
  return h_table.handlers[id] ~= nil and h_table.handlers[id].enabled
end

-- End of the public API --


local function override_hook(name, original)
  assert(original ~= nil, "No original hook provided")
  custom_handlers[name] = {
    ordered_ids = {},
    handlers = {}
  }
  RegisterHook(name, "stdhook", original)
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
for key, value in pairs(kts) do
  if type(key) == "string" and key:match("^HOOK_") then
    local name = key:sub(6)
    kts[key] = override_hook(name, value)
  end
end

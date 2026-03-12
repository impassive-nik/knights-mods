local hook_id = HookType.WEAPON_DOWNSWING
local handler_id = "toolbox:test:my_handler_id"

assert(not Hooks.IsEnabled(hook_id, handler_id))

local function downswing_handler()
  DebugPrint("'downswing_handler' called")
end

Hooks.Register(hook_id, handler_id, downswing_handler)
assert(Hooks.IsEnabled(hook_id, handler_id))

Hooks.Disable(hook_id, handler_id)
assert(not Hooks.IsEnabled(hook_id, handler_id))

Hooks.Enable(hook_id, handler_id)
assert(Hooks.IsEnabled(hook_id, handler_id))

Hooks.Disable(hook_id, handler_id)

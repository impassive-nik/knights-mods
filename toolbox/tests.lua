DebugPrint("Running tests")

assert(not HasHook("SOME_FAKE_HOOK"))
assert(not HasHook("SOME_FAKE_HOOK", "SOME_HANDLER_ID"))

assert(HasHook("WEAPON_DOWNSWING"))

local function downswing_handler()
  DebugPrint("'downswing_handler' called")
end

RegisterHook("WEAPON_DOWNSWING", "my_handler_id", downswing_handler)
assert(HasHook("WEAPON_DOWNSWING", "my_handler_id"))
assert(HasHook("WEAPON_DOWNSWING", "my_handler_id"))

DisableHook("WEAPON_DOWNSWING", "my_handler_id")
assert(not HasHook("WEAPON_DOWNSWING", "my_handler_id"))

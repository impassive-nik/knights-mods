local action_id = "TOOLBOX_TEST_ACTION"
local listener_id = "toolbox:test:my_listener_id"
local listener_id_2 = "toolbox:test:my_listener_id_2"

local counter = 0
local function listener(value, cur_result)
  counter = counter + value
  return counter
end

assert(not Actions.IsEnabled(action_id, listener_id))
Actions.Listen(action_id, listener_id, listener)
assert(Actions.IsEnabled(action_id, listener_id))

Actions.Emit(action_id, 1)
assert(counter == 1)
assert(Actions.Emit(action_id, 1) == 2)
assert(counter == 2)

counter = 0
Actions.Listen(action_id, listener_id_2, listener)
assert(Actions.Emit(action_id, 15) == 30)
assert(counter == 30)

counter = 0
Actions.DisableListener(action_id, listener_id)
Actions.DisableListener(action_id, listener_id_2)
assert(not Actions.IsEnabled(action_id, listener_id))
assert(Actions.Emit(action_id, 1) == nil)
assert(counter == 0)

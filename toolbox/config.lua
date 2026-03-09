Config = {
  debug = false,
  do_tests = false
}

function DebugPrint(message)
  if Config.debug then
    kts.DebugPrint("toolbox: " .. message)
  end
end

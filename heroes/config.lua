Config = {
  debug = true,
  barb_gems = 6,
  barbs_per_player = -1,
}
Config.barbs_per_player = Config.barb_gems + 2

function DebugPrint(message)
  if Config.debug then
    kts.DebugPrint("heroes: " .. message)
  end
end

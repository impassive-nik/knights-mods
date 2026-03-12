-- Init file of "Heroes" mod
-- Feel free to study and use any part of the source code.
--
-- Made by ImpassIve_rus

-- mod.RegisterMod { name = "heroes", version = "0.1" }
function require(name)
  return _ENV[name]
end

mod_enabled = false
heroes = {} --List of all knights with parameters
ranks = {} --List of all current ranks (will be saved between games)
deaths = false --Did the game already started?
barb_gems = {}


dofile("pre_func.lua")  --pre-declarations of some functions
dofile("config.lua") --constants and other
dofile("ranks.lua") --constants and other
dofile("funcs.lua")  --basic functions
dofile("sprites.lua")  --gfx & sounds
dofile("itemsmobs.lua") --new items (such as reviving gems) and mobs
dofile("main.lua") --functions to be called during game
dofile("menu.lua") --menu configuration

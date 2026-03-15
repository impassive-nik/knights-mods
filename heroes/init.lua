-- Init file of "Heroes" mod

if mod ~= nil then
  mod.RegisterMod { name = "heroes", version = "0.1" }
  base = require("base")
  toolbox = require("toolbox")
end

dofile("config.lua")
dofile("data.lua")
dofile("funcs.lua")
dofile("assets.lua")
dofile("items.lua")
dofile("mobs.lua")
dofile("menu.lua")

-- Entry point for the toolbox mod --

if mod ~= nil then
  mod.RegisterMod { name = "toolbox", version = "0.1" }
end

dofile("config.lua")
dofile("menu.lua")
dofile("hooks.lua")
dofile("actions.lua")

if Config.do_tests then
  dofile("tests/init.lua")
end

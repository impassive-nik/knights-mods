local C = require("base")
local T = require("toolbox")
local M = T.Menu


local Heroes = { --Declare new Quest type
	name = "Heroic Quest",
	description = function(S)
	return "Heroes\n\n"
		.. "Collect "..BARB_GEMS.." barbaric gems to win"
		.. "\n"
		.. "'Number of Gems' field now determines the amount of reviving gems"
		.. "\n"
		.. "Note that number of barbarians depends on the number of players"
	end,
	settings = { 
		mission = "heroes",
		book = "none",
		wand = "none",
		num_wands = 0,
		num_gems = 3,
		gems_needed = 0,
		dungeon = "big",
		premapped = true,
		entry = "close",
		gear = "none",
		exit = "none",
		num_keys = 1,
		pretrapped = true,
		stuff = 5,
		stuff_respawn = "none",
		zombies = 5,
		bats = 4
	},
	features = function(S)
		ppenabled = false;
	end
}
 
C.quest_table.Heroes = Heroes --Add this new quest type to the quests table
table.insert(C.quest_order, "Heroes") --Put it's name into another table

Quest_Heroes = { --Declare a selection (in menu) for this quest
	id = "Heroes",
	text = Heroes.name,
	min_players = Heroes.min_players,
	max_players = Heroes.max_players,
	min_teams = Heroes.min_teams,
	max_teams = Heroes.max_teams
}

Mission_Heroes_pp = {
	id = "heroespp",
	text = "Heroes",
	constrain = function(S)
		--S.Is("quest", "Heroes")
		S.Is("exit", "none")
		S.Is("book", "none")
		S.Is("stuff_respawn", "none")
		S.Is("gems_needed", 0)
		S.IsNot("wand", "securing")
		S.IsNot("wand", "undeath")
		--S.IsNot("wand", "destruction")
	end,
	features = function(S)
		ppenabled = true;
		if T.Actions.IsEnabled(T.ActionType.GAME_START, "Heroes_FGS") then
			T.Actions.Disable(T.ActionType.GAME_START, "Heroes_FGS")
		end
		T.Actions.Listen(T.ActionType.GAME_START, "Heroes_GS", game_start)
		start_heroes()
	end
}
M.add_menu_choice("quest", Quest_Heroes)--Add the quest to menu
M.add_menu_choice("mission", Mission_Heroes_pp)--Add the mission to menu

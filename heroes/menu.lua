local C = require("base")
local T = require("toolbox")
local M = T.Menu


local Heroes = { --Declare new Quest type
	name = "Heroic Quest",
	text_key = "heroes_quest_type",
	description = function(S)
    return {"heroes.mission_type", "heroes.quest_description_1", "heroes.quest_description_2", "heroes.quest_description_3"}
	end,
	settings = { 
		mission = "heroespp",
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
	text_key = "heroes.quest_type",
	min_players = Heroes.min_players,
	max_players = Heroes.max_players,
	min_teams = Heroes.min_teams,
	max_teams = Heroes.max_teams
}

Mission_Heroes_pp = {
	id = "heroespp",
	text_key = "heroes.mission_type",
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

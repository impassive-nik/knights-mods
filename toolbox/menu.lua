Menu = {
}

-- These functions came directly from the old "menu" module

function Menu.get_menu_item(id)
   for k,v in ipairs(kts.MENU.items) do
      if v.id == id then
         return v
      end
   end
   error("Menu item '" .. id .. "' does not exist!")
end

function Menu.get_menu_choice(item_id, choice_id)
   local item = Menu.get_menu_item(item_id)
   for k,v in ipairs(item.choices) do
      if v.id == choice_id then
         return v
      end
   end
   error("Menu item '" .. item_id .. "' does not have any choice named '" .. choice_id .. "'!")
end

function Menu.add_menu_item(item)
   table.insert(kts.MENU.items, item) -- Add it at the end.
end

function Menu.add_menu_choice(item_id, new_choice)
   local item = Menu.get_menu_item(item_id)
   table.insert(item.choices, new_choice)  -- Add it at the end.
end

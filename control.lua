local utils = require("utils.utils")

script.on_event(defines.events.on_lua_shortcut, function(event)
  utils.toggle_shortcut(event.player_index, event.prototype_name)
end)

-- Compatibilies with other mods --
local reusable_robots = require("compatibilities.reusable_robots.control")

if script.active_mods["Reusable_Robots"] then
  reusable_robots.ensure_control_compatibility()
end

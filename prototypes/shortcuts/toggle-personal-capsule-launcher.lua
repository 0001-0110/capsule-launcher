local capsule_launcher = require("prototypes.turrets.capsule_launcher")

local toggle_personal_capsule_launcher = {}

toggle_personal_capsule_launcher.shortcut_prototype = {
  type = "shortcut",
  name = "toggle-personal-capsule-launcher",
  action = "lua",
  toggleable = true,
  unavailable_until_unlocked = true,
  technology_to_unlock = capsule_launcher.technology_prototype.name,
  icon = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x56.png",
  icon_size = 56,
  small_icon = "__base__/graphics/icons/shortcut-toolbar/mip/new-deconstruction-planner-x24.png",
  small_icon_size = 24
}

return toggle_personal_capsule_launcher

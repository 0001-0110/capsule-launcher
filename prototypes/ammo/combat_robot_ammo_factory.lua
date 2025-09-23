local utils = require("utils.utils")
local Stream = require("__toolbelt-22__.tools.stream")
local ammo_factory = require("prototypes.ammo.ammo_factory")

--- @param projectile data.ProjectilePrototype
local function get_combat_robot_prototype(projectile)
    local _, combat_robot = Stream.of(projectile.action.action_delivery.target_effects):first(function(_, target_effect)
        return utils.is_combat_robot_effect(target_effect)
    end)
    local combat_robot_name = combat_robot.entity_name
    return data.raw["combat-robot"][combat_robot_name]
end

--- Create a custom combat robot that stays idle.
--- Setting the `follows_player` to false is not enough, because that causes the robots to drift aimlessly.
--- @param combat_robot data.CombatRobotPrototype
local function create_idle_combat_robot(combat_robot)
    local custom_combat_robot = table.deepcopy(combat_robot)
    custom_combat_robot.name = utils.prefix("idle-" .. combat_robot.name)
    custom_combat_robot.localised_name = { "entity-name." .. combat_robot.name }
    custom_combat_robot.max_speed = 0
    custom_combat_robot.speed = 0
    custom_combat_robot.hidden_in_factoriopedia = true
    return custom_combat_robot
end

--- Change the projectile to spawn the idle combat robot instead of the normal one
--- @param capsule data.CapsulePrototype
--- @param combat_robot data.CombatRobotPrototype
--- @return data.ProjectilePrototype
local function replace_projectile(capsule, combat_robot)
    local projectile = table.deepcopy(utils.get_projectile(capsule))
    projectile.name = utils.prefix(projectile.name)
    local _, projectile_effect = Stream.of(projectile.action.action_delivery.target_effects)
        :first(function(_, target_effect)
            return utils.is_combat_robot_effect(target_effect)
        end)
    projectile_effect.entity_name = combat_robot.name
    utils.get_projectile_action_delivery(capsule).projectile = projectile.name
    return projectile
end

local combat_robot_ammo_factory = {}

--- @param combat_robot_capsule data.CapsulePrototype
function combat_robot_ammo_factory.create_combat_robot_ammo_prototypes(combat_robot_capsule)
    -- Combat robots shouldn't go back to the turret that shot them, so we create an idle combat robot that doesn't
    -- follow its owner
    combat_robot_capsule = table.deepcopy(combat_robot_capsule)
    local combat_robot_prototype = get_combat_robot_prototype(utils.get_projectile(combat_robot_capsule))
    local idle_combat_robot = create_idle_combat_robot(combat_robot_prototype)
    local projectile = replace_projectile(combat_robot_capsule, idle_combat_robot)
    local prototypes = ammo_factory.create_ammo_prototypes(combat_robot_capsule)
    table.insert(prototypes, projectile)
    table.insert(prototypes, idle_combat_robot)
    return prototypes
end

return combat_robot_ammo_factory

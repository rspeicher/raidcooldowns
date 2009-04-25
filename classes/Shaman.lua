assert(RaidCooldowns, "RaidCooldowns not found!")
if (select(2, UnitClass("player"))) ~= "SHAMAN" then return end

local mod = RaidCooldowns:NewModule("Shaman", RaidCooldowns.ModuleBase, "AceEvent-3.0", "AceBucket-3.0")
mod.cooldowns = RaidCooldowns.cooldowns["SHAMAN"]
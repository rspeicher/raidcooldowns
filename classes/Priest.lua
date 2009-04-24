assert(RaidCooldowns, "RaidCooldowns not found!")
if (select(2, UnitClass("player"))) ~= "PRIEST" then return end

local mod = RaidCooldowns:NewModule("Priest", RaidCooldowns.ModuleBase, "AceConsole-3.0", "AceEvent-3.0")
mod.cooldowns = RaidCooldowns.cooldowns["PRIEST"]
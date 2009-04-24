assert(RaidCooldowns, "RaidCooldowns not found!")

local MINOR_VERSION = tonumber(("$Revision: 2 $"):match("%d+"))
if MINOR_VERSION > RaidCooldowns.MINOR_VERSION then RaidCooldowns.MINOR_VERSION = MINOR_VERSION end

local pairs = _G.pairs
local GetTime = _G.GetTime
local GetSpellCooldown = _G.GetSpellCooldown

local base = {}

function base:OnInitialize()
	self:SetEnabledState(false)
end

function base:OnEnable()
	-- self:ScanTalents()
	self:ScanSpells()
	
	self:RegisterEvent("CHARACTER_POINTS_CHANGED", "ScanSpells")
	self:RegisterEvent("SPELL_UPDATE_COOLDOWN", "ScanSpells")
end

function base:OnDisable()
	self:UnregisterAllEvents()
end

function base:Super(t)
	local sup = getmetatable(self)["__index"]
	return sup[t](sup == base and self or sup)
end

--------------[[		Comm Methods		]]--------------

function base:Sync(id, cooldown)
	if cooldown == 0 then return end
	
	--@debug@
	self:Print("Sync(", id, cooldown, ")")
	--@end-debug@
	
	-- TODO: Change distro to "RAID"
	RaidCooldowns:SendCommMessage(RaidCooldowns.prefix, (id .. " " .. cooldown), "WHISPER", UnitName("player"))
end

--------------[[		Talent Modifiers		]]--------------

function base:CooldownModifier(id, reduction)
	local spellInfo = GetSpellInfo(id)
	self.cooldowns[spellInfo].cd = (self.cooldowns[spellInfo].cd - reduction)
end

function base:ScanTalents()
end

function base:ScanSpells()
	--@debug@
	self:Print("ScanSpells")
	--@end-debug@
	
	local startTime, duration, enabled
	for k, v in pairs(self.cooldowns) do
		startTime, cooldown, enabled = GetSpellCooldown(k)
		if startTime > 0 and cooldown > 1 and enabled == 1 then
			self:Sync(v.id, math.ceil(startTime + cooldown - GetTime()))
		end
	end
end

RaidCooldowns.ModuleBase = base
local MINOR_VERSION = tonumber(("$Revision: 2 $"):match("%d+"))

RaidCooldowns = LibStub("AceAddon-3.0"):NewAddon("RaidCooldowns", "AceConsole-3.0", "AceComm-3.0", "AceEvent-3.0")
RaidCooldowns.MINOR_VERSION = MINOR_VERSION

function RaidCooldowns:OnInitialize()
	self:UnregisterAllEvents()
	-- self:SetEnabledState(false) -- Enabled when we join a raid
	
	--@debug@
	self:Print("RaidCooldowns:OnInitialize -- Debugging enabled")
	--@end-debug@

	self.prefix = "RCD2"
	
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	
	-- Logged in or reloaded in a raid; fake a RAID_ROSTER_UPDATE
	if UnitInRaid("player") then
		self:RAID_ROSTER_UPDATE()
	end
end

function RaidCooldowns:OnEnable()
	self:RegisterComm(self.prefix)
	
	local name, module
	for name, module in self:IterateModules() do
		if not module:IsEnabled() then
			self:EnableModule(name)
		end
	end
end

function RaidCooldowns:OnDisable()
	local name, module
	for name, module in self:IterateModules() do
		self:DisableModule(name)
	end
end

--------------[[		Events		]]--------------

-- oRA2
do
	local inRaid = false
	function RaidCooldowns:RAID_ROSTER_UPDATE()
		--@debug@
		self:Print("RaidCooldowns:RAID_ROSTER_UPDATE")
		--@end-debug@
		
		local inRaidNow = UnitInRaid("player")
		if not inRaid and inRaidNow then
			--@debug@
			self:Print("In raid, calling self:Enable()")
			--@end-debug@
			self:Enable()
			inRaid = true
		elseif inRaid and not inRaidNow then
			--@debug@
			self:Print("Not in raid, calling self:Disable()")
			--@end-debug@
			self:Disable()
		end
	end
end

--------------[[		Comm Methods		]]--------------

function RaidCooldowns:OnCommReceived(prefix, msg, distro, sender)
	-- We don't do anything with these yet, but RaidCooldowns_Display does!
end
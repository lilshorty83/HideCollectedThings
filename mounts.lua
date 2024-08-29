local addonName, addon = ...

addon.mounts = {}

function addon.mounts:IsItemMount(itemLink)
    local itemID = GetItemInfoInstant(itemLink)
    if not itemID then return false end
    return C_MountJournal.GetMountFromItem(itemID) ~= nil
end

function addon.mounts:IsMountKnown(itemLink)
    local itemID = GetItemInfoInstant(itemLink)
    if not itemID then return false end
    local mountID = C_MountJournal.GetMountFromItem(itemID)
    if not mountID then return false end
    local _, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
    return isCollected
end

-- Event listener for new mounts
local function OnMountAdded(self, event)
    if event == "NEW_MOUNT_ADDED" then
        if addon.ResetCaches then
            addon:ResetCaches()
        end
        if addon.SafeUpdateMerchantFrame then
            addon:SafeUpdateMerchantFrame()
        end
    end
end

local mountEventFrame = CreateFrame("Frame")
mountEventFrame:RegisterEvent("NEW_MOUNT_ADDED")
mountEventFrame:SetScript("OnEvent", OnMountAdded)

-- Add a slash command to debug mounts
SLASH_DEBUGMOUNT1 = "/debugmount"
SlashCmdList["DEBUGMOUNT"] = function(msg)
    addon.mounts:DebugMount(msg)
end

print("HideCollectedThings: Mounts module loaded. Use /debugmount [itemLink] to debug a specific mount.")
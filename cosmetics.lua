local addonName, addon = ...

addon.cosmetics = {}

function addon.cosmetics:GetItemID(itemLink)
    if type(itemLink) == "string" then
        return tonumber(itemLink:match("item:(%d+)"))
    elseif type(itemLink) == "number" then
        return itemLink
    end
    return nil
end

function addon.cosmetics:IsItemCosmetic(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then return false end
    
    local _, _, _, _, _, _, _, _, itemEquipLoc, _, _, itemClassID, itemSubClassID = GetItemInfo(itemID)
    
    -- Check if the item is equippable and is either armor or a weapon
    return itemEquipLoc and itemEquipLoc ~= "" and (itemClassID == Enum.ItemClass.Armor or itemClassID == Enum.ItemClass.Weapon)
end

function addon.cosmetics:IsCosmeticCollected(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then return false end
    
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemID))
    if not sourceID then return false end
    
    local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
    return sourceInfo and sourceInfo.isCollected
end

function addon.cosmetics:DebugCosmetic(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then
        print("HideCollectedThings: Invalid itemID for", tostring(itemLink))
        return
    end

    print("HideCollectedThings: Debugging cosmetic", itemID)
    print("IsItemCosmetic:", self:IsItemCosmetic(itemLink))
    print("IsCosmeticCollected:", self:IsCosmeticCollected(itemLink))
    
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemID))
    print("SourceID:", sourceID)
    
    if sourceID then
        local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
        print("SourceInfo:", sourceInfo and "Available" or "Not Available")
        if sourceInfo then
            print("IsCollected:", sourceInfo.isCollected)
        end
    end
end

-- Event listener for appearance updates
local function OnAppearanceUpdate(self, event)
    if event ~= "TRANSMOG_COLLECTION_UPDATED" then return end
    if addon.ResetCaches then
        addon:ResetCaches()
    end
    if addon.SafeUpdateMerchantFrame then
        addon:SafeUpdateMerchantFrame()
    end
end

local cosmeticEventFrame = CreateFrame("Frame")
cosmeticEventFrame:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
cosmeticEventFrame:SetScript("OnEvent", OnAppearanceUpdate)

-- Add a slash command to debug cosmetics
SLASH_DEBUGCOSMETIC1 = "/debugcosmetic"
SlashCmdList["DEBUGCOSMETIC"] = function(msg)
    addon.cosmetics:DebugCosmetic(msg)
end

print("HideCollectedThings: Cosmetics module loaded. Use /debugcosmetic [itemLink] to debug a specific cosmetic item.")
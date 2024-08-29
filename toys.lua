local addonName, addon = ...

addon.toys = {}

function addon.toys:GetItemID(itemLink)
    if type(itemLink) == "string" then
        return tonumber(itemLink:match("item:(%d+)"))
    elseif type(itemLink) == "number" then
        return itemLink
    end
    return nil
end

function addon.toys:IsItemToy(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then return false end
    
    return C_ToyBox.GetToyInfo(itemID) ~= nil
end

function addon.toys:IsToyCollected(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then return false end
    
    return PlayerHasToy(itemID)
end

function addon.toys:DebugToy(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then
        print("HideCollectedThings: Invalid itemID for", tostring(itemLink))
        return
    end

    print("HideCollectedThings: Debugging toy", itemID)
    print("IsItemToy:", self:IsItemToy(itemLink))
    print("IsToyCollected:", self:IsToyCollected(itemLink))
    
    local toyInfo = C_ToyBox.GetToyInfo(itemID)
    if type(toyInfo) == "table" then
        print("Toy info:", table.concat({tostring(toyInfo[1]), tostring(toyInfo[2]), tostring(toyInfo[3]), tostring(toyInfo[4]), tostring(toyInfo[5]), tostring(toyInfo[6])}, ", "))
    else
        print("Toy info:", tostring(toyInfo))
    end
    
    print("PlayerHasToy:", PlayerHasToy(itemID))
end

-- Event listener for toy updates
local function OnToyUpdate(self, event)
    if event ~= "NEW_TOY_ADDED" and event ~= "TOYS_UPDATED" then return end
    if addon.ResetCaches then
        addon:ResetCaches()
    end
    if addon.SafeUpdateMerchantFrame then
        addon:SafeUpdateMerchantFrame()
    end
end

local toyEventFrame = CreateFrame("Frame")
toyEventFrame:RegisterEvent("NEW_TOY_ADDED")
toyEventFrame:RegisterEvent("TOYS_UPDATED")
toyEventFrame:SetScript("OnEvent", OnToyUpdate)

-- Add a slash command to debug toys
SLASH_DEBUGTOY1 = "/debugtoy"
SlashCmdList["DEBUGTOY"] = function(msg)
    addon.toys:DebugToy(msg)
end

print("HideCollectedThings: Toys module loaded. Use /debugtoy [itemLink] to debug a specific toy.")
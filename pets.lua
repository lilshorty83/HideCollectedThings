local addonName, addon = ...

addon.pets = {}

function addon.pets:GetItemID(itemLink)
    if type(itemLink) == "string" then
        return tonumber(itemLink:match("item:(%d+)"))
    elseif type(itemLink) == "number" then
        return itemLink
    end
    return nil
end

function addon.pets:IsItemPet(itemLink)
    local itemID = self:GetItemID(itemLink)
    if itemID == nil then
        -- Check to see if it's a pet cage.
        if string.find(itemLink, "battlepet:") then
            return true
        end
        return false
    end
    if C_PetJournal.GetPetInfoByItemID(itemID) then
        return true
    end
    return false
end

function addon.pets:PlayerKnowsPet(itemLink)
    local itemID = self:GetItemID(itemLink)
    local speciesID
    if itemID ~= nil then
        speciesID = select(13, C_PetJournal.GetPetInfoByItemID(itemID))
    else
        _, _, speciesID = string.find(itemLink, "battlepet:(%d+)")
        if speciesID ~= nil then
            speciesID = tonumber(speciesID)
        end
    end
    if speciesID == nil then return false end
    local numCollected = C_PetJournal.GetNumCollectedInfo(speciesID)
    return numCollected > 0
end

-- Event listener for pet updates
local function OnPetUpdate(self, event)
    if event ~= "PET_JOURNAL_LIST_UPDATE" then return end
    if addon.ResetCaches then
        addon:ResetCaches()
    end
    if addon.SafeUpdateMerchantFrame then
        addon:SafeUpdateMerchantFrame()
    end
end

local petEventFrame = CreateFrame("Frame")
petEventFrame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
petEventFrame:SetScript("OnEvent", OnPetUpdate)

function addon.pets:DebugPet(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then
        print("HideCollectedThings: Invalid itemID for", tostring(itemLink))
        return
    end

    print("HideCollectedThings: Debugging pet", itemID)
    print("IsItemPet:", self:IsItemPet(itemLink))
    print("PlayerKnowsPet:", self:PlayerKnowsPet(itemLink))
    
    local speciesID = C_PetJournal.GetPetInfoByItemID(itemID)
    print("SpeciesID:", speciesID)
    
    if speciesID then
        local numCollected, limit = C_PetJournal.GetNumCollectedInfo(speciesID)
        print("NumCollected:", numCollected)
        print("CollectionLimit:", limit)
    end
end

-- Add a slash command to debug pets
SLASH_DEBUGPET1 = "/debugpet"
SlashCmdList["DEBUGPET"] = function(msg)
    addon.pets:DebugPet(msg)
end

print("HideCollectedThings: Pets module loaded. Use /debugpet [itemLink] to debug a specific pet.")
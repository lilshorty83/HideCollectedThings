local addonName, addon = ...

addon.ensembles = {}

function addon.ensembles:GetItemID(itemLink)
    if type(itemLink) == "string" then
        return tonumber(itemLink:match("item:(%d+)"))
    elseif type(itemLink) == "number" then
        return itemLink
    end
    return nil
end

function addon.ensembles:IsItemEnsemble(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then return false end
    
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemID))
    if not sourceID then return false end
    
    local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
    return sourceInfo and sourceInfo.sourceType == Enum.TransmogCollectionType.Set
end

function addon.ensembles:IsEnsembleCollected(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then return false end
    
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemID))
    if not sourceID then return false end
    
    local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
    if not sourceInfo or sourceInfo.sourceType ~= Enum.TransmogCollectionType.Set then
        return false
    end
    
    local setID = sourceInfo.visualID
    local setInfo = C_TransmogSets.GetSetInfo(setID)
    return setInfo and setInfo.collected
end

function addon.ensembles:DebugEnsemble(itemLink)
    local itemID = self:GetItemID(itemLink)
    if not itemID then
        print("HideCollectedThings: Invalid itemID for", tostring(itemLink))
        return
    end

    print("HideCollectedThings: Debugging ensemble", itemID)
    print("IsItemEnsemble:", self:IsItemEnsemble(itemLink))
    print("IsEnsembleCollected:", self:IsEnsembleCollected(itemLink))
    
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemID))
    print("SourceID:", sourceID)
    
    if sourceID then
        local sourceInfo = C_TransmogCollection.GetSourceInfo(sourceID)
        print("SourceInfo:", sourceInfo and "Available" or "Not Available")
        if sourceInfo then
            print("SourceType:", sourceInfo.sourceType)
            print("VisualID (SetID):", sourceInfo.visualID)
            
            local setID = sourceInfo.visualID
            local setInfo = C_TransmogSets.GetSetInfo(setID)
            if setInfo then
                print("Set Name:", setInfo.name)
                print("Set Collected:", setInfo.collected)
            end
        end
    end
end

-- Add a slash command to debug ensembles
SLASH_DEBUGENSEMBLE1 = "/debugensemble"
SlashCmdList["DEBUGENSEMBLE"] = function(msg)
    addon.ensembles:DebugEnsemble(msg)
end

print("HideCollectedThings: Ensembles module loaded. Use /debugensemble [itemLink] to debug a specific ensemble.")
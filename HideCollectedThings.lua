local addonName, addon = ...
HideCollectedThings = addon

-- Load modules
addon.mounts = addon.mounts or {}
addon.pets = addon.pets or {}
addon.toys = addon.toys or {}
addon.cosmetics = addon.cosmetics or {}
addon.ensembles = addon.ensembles or {}
addon.button = addon.button or {}

-- Initialize saved variables
addon.db = HideCollectedThingsDB or {}

-- Settings
addon.settings = {
    hideCollected = true, -- Default value
    showButton = true -- Default to showing the button
}

-- Cache for collected appearances and collectible items
addon.collectedCache = {}
addon.collectibleCache = {}

function addon:LoadSettings()
    if self.db.hideCollected ~= nil then
        self.settings.hideCollected = self.db.hideCollected
    end
    if self.db.showButton ~= nil then
        self.settings.showButton = self.db.showButton
    end
end

function addon:SaveSettings()
    self.db.hideCollected = self.settings.hideCollected
    self.db.showButton = self.settings.showButton
end

function addon:IsItemCollectible(itemLink)
    if not itemLink then return false end
    
    if self.collectibleCache[itemLink] ~= nil then
        return self.collectibleCache[itemLink]
    end
    
    if self.mounts:IsItemMount(itemLink) or self.pets:IsItemPet(itemLink) or self.toys:IsItemToy(itemLink) or self.cosmetics:IsItemCosmetic(itemLink) then
        self.collectibleCache[itemLink] = true
        return true
    end
    
    self.collectibleCache[itemLink] = false
    return false
end

function addon:IsItemCollected(itemLink)
    if not itemLink or not self:IsItemCollectible(itemLink) then 
        return false 
    end
    
    if self.collectedCache[itemLink] ~= nil then
        return self.collectedCache[itemLink]
    end
    
    if self.mounts:IsItemMount(itemLink) then
        self.collectedCache[itemLink] = self.mounts:IsMountKnown(itemLink)
        return self.collectedCache[itemLink]
    end
    
    if self.pets:IsItemPet(itemLink) then
        self.collectedCache[itemLink] = self.pets:PlayerKnowsPet(itemLink)
        return self.collectedCache[itemLink]
    end
    
    if self.toys:IsItemToy(itemLink) then
        self.collectedCache[itemLink] = self.toys:IsToyCollected(itemLink)
        return self.collectedCache[itemLink]
    end
    
    if self.cosmetics:IsItemCosmetic(itemLink) then
        self.collectedCache[itemLink] = self.cosmetics:IsCosmeticCollected(itemLink)
        return self.collectedCache[itemLink]
    end
    
	if self.ensembles:IsItemEnsemble(itemLink) then
        self.collectedCache[itemLink] = self.ensembles:IsEnsembleCollected(itemLink)
        return self.collectedCache[itemLink]
    end
	
    self.collectedCache[itemLink] = false
    return false
end

function addon:ShouldHideItem(itemLink)
    return self.settings.hideCollected and self:IsItemCollectible(itemLink) and self:IsItemCollected(itemLink)
end

function addon:GetVisibleItems()
    local visibleItems = {}
    local numItems = GetMerchantNumItems()
    
    for i = 1, numItems do
        local itemLink = GetMerchantItemLink(i)
        if not self:ShouldHideItem(itemLink) then
            table.insert(visibleItems, i)
        end
    end
    
    return visibleItems
end

function addon:GetItemQuality(itemLink)
    if not itemLink then return 1 end
    local _, _, quality = GetItemInfo(itemLink)
    return quality or 1
end

function addon:SetItemNameColor(button, itemLink)
    if button.Name then
        local quality = self:GetItemQuality(itemLink)
        local r, g, b = GetItemQualityColor(quality)
        button.Name:SetTextColor(r, g, b)
    end
end

function addon:UpdateMerchantItems()
    if not MerchantFrame:IsVisible() then return end

    local visibleItems = self:GetVisibleItems()
    local itemsPerPage = MERCHANT_ITEMS_PER_PAGE
    local numPages = math.max(1, math.ceil(#visibleItems / itemsPerPage))

    MerchantFrame.page = math.min(math.max(1, MerchantFrame.page), numPages)
    local currentPage = MerchantFrame.page

    MerchantPageText:SetFormattedText(MERCHANT_PAGE_NUMBER, currentPage, numPages)
    MerchantPrevPageButton:SetShown(currentPage > 1)
    MerchantNextPageButton:SetShown(currentPage < numPages)

    local startIndex = (currentPage - 1) * itemsPerPage + 1
    for i = 1, itemsPerPage do
        local merchantButton = _G["MerchantItem" .. i]
        local itemButton = merchantButton.ItemButton

        local visibleIndex = startIndex + i - 1
        
        if visibleIndex <= #visibleItems then
            local originalIndex = visibleItems[visibleIndex]
            local itemLink = GetMerchantItemLink(originalIndex)
            local name, texture, price, quantity, numAvailable, isPurchasable, isUsable, extendedCost = GetMerchantItemInfo(originalIndex)
            
            merchantButton:Show()
            merchantButton:SetID(originalIndex)
            merchantButton.itemLink = itemLink
            merchantButton.originalIndex = originalIndex
            
            if itemButton then
                SetItemButtonTexture(itemButton, texture)
                SetItemButtonCount(itemButton, quantity)
                SetItemButtonStock(itemButton, numAvailable)
                itemButton.link = itemLink
                itemButton:SetID(originalIndex)

                if not isPurchasable then
                    itemButton.icon:SetVertexColor(1, 0, 0)
                else
                    itemButton.icon:SetVertexColor(1, 1, 1)
                end

                local quality = self:GetItemQuality(itemLink)
                SetItemButtonQuality(itemButton, quality, itemLink)
            end
            
            if merchantButton.Name then
                merchantButton.Name:SetText(name)
                self:SetItemNameColor(merchantButton, itemLink)
            end
            
            local moneyFrame = _G["MerchantItem"..i.."MoneyFrame"]
            local altCurrencyFrame = _G["MerchantItem"..i.."AltCurrencyFrame"]
            local extendedCostFrame = merchantButton.extendedCost

            if price and price > 0 then
                moneyFrame:Show()
                MoneyFrame_Update(moneyFrame:GetName(), price)
            else
                moneyFrame:Hide()
            end

            if extendedCost then
                if extendedCostFrame then
                    extendedCostFrame:Show()
                end
                if altCurrencyFrame then
                    altCurrencyFrame:Show()
                end
                MerchantFrame_UpdateAltCurrency(originalIndex, i)
            else
                if extendedCostFrame then
                    extendedCostFrame:Hide()
                end
                if altCurrencyFrame then
                    altCurrencyFrame:Hide()
                end
            end

            if itemButton then
                itemButton:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                    GameTooltip:SetMerchantItem(self:GetParent().originalIndex or self:GetID())
                end)
            end
        else
            merchantButton:Hide()
            local moneyFrame = _G["MerchantItem"..i.."MoneyFrame"]
            local altCurrencyFrame = _G["MerchantItem"..i.."AltCurrencyFrame"]
            if moneyFrame then moneyFrame:Hide() end
            if altCurrencyFrame then altCurrencyFrame:Hide() end
        end
    end

    if CanIMogIt and MerchantFrame_CIMIOnClick then
        MerchantFrame_CIMIOnClick()
    end
end

-- Hook our function to the original MerchantFrame_Update
hooksecurefunc("MerchantFrame_Update", function()
    addon:UpdateMerchantItems()
end)

function addon:SafeUpdateMerchantFrame()
    MerchantFrame_Update()
    self:UpdateMerchantItems()
    C_Timer.After(0.1, function()
        self:UpdateMerchantItems()
    end)
end

function addon:ForceUpdateItemNameColor(index)
    local merchantButton = _G["MerchantItem" .. index]
    if merchantButton then
        local itemLink = GetMerchantItemLink(merchantButton:GetID())
        if itemLink then
            self:SetItemNameColor(merchantButton, itemLink)
        end
    end
end

function addon:HookMerchantFrame()
    MerchantFrame:HookScript("OnShow", function() self.button:UpdateVisibility() end)
    MerchantFrame:HookScript("OnHide", function() self.button:UpdateVisibility() end)
end

function addon:ResetCaches()
    self.collectedCache = {}
    self.collectibleCache = {}
end

function addon:OnInitialize()
    self:LoadSettings()
    self.button:Create()
    self:HookMerchantFrame()
    self.button:UpdateVisibility()
    print("|cFF00FF00HideCollectedThings:|r Addon loaded. Use /hct to toggle hiding collected items.")
    print("|cFF00FF00HideCollectedThings:|r Currently " .. (self.settings.hideCollected and "hiding" or "showing") .. " collected items.")
    print("|cFF00FF00HideCollectedThings:|r Use /hct button to toggle the button visibility.")
    self:SafeUpdateMerchantFrame()
    
    -- Debug: Check if MerchantFrame exists
    if MerchantFrame then
        print("|cFF00FF00HideCollectedThings:|r MerchantFrame exists")
    else
        print("|cFF00FF00HideCollectedThings:|r MerchantFrame does not exist")
    end
end

function addon:NEW_TOY_ADDED()
    self:ResetCaches()
    if MerchantFrame:IsShown() then
        self:SafeUpdateMerchantFrame()
    end
end

-- Slash command to toggle hiding collected items
SLASH_HIDECOLLECTEDTHINGS1 = "/hct"
SlashCmdList["HIDECOLLECTEDTHINGS"] = function(msg)
    if msg == "button" then
        addon.settings.showButton = not addon.settings.showButton
        print("|cFF00FF00HideCollectedThings:|r Button " .. (addon.settings.showButton and "shown" or "hidden"))
        addon.button:UpdateVisibility()
        addon:SaveSettings()
    elseif msg == "show" then
        addon.button:ForceShow()
    else
        addon.settings.hideCollected = not addon.settings.hideCollected
        addon:SaveSettings()
        addon:ResetCaches()
        print("|cFF00FF00HideCollectedThings:|r " .. (addon.settings.hideCollected and "ON - Hiding collected things" or "OFF - Showing all items"))
        addon:SafeUpdateMerchantFrame()
        C_Timer.After(0.5, function()
            for i = 1, MERCHANT_ITEMS_PER_PAGE do
                addon:ForceUpdateItemNameColor(i)
            end
        end)
    end
end

-- Hook the MerchantFrame_UpdateMerchantInfo function
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function() addon:UpdateMerchantItems() end)

-- Hook the MerchantFrame_Update function to handle page changes
hooksecurefunc("MerchantFrame_Update", function() 
    addon:UpdateMerchantItems()
    C_Timer.After(0.1, function()
        for i = 1, MERCHANT_ITEMS_PER_PAGE do
            addon:ForceUpdateItemNameColor(i)
        end
    end)
end)

-- Hook the MerchantNextPageButton and MerchantPrevPageButton
MerchantNextPageButton:HookScript("OnClick", function() addon:SafeUpdateMerchantFrame() end)
MerchantPrevPageButton:HookScript("OnClick", function() addon:SafeUpdateMerchantFrame() end)

-- Register for events
local function OnEvent(self, event, ...)
    if event == "MERCHANT_SHOW" or event == "NEW_TOY_ADDED" or event == "TRANSMOG_COLLECTION_UPDATED" then
        addon:SafeUpdateMerchantFrame()
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("MERCHANT_SHOW")
eventFrame:RegisterEvent("NEW_TOY_ADDED")
eventFrame:RegisterEvent("TRANSMOG_COLLECTION_UPDATED")
eventFrame:SetScript("OnEvent", OnEvent)

-- Register for CanIMogIt's OptionUpdate message
if CanIMogIt and CanIMogIt.RegisterMessage then
    CanIMogIt:RegisterMessage("OptionUpdate", function() addon:SafeUpdateMerchantFrame() end)
end

-- Register for PLAYER_LOGIN event
local loginFrame = CreateFrame("Frame")
loginFrame:RegisterEvent("PLAYER_LOGIN")
loginFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        addon:OnInitialize()
    end
end)
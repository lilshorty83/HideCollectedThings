local addonName, addon = ...

local button = {}
addon.button = button

function button:LoadPosition()
    self.frame:ClearAllPoints()
    self.frame:SetPoint("TOPRIGHT", MerchantFrame, "TOPRIGHT", -170, -30)
end

function button:Create()
    if not self.frame then
        self.frame = CreateFrame("Button", "HideCollectedThingsButton", MerchantFrame, "UIPanelButtonTemplate")
        self.frame:SetSize(25, 25)
        self.frame:SetText("HCT")
        
        self:LoadPosition()
        
        self.frame:SetScript("OnClick", function()
            SlashCmdList["HIDECOLLECTEDTHINGS"]()
        end)
        self.frame:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:AddLine("Hide Collected Things")
            GameTooltip:AddLine("Click to toggle hiding collected items", 1, 1, 1)
            GameTooltip:Show()
        end)
        self.frame:SetScript("OnLeave", GameTooltip_Hide)
        
        self.frame:SetFrameStrata("HIGH")
        self.frame:SetFrameLevel(100)
		
        
       -- print("|cFF00FF00HideCollectedThings:|r Button created")
    else
       -- print("|cFF00FF00HideCollectedThings:|r Button already exists")
    end
    
    self.frame:Show()
    print("|cFF00FF00HideCollectedThings:|r Button visibility:", self.frame:IsVisible())
end

function button:UpdateVisibility()
    if self.frame then
        if MerchantFrame:IsVisible() then
            self.frame:Show()
          --  print("|cFF00FF00HideCollectedThings:|r Button shown")
        else
            self.frame:Hide()
          --  print("|cFF00FF00HideCollectedThings:|r Button hidden")
        end
    else
       -- print("|cFF00FF00HideCollectedThings:|r Button does not exist")
    end
end

function button:ForceShow()
    if self.frame then
        self.frame:SetParent(MerchantFrame)
        self:LoadPosition()
        self.frame:Show()
      --  print("|cFF00FF00HideCollectedThings:|r Button forcibly shown")
    else
       -- print("|cFF00FF00HideCollectedThings:|r Button does not exist for force show")
    end
end

return button
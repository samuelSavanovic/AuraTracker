--init storage
if AA_config == nil then
    AA_config = {}
end

local buffs = {
    ["Horn of Winter"] = true,
    ["Frost Presence"] = true,
}

SLASH_AURAALERT1 = "/atrack"
SlashCmdList["AURAALERT"] = function(buff) 
    buffs.insert(buff, true)
end



--create frame
if not alertFrame then
    CreateFrame("Frame", "alertFrame", UIParent )
    alertFrame:SetWidth(200)
    alertFrame:SetHeight(70)
    alertFrame:SetPoint("CENTER", UIParent, "CENTER")
    alertFrame:SetFrameStrata("HIGH")
    
    alertFrame.title = 
    alertFrame:CreateFontString("alertFrame_Title", "OVERLAY",
     "GameFontNormal")
    alertFrame.title:SetFont("Fonts\\MORPHEUS.ttf",60)
    alertFrame.title:SetTextColor(1,0,0)
    alertFrame.title:SetPoint("TOP", 0, 0)
    alertFrame.title:SetText(nil)
end

--register leavint/entering combat
alertFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
alertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
alertFrame:RegisterEvent("UNIT_AURA")

local total = 0
function alertFrame_OnEvent(self, event, ...) 
    --entered combat
    if event == "PLAYER_REGEN_DISABLED" then
        local missingBuffs = ""
        local doesntHaveTracked = true 
        for i=1,40 do 
            local B=UnitBuff("player",i);
            if buffs[B] then 
                total = 0
                doesntHaveTracked = false
            end 
        end
        if doesntHaveTracked then
            alertFrame.title:SetText("NO FROST PRESENCE")
        else
            alertFrame.title:SetText(nil)
        end 
    
    end
end

local function onUpdate(self,elapsed)
    total = total + elapsed
    if total >= 10 then
        alertFrame.title:SetText(nil)
        total = 0
    end
end
alertFrame:SetScript("OnEvent", alertFrame_OnEvent)
alertFrame:SetScript("OnUpdate", onUpdate)
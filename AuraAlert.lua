--init storage
if AA_config == nil then
    AA_config = {}
end


local buffs = {
    ["Horn of Winter"] = true,
    ["Frost Presence"] = true
}

function table.removeKey(t, k_to_remove)
    local new = {}
    for k, v in pairs(t) do
      new[k] = v
    end
    new[k_to_remove] = nil
    return new
end


local delay = 10


SLASH_AURAALERT1 = "/atrack"
SlashCmdList["AURAALERT"] = function(buff) 
    buffs[buff] = true
    print("Currently tracking:")
    for b in pairs(buffs) do 
        print(b)
    end
end

SLASH_AURAREMOVE1 = "/atrackremove"
SlashCmdList["AURAREMOVE"] = function(buff) 
    buffs = table.removeKey(buffs, buff)
    print("Currently tracking:")
    for b in pairs(buffs) do 
        print(b)
    end
end

SLASH_AURADELAY1 = "/adelay"
SlashCmdList["AURADELAY"] = function(del) 
    delay = del
    print("Warning delay set to: ", delay)
end

SLASH_AURAHELP1 ="/ahelp"
SlashCmdList["AURAHELP"] = function() 
    print("/atrack buff/aura - adds buff or aura to tracker /atrack Blessing of Might")
    print("/atrackremove buff/aura - removes buff or aura from tracker /atrackremove Blessing of Might")
    print("/adelay seconds - sets how long warning will be displayed /adelay 5")
end




--create frame
if not alertFrame then
    CreateFrame("Frame", "alertFrame", UIParent )
    alertFrame:SetWidth(400)
    alertFrame:SetHeight(100)
    alertFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 100)
    alertFrame:SetFrameStrata("HIGH")
    
    alertFrame.title = 
    alertFrame:CreateFontString("alertFrame_Title", "OVERLAY",
     "GameFontNormal")
    alertFrame.title:SetFont("Fonts\\MORPHEUS.ttf",40)
    alertFrame.title:SetTextColor(1,0,0)
    alertFrame.title:SetPoint("TOP", 0, 0)
    alertFrame.title:SetText(nil)
end

alertFrame:RegisterEvent("UNIT_AURA")
alertFrame:RegisterEvent("PLAYER_REGEN_ENABLED") 
alertFrame:RegisterEvent("PLAYER_REGEN_DISABLED")

local total  = 0
local toDisplay = ""
function alertFrame_OnEvent(self, event, ...)
    if event == "UNIT_AURA" then
        for buff in pairs(buffs) do
            if UnitBuff("player", buff) then
                
            else 
                toDisplay = strjoin("\n", toDisplay, buff)
            end
        end
        total = 0
        alertFrame.title:SetText(toDisplay)
        toDisplay = ""
    end
end
local function alertFrame_OnUpdate(self,elapsed)
    total = total + elapsed
    if total >= delay then
        alertFrame.title:SetText(nil)
        total = 0
    end
end

alertFrame:SetScript("OnEvent", alertFrame_OnEvent)
alertFrame:SetScript("OnUpdate", alertFrame_OnUpdate)
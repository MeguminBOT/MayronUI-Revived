-- luacheck: ignore self 143 631
local MayronUI = _G.MayronUI;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents(); -- luacheck: ignore

local InCombatLockdown, CreateFrame = _G.InCombatLockdown, _G.CreateFrame;
local HasArtifactEquipped, GetWatchedFactionInfo = _G.HasArtifactEquipped, _G.GetWatchedFactionInfo;
local UnitXP, UnitXPMax, GetXPExhaustion = _G.UnitXP, _G.UnitXPMax, _G.GetXPExhaustion;
local C_ArtifactUI, GameTooltip = _G.C_ArtifactUI, _G.GameTooltip;
local GetNumPurchasableArtifactTraits = _G.ArtifactBarGetNumArtifactTraitsPurchasableFromXP;

-- Constants -----------------------------

local BAR_NAMES = {"reputation", "experience", "artifact"};

-- Setup Objects -------------------------

local Engine = obj:Import("MayronUI.Engine");

local BottomUIPackage = obj:CreatePackage("BottomUI");
Engine:AddSubPackage(BottomUIPackage);

local C_BaseResourceBar = BottomUIPackage:CreateClass("BaseResourceBar", "Framework.System.FrameWrapper");
local C_ExperienceBar = BottomUIPackage:CreateClass("ExperienceBar", C_BaseResourceBar);
local C_ReputationBar = BottomUIPackage:CreateClass("ReputationBar", C_BaseResourceBar);
local C_ArtifactBar = BottomUIPackage:CreateClass("ArtifactBar", C_BaseResourceBar);

-- Register and Import Modules -----------

local C_ResourceBarsModule = MayronUI:RegisterModule("BottomUI_ResourceBars", "Resource Bars", true);

-- Load Database Defaults ----------------

db:AddToDefaults("profile.resourceBars", {
    enabled = true,
    experienceBar = {
        enabled = true,
        height = 8,
        alwaysShowText = false,
        fontSize = 8,
    },
    reputationBar = {
        enabled = true,
        height = 8,
        alwaysShowText = false,
        fontSize = 8,
    },
    artifactBar = {
        enabled = true,
        height = 8,
        alwaysShowText = false,
        fontSize = 8,
    }
});

-- C_ResourceBarsModule -------------------
function C_ResourceBarsModule:OnInitialize(data, buiContainer)
    data.buiContainer = buiContainer;

    local setupOptions = {
        first = {
            "experienceBar.enabled";
            "reputationBar.enabled";
            "artifactBar.enabled";
        };
        ignore = {
            ".*"; -- ignore everything else
        }
    };

    local function UpdateExperienceBar()
        if (data.bars and data.bars["experience"]) then
            data.bars["experience"]:Update();
        end
    end

    local function UpdateReputationBar()
        if (data.bars and data.bars["reputation"]) then
            data.bars["reputation"]:Update();
        end
    end

    local function UpdateArtifactBar()
        if (data.bars and data.bars["artifact"]) then
            data.bars["artifact"]:Update();
        end
    end

    self:RegisterUpdateFunctions(db.profile.resourceBars, {
        experienceBar = {
            enabled = function(value)
                data.bars.experience:SetEnabled(value);
            end;

            height = UpdateExperienceBar;
            alwaysShowText = UpdateExperienceBar;
            fontSize = UpdateExperienceBar;
        };

        reputationBar = {
            enabled = function(value)
                data.bars.reputation:SetEnabled(value);
            end;

            height = UpdateReputationBar;
            alwaysShowText = UpdateReputationBar;
            fontSize = UpdateReputationBar;
        };

        artifactBar = {
            enabled = function(value)
                data.bars.artifact:SetEnabled(value);
            end;

            height = UpdateArtifactBar;
            alwaysShowText = UpdateArtifactBar;
            fontSize = UpdateArtifactBar;
        };
    }, setupOptions);

    if (data.settings.enabled) then
        self:SetEnabled(true);
    end
end

function C_ResourceBarsModule:OnEnable(data)
    if (data.barsContainer) then
        data.barsContainer:Show(); -- TODO: Needs to be tested
        return;
    end

    data.barsContainer = CreateFrame("Frame", "MUI_ResourceBars", data.buiContainer);
    data.barsContainer:SetFrameStrata("MEDIUM");
    data.barsContainer:SetPoint("BOTTOMLEFT", data.buiContainer, "TOPLEFT", 0, -1);
    data.barsContainer:SetPoint("BOTTOMRIGHT", data.buiContainer, "TOPRIGHT", 0, -1);

    data.bars = obj:PopWrapper();
    data.bars.experience = C_ExperienceBar(self, data);
    data.bars.reputation = C_ReputationBar(self, data);
    data.bars.artifact = C_ArtifactBar(self, data);

    MayronUI:Hook("DataText", "OnEnable", function(dataTextModule, dataTextModuleData)
        dataTextModule:RegisterUpdateFunctions(db.profile.datatext, {
            blockInCombat = function(value)
                self:SetBlockerEnabled(value, dataTextModuleData.bar);
            end;
        });
    end);
end

function C_ResourceBarsModule:UpdateContainer(data)
    local height = 0;
    local previousFrame;

    for _, barName in ipairs(BAR_NAMES) do

        -- check if bar was ever enabled
        if (data.bars[barName]) then
            local bar = data.bars[barName];
            local frame = bar:GetFrame();

            -- check if frame has been frame (bar has been built)
            if (frame) then
                if (bar:IsEnabled()) then
                    frame:ClearAllPoints();

                    if (not previousFrame) then
                        frame:SetPoint("BOTTOMLEFT");
                        frame:SetPoint("BOTTOMRIGHT");
                    else
                        frame:SetPoint("BOTTOMLEFT", previousFrame, "TOPLEFT", 0, -1);
                        frame:SetPoint("BOTTOMRIGHT", previousFrame, "TOPRIGHT", 0, -1);
                        height = height - 1;
                    end

                    height = height + frame:GetHeight();
                    previousFrame = frame;
                    frame:Show();

                else
                    frame:SetAllPoints(tk.Constants.DUMMY_FRAME);
                    frame:Hide();
                end
            end
        end
    end

    if (height == 0) then
        height = 1;
    end

    data.barsContainer:SetHeight(height);
end

Engine:DefineReturns("number");
function C_ResourceBarsModule:GetHeight(data)
    if (data.barsContainer) then
        return data.barsContainer:GetHeight();
    end

    return 0;
end

Engine:DefineParams("string");
Engine:DefineReturns("Frame");
function C_ResourceBarsModule:GetBar(data, barName)
    return data.bars[barName];
end

function C_ResourceBarsModule:SetBlockerEnabled(data, enabled, dataTextBar)
    if (not data.blocker and enabled) then
        data.blocker = tk:PopFrame("Frame", data.barsContainer);
        data.blocker:SetPoint("TOPLEFT");
        data.blocker:SetPoint("BOTTOMRIGHT", dataTextBar, "BOTTOMRIGHT");
        data.blocker:EnableMouse(true);
        data.blocker:SetFrameStrata("DIALOG");
        data.blocker:SetFrameLevel(20);
        data.blocker:Hide();
    end

    if (enabled) then
        em:CreateEventHandlerWithKey("PLAYER_REGEN_ENABLED", "Blocker_RegenEnabled", function()
            data.blocker:Hide();
        end);

        em:CreateEventHandlerWithKey("PLAYER_REGEN_DISABLED", "Blocker_RegenDisabled", function()
            data.blocker:Show();
        end);

        if (InCombatLockdown()) then
            data.blocker:Show();
        end
    else
        em:DestroyHandlerByKey("Blocker_RegenEnabled");
        em:DestroyHandlerByKey("Blocker_RegenDisabled");

        if (data.blocker) then
            data.blocker:Hide();
        end
    end
end

Engine:DefineReturns("Frame");
function C_ResourceBarsModule:GetBarContainer(data)
    return data.barsContainer;
end

-- C_ResourceBar ---------------------------

BottomUIPackage:DefineParams("BottomUI_ResourceBars", "table", "string");
function C_BaseResourceBar:__Construct(data, barsModule, moduleData, barName)
    data.module = barsModule;
    data.barName = barName;
    data.settings = moduleData.settings[barName.."Bar"];
    data.barsContainer = moduleData.barsContainer;
    data.notCreated = true;
end

function C_BaseResourceBar:CreateBar(data)
    local texture = tk.Constants.LSM:Fetch("statusbar", "MUI_StatusBar");
    local frame = CreateFrame("Frame", "MUI_"..data.barName.."Bar", data.barsContainer);

    frame:SetBackdrop(tk.Constants.backdrop);
    frame:SetBackdropBorderColor(0, 0, 0);
    frame.bg = tk:SetBackground(frame, texture);
    frame.bg:SetVertexColor(0.08, 0.08, 0.08);
    frame:SetHeight(data.settings.height);

    local statusbar = CreateFrame("StatusBar", nil, frame);
    statusbar:SetStatusBarTexture(texture);
    statusbar:SetOrientation("HORIZONTAL");
    statusbar:SetPoint("TOPLEFT", 1, -1);
    statusbar:SetPoint("BOTTOMRIGHT", -1, 1);

    statusbar.texture = statusbar:GetStatusBarTexture();
    statusbar.text = statusbar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall");
    statusbar.text:SetPoint("CENTER");

    statusbar:SetScript("OnEnter", function(self)
        self.texture:SetBlendMode("ADD");
        if (data.blizzardBar) then
            data.blizzardBar:GetScript("OnEnter")(data.blizzardBar);
        end
    end);

    statusbar:SetScript("OnLeave", function(self)
        self.texture:SetBlendMode("BLEND");
        if (data.blizzardBar) then
            data.blizzardBar:GetScript("OnLeave")(data.blizzardBar);
        end
    end);

    data.frame = frame;
    data.statusbar = statusbar;
end

do
    local function OnEnter(self)
        self.text:Show();
    end

    local function OnLeave(self)
        self.text:Hide();
    end

    function C_BaseResourceBar:Update(data)
        data.frame:SetHeight(data.settings.height);
        tk:SetFontSize(data.statusbar.text, data.settings.fontSize);

        if (data.settings.alwaysShowText) then
            data.statusbar.text:Show();
            data.statusbar:SetScript("OnEnter", tk.Constants.DUMMY_FUNC);
            data.statusbar:SetScript("OnLeave", tk.Constants.DUMMY_FUNC);
        else
            data.statusbar.text:Hide();
            data.statusbar:SetScript("OnEnter", OnEnter);
            data.statusbar:SetScript("OnLeave", OnLeave);
        end
    end
end

BottomUIPackage:DefineReturns("number");
function C_BaseResourceBar:GetHeight(data)
    return data.frame:GetHeight();
end

BottomUIPackage:DefineReturns("boolean");
function C_BaseResourceBar:IsEnabled(data)
    return data.settings.enabled;
end

BottomUIPackage:DefineParams("boolean");
function C_BaseResourceBar:SetEnabled(data, enabled)
    print(data.barName)
    if (enabled) then
        if (not data.statusbar) then
            self:CreateBar();
        end

        self:Update();
    end

    data.module:UpdateContainer();
end

-- C_ExperienceBar ----------------------

local function OnExperienceBarUpdate(_, _, statusbar, rested)
    local currentValue = UnitXP("player");
    local maxValue = UnitXPMax("player");
    local exhaustValue = GetXPExhaustion();

    statusbar:SetMinMaxValues(0, maxValue);
    statusbar:SetValue(currentValue);
    rested:SetMinMaxValues(0, maxValue);
    rested:SetValue(exhaustValue and (exhaustValue + currentValue) or 0);

    local percent = (currentValue / maxValue) * 100;
    currentValue = tk.Strings:FormatReadableNumber(currentValue);
    maxValue = tk.Strings:FormatReadableNumber(maxValue);

    local text = tk.string.format("%s / %s (%d%%)", currentValue, maxValue, percent);
    statusbar.text:SetText(text);
end

local function OnExperienceBarLevelUp(handler, _, level)
    if (tk:GetMaxPlayerLevel() == level) then
        self:SetEnabled(false);
        em:DestroyHandlerByKey("OnExperienceBarUpdate");
        handler:Destroy();
    end
end

BottomUIPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_ExperienceBar:__Construct(data, barsModule, moduleData)
    self:Super(barsModule, moduleData, "experience");
    data.blizzardBar = _G.MainMenuExpBar;
end

BottomUIPackage:DefineParams("boolean");
function C_ExperienceBar:SetEnabled(data, enabled)
    self:Parent():SetEnabled(enabled);

    if (enabled) then
        if (data.notCreated) then
            data.rested = CreateFrame("StatusBar", nil, data.frame);
            data.rested:SetStatusBarTexture(tk.Constants.LSM:Fetch("statusbar", "MUI_StatusBar"));
            data.rested:SetPoint("TOPLEFT", 1, -1);
            data.rested:SetPoint("BOTTOMRIGHT", -1, 1);
            data.rested:SetOrientation("HORIZONTAL");

            data.rested.texture = data.rested:GetStatusBarTexture();
            data.rested.texture:SetVertexColor(0, 0.3, 0.5, 0.3);

            local r, g, b = tk:GetThemeColor();
            data.statusbar.texture:SetVertexColor(r * 0.8, g * 0.8, b  * 0.8);
            data.notCreated = nil;
        end

        em:CreateEventHandler("PLAYER_LEVEL_UP", "OnExperienceBarLevelUp", OnExperienceBarLevelUp, nil);
        em:CreateEventHandlerWithKey("PLAYER_XP_UPDATE", "OnExperienceBarUpdate",
            OnExperienceBarUpdate, nil, data.statusbar, data.rested);

        OnExperienceBarUpdate(nil, nil, data.statusbar, data.rested);
    else
        em:DestroyHandlerByKey("OnExperienceBarLevelUp");
        em:DestroyHandlerByKey("OnExperienceBarUpdate");
    end
end

-- C_ReputationBar ----------------------

local function OnReputationBarUpdate(statusbar)
    local factionName, _, minValue, maxValue, currentValue = GetWatchedFactionInfo();

    maxValue = maxValue - minValue;
    currentValue = currentValue - minValue;

    statusbar:SetMinMaxValues(0, maxValue);
    statusbar:SetValue(currentValue);

    if (statusbar.text) then
        local percent = (currentValue / maxValue) * 100;
        currentValue = tk.Strings:FormatReadableNumber(currentValue);
        maxValue = tk.Strings:FormatReadableNumber(maxValue);

        local text = tk.string.format("%s: %s / %s (%d%%)", factionName, currentValue, maxValue, percent);
        statusbar.text:SetText(text);
    end
end

local function ReputationBar_OnEnter(self)
    local factionName, standingID, minValue, maxValue, currentValue = GetWatchedFactionInfo();

    if (standingID < 8) then
        maxValue = maxValue - minValue;

        if (maxValue > 0) then
            currentValue = currentValue - minValue;
            local percent = (currentValue / maxValue) * 100;

            currentValue = tk.Strings:FormatReadableNumber(currentValue);
            maxValue = tk.Strings:FormatReadableNumber(maxValue);

            local text = tk.string.format("%s: %s / %s (%d%%)", factionName, currentValue, maxValue, percent);

            GameTooltip:SetOwner(self, "ANCHOR_TOP");
            GameTooltip:AddLine(text, 1, 1, 1);
            GameTooltip:Show();
        end
    end
end

BottomUIPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_ReputationBar:__Construct(_, barsModule, moduleData)
    self:Super(barsModule, moduleData, "reputation");
end

BottomUIPackage:DefineParams("boolean");
function C_ReputationBar:SetEnabled(data, enabled)
    self:Parent():SetEnabled(enabled);

    if (enabled) then
        if (data.notCreated) then
            data.statusbar:HookScript("OnEnter", ReputationBar_OnEnter);
            data.statusbar:HookScript("OnLeave", tk.GeneralTooltip_OnLeave);

            data.statusbar.texture = data.statusbar:GetStatusBarTexture();
            data.statusbar.texture:SetVertexColor(0.16, 0.6, 0.16, 1);
            data.notCreated = nil;
        end

        em:CreateEventHandler("UPDATE_FACTION, PLAYER_REGEN_ENABLED",
            "OnReputationBarUpdate", OnReputationBarUpdate, nil, data.statusbar);
    else
        em:DestroyHandlerByKey("OnReputationBarUpdate");
    end
end

-- C_ArtifactBar ----------------------

local function OnArtifactXPUpdate(_, _, statusbar)
    if (not HasArtifactEquipped()) then
        return;
    end

    local totalXP, pointsSpent, _, _, _, _, _, _, tier = select(5, C_ArtifactUI.GetEquippedArtifactInfo());
    local _, currentValue, maxValue = GetNumPurchasableArtifactTraits(pointsSpent, totalXP, tier);

    statusbar:SetMinMaxValues(0, maxValue);
    statusbar:SetValue(currentValue);

    if currentValue > 0 and maxValue == 0 then
        maxValue = currentValue;
    end

    local percent = (currentValue / maxValue) * 100;
    currentValue = tk.Strings:FormatReadableNumber(currentValue);
    maxValue = tk.Strings:FormatReadableNumber(maxValue);

    local text = string.format("%s / %s (%d%%)", currentValue, maxValue, percent);
    statusbar.text:SetText(text);
end

BottomUIPackage:DefineParams("BottomUI_ResourceBars", "table");
function C_ArtifactBar:__Construct(data, barsModule, moduleData)
    self:Super(barsModule, moduleData, "artifact");
    data.blizzardBar = _G.ArtifactWatchBar;
end

BottomUIPackage:DefineParams("boolean");
function C_ArtifactBar:SetEnabled(data, enabled)

    print("sejilfgsdjk")
    self:Parent():SetEnabled(enabled);

    if (enabled) then
        print("YES")
        if (data.notCreated) then
            data.statusbar.texture = data.statusbar:GetStatusBarTexture();
            data.statusbar.texture:SetVertexColor(0.9, 0.8, 0.6, 1);
            data.notCreated = nil;
            print("YARRRHHH")
        end

        em:CreateEventHandlerWithKey("ARTIFACT_XP_UPDATE", "ArtifactXP_Update", OnArtifactXPUpdate, nil, data.statusbar);
        em:CreateEventHandlerWithKey("UNIT_INVENTORY_CHANGED", "Artifact_OnInventoryChanged", OnArtifactXPUpdate, nil, data.statusbar);
        OnArtifactXPUpdate(nil, nil, data.statusbar);
    else
        em:DestroyHandlerByKey("ArtifactXP_Update");
        em:DestroyHandlerByKey("Artifact_OnInventoryChanged");
    end
end
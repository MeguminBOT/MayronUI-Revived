-- Setup Namespaces ------------------

local _, namespace = ...;
local tk, db, em, gui, obj, L = MayronUI:GetCoreComponents();

local LABEL_PATTERN = "|cffffffff%s|r mb";

-- Register and Import Modules -------

local Engine = obj:Import("MayronUI.Engine");
local Memory = Engine:CreateClass("Memory", nil, "MayronUI.Engine.IDataTextModule");

-- Load Database Defaults ------------

db:AddToDefaults("profile.datatext.memory", {
    enabled = true,
    displayOrder = 5
});

-- Local Functions ----------------

local function CreateLabel(contentFrame, popupWidth)
    local label = tk:PopFrame("Frame", contentFrame);

    label.name = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.value = label:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    label.name:SetPoint("LEFT", 6, 0);
    label.name:SetPoint("Right", 6, 0);

    label.name:SetWidth(popupWidth * 0.6);
    label.name:SetWordWrap(false);
    label.name:SetJustifyH("LEFT");
    label.value:SetPoint("RIGHT", -10, 0);
    label.value:SetWidth(popupWidth * 0.4);
    label.value:SetWordWrap(false);
    label.value:SetJustifyH("RIGHT");
    tk:SetBackground(label, 0, 0, 0, 0.2);

    return label;
end

local function compare(a, b)
    return a.usage > b.usage;
end

-- Memory Module --------------

MayronUI:Hook("DataText", "OnInitialize", function(self, dataTextData)
    local sv = db.profile.datatext.memory;
    sv:SetParent(dataTextData.sv);

    if (sv.enabled) then
        local memory = Memory(sv, self);
        self:RegisterDataModule(memory);
    end
end);

function Memory:__Construct(data, sv, dataTextModule)
    data.sv = sv;
    data.displayOrder = sv.displayOrder;

    -- set public instance properties
    self.MenuContent = CreateFrame("Frame");
    self.MenuLabels = {};
    self.TotalLabelsShown = 0;
    self.HasLeftMenu = true;
    self.HasRightMenu = false;
    self.Button = dataTextModule:CreateDataTextButton(self);
end

function Memory:IsEnabled(data) 
    return data.sv.enabled;
end

function Memory:Enable(data) 
    data.sv.enabled = true;
end

function Memory:Disable(self)
    if (data.handler) then
        data.handler:Destroy();
    end

    self.Button:RegisterForClicks("LeftButtonUp");
end

function Memory:Update(data)
    if (data.executed) then 
        return; 
    end

    data.executed = true;

    local function loop()
        if (data.disabled) then 
            return; 
        end

        -- Must update first!
        UpdateAddOnMemoryUsage();
        local total = 0;

        for i = 1, GetNumAddOns() do
            total = total + GetAddOnMemoryUsage(i);
        end

        total = (total / 1000);
        total = tk.Numbers:ToPrecision(total, 2);

        self.Button:SetText(tk.string.format(LABEL_PATTERN, total));

        tk.C_Timer.After(10, loop);
    end

    loop();
end

function Memory:Click(data)
    tk.collectgarbage("collect");
    
    local currentIndex = 0;
    local sorted = {};    

    for i = 1, GetNumAddOns() do
        local _, name = GetAddOnInfo(i);
        local usage = GetAddOnMemoryUsage(i);

        if (usage > 1) then
            currentIndex = currentIndex + 1;

            local label = self.MenuLabels[currentIndex] or CreateLabel(self.MenuContent, data.sv.popup.width);
            local value;

            if (usage > 1000) then
                value = usage / 1000;
                value = tk.Numbers:ToPrecision(value, 1);
                value = string.format("%smb", value);
            else
                value = tk.Numbers:ToPrecision(usage, 0);
                value = string.format("%skb", value);
            end

            label.name:SetText(name);
            label.value:SetText(value);
            label.usage = usage;
        
            tk.table.insert(sorted, label);            
        end
    end

    table.sort(sorted, compare);
    tk.Tables:Empty(self.MenuLabels);
    tk.Tables:Fill(self.MenuLabels, unpack(sorted));

    self.TotalLabelsShown = #self.MenuLabels;
end

function Memory:GetDisplayOrder(data)
    return data.displayOrder;
end

function Memory:SetDisplayOrder(data, displayOrder)
    if (data.displayOrder ~= displayOrder) then
        data.displayOrder = displayOrder;
        data.sv.displayOrder = displayOrder;
    end
end 
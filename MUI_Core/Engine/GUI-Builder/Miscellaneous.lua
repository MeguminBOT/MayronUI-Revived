-- luacheck: ignore MayronUI self 143 631
local _G = _G;
local MayronUI = _G.MayronUI;
local tk, _, _, gui, obj = MayronUI:GetCoreComponents();

local string, hooksecurefunc, PlaySound, unpack, min, max =
  _G.string, _G.hooksecurefunc, _G.PlaySound, _G.unpack, _G.math.min, _G.math.max;

local function HandleShowingTooltipOnEnter(self)
  local tooltip = self.tooltip;
  local anchor = self.btn or self;

  if (not obj:IsString(self.tooltip)) then
    local parent = self:GetParent(); -- update anchor
    tooltip = parent.tooltip;
  end

  if (not obj:IsString(tooltip)) then
    return -- no tooltip to show
  end

  _G.GameTooltip:SetOwner(anchor, "ANCHOR_TOPLEFT", 4, 4);

  if (#tooltip > 100) then
    local minWidth = min(#tooltip, 400);
    _G.GameTooltip:SetMinimumWidth(minWidth);
  end

  _G.GameTooltip:AddLine(tooltip, nil, nil, nil, true);
  _G.GameTooltip:Show();
end

---@param parent Frame @(optional) The parent frame to give the new frame if frame param is nil
---@param alphaType string @(optional) the dialog box background type ("high", "medium", "low")
---@param frame Frame @(optional) A frame to apply the dialog box background texture to (a new one is created if nil)
---@param globalName string @(optional) A global name to give the new frame if frame param is nil
---@return Frame @The new frame (or existing frame if the frame param was supplied).
function gui:CreateDialogBox(parent, alphaType, frame, globalName)
  frame = frame or tk:CreateFrame("Frame", parent, globalName);
  frame:EnableMouse(true);

  alphaType = alphaType or "Medium";
  alphaType = alphaType:lower();
  alphaType = alphaType:gsub("^%l", string.upper);

  local style = tk.Constants.AddOnStyle;
  local texture = style:GetTexture("DialogBoxBackground");
  texture = string.format("%s%s", texture, alphaType);

  gui:CreateGridTexture(frame, texture, 10, 6, 512, 512);

  -- apply the theme color for each Grid Cell
  style:ApplyColor(
    nil, nil, frame.tl, frame.tr, frame.bl, frame.br, frame.t, frame.b, frame.l,
    frame.r, frame.c);
  frame:SetFrameStrata("DIALOG");

  return frame;
end

do
  local function OnButtonEnabled(self)
    local r, g, b = unpack(self.enabledBackdrop);
    self:SetBackdropBorderColor(r, g, b, 0.7);
  end

  local function OnButtonDisabled(self)
    local r, g, b = _G.DISABLED_FONT_COLOR:GetRGB();
    self:SetBackdropBorderColor(r, g, b, 0.6);
  end

  local function SetWidth(self)
    local fontString = self:GetFontString();

    local width = fontString:GetUnboundedStringWidth() + (self.padding);
    width = max(max(self.minWidth or 0, width), self:GetWidth());

    self:SetWidth(width);
    fontString:SetPoint("CENTER", self);
  end

  function gui:CreateButton(parent, text, button, tooltip, padding, minWidth)
    local style = tk.Constants.AddOnStyle;
    local backgroundTexture = style:GetTexture("ButtonTexture");

    button = button or tk:CreateFrame("Button", parent, nil, _G.BackdropTemplateMixin and "BackdropTemplate");
    button.tooltip = tooltip;
    button.padding = padding or 30;
    button.minWidth = minWidth;
    button:SetHeight(30);
    button:SetBackdrop(style:GetBackdrop("ButtonBackdrop"));

    local fs = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
    button:SetFontString(fs);
    hooksecurefunc(button, "SetText", SetWidth);

    if (text) then
      button:SetText(text);
    else
      button:SetWidth(minWidth or 150);
    end

    local normal = tk:SetBackground(button, backgroundTexture, nil, nil, nil, 1);
    local highlight = tk:SetBackground(button, backgroundTexture, nil, nil, nil, 1);
    local disabled = tk:SetBackground(button, backgroundTexture, nil, nil, nil, 1);

    button:SetNormalTexture(normal);
    button:SetHighlightTexture(highlight);
    button:SetDisabledTexture(disabled);

    button:SetNormalFontObject("GameFontHighlight");
    button:SetDisabledFontObject("GameFontDisable");

    if (tooltip) then
      button:SetScript("OnEnter", HandleShowingTooltipOnEnter);
      button:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
    end

    button:SetScript("OnEnable", OnButtonEnabled);
    button:SetScript("OnDisable", OnButtonDisabled);

    self:UpdateButtonColor(button, style);

    return button;
  end

  -- TODO: Should be deprecated and replacedby Style.lua > function Style:ApplyColor(_, colorName, alpha, ...)
  function gui:UpdateButtonColor(button, style)
    local r, g, b = style:GetColor();
    local normal = button:GetNormalTexture();
    local highlight = button:GetHighlightTexture();
    local disabled = button:GetDisabledTexture();

    button:SetBackdropBorderColor(r, g, b, 0.7);
    button.enabledBackdrop = obj:PopTable(r, g, b);

    normal:SetVertexColor(r * 0.6, g * 0.6, b * 0.6, 1);
    highlight:SetVertexColor(r, g, b, 0.2);

    local dr, dg, db = _G.DISABLED_FONT_COLOR:GetRGB();
    disabled:SetVertexColor(dr, dg, db, 0.6);

    if (button:IsEnabled()) then
      button:SetBackdropBorderColor(r, g, b, 0.7);
    else
      button:SetBackdropBorderColor(dr, dg, db, 0.6);
    end
  end
end

do
  local function OnCheckButtonSetEnabled(self, value)
    if (value) then
      self.text:SetFontObject("GameFontHighlight");
    else
      self.text:SetFontObject("GameFontDisable");
    end
  end

  local function OnCheckButtonEnter(self)
    local btn = self.btn or self;

    if (btn:IsEnabled()) then
      local container = btn:GetParent();
      container.background:SetVertexColor(0.7, 0.7, 0.7);
      container.color:SetBlendMode("ADD");
    end
  end

  local function OnCheckButtonLeave(self)
    local btn = self.btn or self;

    local container = btn:GetParent();
    container.background:SetVertexColor(1, 1, 1);
    container.color:SetBlendMode("BLEND");
  end

  local function UpdateColor(self, r, g, b, a)
    if (self.isSwatch) then
      self.r = r;
      self.g = g;
      self.b = b;
      self.a = a;
      self.color:SetVertexColor(r * a, g * a, b * a);
    else
      tk:ApplyThemeColor(self.color);
    end
  end

  function gui:CreateColorSwatchButton(parent, text, tooltip, globalName, verticalAlignment)
    local container = self:CreateCheckButton(parent, text, tooltip, globalName, verticalAlignment);
    container.isSwatch = true;
    container.btn:SetChecked(true);
    return container;
  end

  function gui:CreateCheckButton(parent, text, tooltip, globalName, verticalAlignment, radio)
    local container = tk:CreateFrame("Button", parent);
    container.tooltip = tooltip;

    container:SetSize(150, 30);

    container.btn = tk:CreateFrame("CheckButton", container, globalName, "UICheckButtonTemplate");
    container.btn:SetSize(20, 20);

    tk:KillElement(container.btn:GetHighlightTexture());

    local normalTexturePath, checkedTexturePath;

    if (radio) then
      normalTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\RadioButtonUnchecked");
      checkedTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\RadioButtonChecked");
    else
      normalTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\Unchecked");
      checkedTexturePath = tk:GetAssetFilePath("Textures\\Widgets\\Checked");
    end

    -- Normal Texture:
    container.btn:SetNormalTexture(normalTexturePath);
    container.background = container.btn:GetNormalTexture();
    container.background:SetAllPoints(true);

    -- Checked Texture:
    container.btn:SetCheckedTexture(checkedTexturePath);
    container.color = container.btn:GetCheckedTexture();
    container.color:SetAllPoints(true);

    -- Highlight Texture:
    container.btn:SetHighlightTexture("");
    container.btn.SetHighlightTexture = tk.Constants.DUMMY_FUNC;

    -- Pushed Textured:
    container.btn:SetPushedTexture(normalTexturePath);
    container.btn.SetPushedTexture = tk.Constants.DUMMY_FUNC;

    container.UpdateColor = UpdateColor;
    container:UpdateColor();

    if (tooltip) then
      container.tooltip = tooltip;
      container:SetScript("OnEnter", HandleShowingTooltipOnEnter);
      container:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
      container.btn:SetScript("OnEnter", HandleShowingTooltipOnEnter);
      container.btn:SetScript("OnLeave", tk.GeneralTooltip_OnLeave);
    end

    -- Handle Styling:
    container:HookScript("OnEnter", OnCheckButtonEnter);
    container:HookScript("OnLeave", OnCheckButtonLeave);
    container.btn:HookScript("OnEnter", OnCheckButtonEnter);
    container.btn:HookScript("OnLeave", OnCheckButtonLeave);

    container.btn.text:SetFontObject("GameFontHighlight");
    container.btn.text:ClearAllPoints();
    container.btn.text:SetPoint("LEFT", container.btn, "RIGHT", 6, 1);
    container.btn.text:SetHeight(18);

    if (verticalAlignment == "TOP") then
      container.btn:SetPoint("TOPLEFT");
    elseif (verticalAlignment == "BOTTOM") then
      container.btn:SetPoint("BOTTOMLEFT");
    else
      container.btn:SetPoint("LEFT");
    end

    hooksecurefunc(container.btn, "SetEnabled", OnCheckButtonSetEnabled);

    if (text) then
      container.btn.text:SetText(text);
      local width = container.btn.text:GetStringWidth();
      width = (width > 100) and width or 100;
      container:SetWidth(width + container.btn:GetWidth() + 20);
    end

    return container;
  end
end

-------------------------------
-- Extra Widget Enhancements
-------------------------------
do
  local function TitleBar_SetWidth(self)
    local bar = self:GetParent();
    local width = self:GetStringWidth() + 34;

    width = (width > 150 and width) or 150;
    bar:SetWidth(width);
  end

  function gui:AddTitleBar(frame, text)
    local style = tk.Constants.AddOnStyle;
    local texture = style:GetTexture("TitleBarBackground");

    frame.titleBar = tk:CreateFrame("Button", frame);
    frame.titleBar:SetSize(260, 31);
    frame.titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", -7, 11);
    frame.titleBar.bg = frame.titleBar:CreateTexture("ARTWORK");
    frame.titleBar.bg:SetTexture(texture);

    frame.titleBar.bg:SetAllPoints(true);
    frame.titleBar.text = frame.titleBar:CreateFontString(nil, "ARTWORK", "GameFontHighlight");

    frame.titleBar.text:SetSize(260, 31);
    frame.titleBar.text:SetPoint("LEFT", frame.titleBar.bg, "LEFT", 10, 0.5);
    frame.titleBar.text:SetJustifyH("LEFT");

    tk:MakeMovable(frame, frame.titleBar);
    style:ApplyColor(nil, nil, frame.titleBar.bg);

    hooksecurefunc(frame.titleBar.text, "SetText", TitleBar_SetWidth);
    frame.titleBar.text:SetText(text);
  end
end

function gui:AddResizer(frame)
  local style = tk.Constants.AddOnStyle;
  local normalTexture = style:GetTexture("DraggerTexture");
  local highlightTexture = style:GetTexture("DraggerTexture");

  frame.dragger = tk:CreateFrame("Button", frame);
  frame.dragger:SetSize(28, 28);
  frame.dragger:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -1, 2);
  frame.dragger:SetNormalTexture(normalTexture, "BLEND");
  frame.dragger:SetHighlightTexture(highlightTexture, "ADD");

  tk:MakeResizable(frame, frame.dragger);
  style:ApplyColor(nil, nil, frame.dragger:GetNormalTexture());
  style:ApplyColor(nil, nil, frame.dragger:GetHighlightTexture());
end

function gui:AddCloseButton(frame, onHideCallback, clickSoundFilePath)
  frame.closeBtn = tk:CreateFrame("Button", frame);
  frame.closeBtn:SetSize(28, 24);
  frame.closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -1);

  local style = tk.Constants.AddOnStyle;
  local texture = style:GetTexture("CloseButtonBackground");
  frame.closeBtn:SetNormalTexture(texture, "BLEND");
  frame.closeBtn:SetHighlightTexture(texture, "ADD");
  style:ApplyColor(nil, nil, frame.closeBtn);

  local group = frame:CreateAnimationGroup();
  group.a1 = group:CreateAnimation("Translation");
  group.a1:SetSmoothing("OUT");
  group.a1:SetDuration(0.3);
  group.a1:SetOffset(0, 10);
  group.a2 = group:CreateAnimation("Alpha");
  group.a2:SetSmoothing("OUT");
  group.a2:SetDuration(0.3);
  group.a2:SetFromAlpha(1);
  group.a2:SetToAlpha(-1);

  group:SetScript("OnFinished", function()
    if (obj:IsFunction(onHideCallback)) then
      onHideCallback(frame);
    end

    frame:Hide();
  end);

  frame.closeBtn:SetScript("OnClick", function()
    group:Play();

    if (clickSoundFilePath) then
      PlaySound(clickSoundFilePath);
    end
  end);
end

function gui:AddArrow(frame, direction, center)
  direction = direction or "UP";
  direction = direction:upper();

  frame.arrow = tk:CreateFrame("Frame", frame);
  frame.arrow:SetSize(30, 24);

  local style = tk.Constants.AddOnStyle;
  local texture = style:GetTexture("ArrowButtonTexture");
  frame.arrow.bg = frame.arrow:CreateTexture(nil, "ARTWORK");
  frame.arrow.bg:SetAllPoints(true);
  frame.arrow.bg:SetTexture(texture);

  style:ApplyColor(nil, nil, frame.arrow.bg);

  if (center) then
    frame.arrow:SetPoint("CENTER");
  end

  if (direction ~= "UP") then
    if (direction == "DOWN") then
      frame.arrow.bg:SetTexCoord(0, 1, 1, 0);

      if (not center) then
        frame.arrow:SetPoint("TOP", frame, "BOTTOM", 0, -2);
      end
    end
  end
end

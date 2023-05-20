local MayronUI = _G.MayronUI;
local tk = MayronUI:GetCoreComponents();

local Components = MayronUI:GetComponent("ConfigMenuComponents");

function Components.divider(parent, widgetTable)
  local divider = tk:CreateFrame("Frame", parent);
  divider:SetHeight(widgetTable.height or 1);
  divider.rightPadding = 10;
  tk:SetFullWidth(divider);
  return divider;
end

function Components.condition(_, widgetTable)
  local result = widgetTable.func();
  return result and widgetTable.onTrue or widgetTable.onFalse;
end
--[[

	This file is part of 'Masque', an add-on for World of Warcraft. For bug reports,
	suggestions and license information, please visit https://github.com/SFX-WoW/Masque.

	* File...: Skins\Dream.lua
	* Author.: StormFX, JJSheets

	"Dream" Skin

]]

local _, Core = ...

----------------------------------------
-- Internal
---

-- @ Locales\enUS
local L = Core.Locale

-- @ Skins\Skins
local Hidden = Core.__Hidden

----------------------------------------
-- Dream
---

Core.AddSkin("Dream", {
	-- API_VERSION = Template.API_VERSION,
	Shape = "Square",
	Template = "Blizzard Classic",

	-- Info
	Authors = Core.Authors,
	Description = L["A square skin with trimmed icons and a semi-transparent background."],
	Discord = Core.Discord,
	-- Version = Template.Version,
	Websites = Core.Websites,

	-- Skin
	-- Mask = Template.Mask,
	Backdrop = {
		-- Texture = [[Interface\Buttons\UI-Quickslot]],
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0, 0, 0.5},
		BlendMode = "BLEND",
		DrawLayer = "BACKGROUND",
		DrawLevel = -1,
		Width = 36,
		Height = 36,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		UseColor = true,
		-- SetAllPoints = nil,
	},
	Icon = {
		Texture = [[Interface\Icons\INV_Misc_Bag_08]],
		TexCoords = {0.08, 0.92, 0.08, 0.92},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SlotIcon = "Icon",
	-- Shadow = Template.Shadow,
	Normal = Hidden,
	-- Disabled = Template.Disabled,
	Pushed = {
		Texture = [[Interface\Buttons\UI-Quickslot-Depress]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 1,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		-- UseColor = nil,
	},
	Flash = {
		Texture = [[Interface\Buttons\UI-QuickslotRed]],
		TexCoords = {0.2, 0.8, 0.2, 0.8},
		Color = {1, 1, 1, 0.75},
		BlendMode = "BLEND",
		DrawLayer = "ARTWORK",
		DrawLevel = 1,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		-- UseColor = nil,
	},
	HotKey = {
		JustifyH = "RIGHT",
		JustifyV = "MIDDLE",
		DrawLayer = "OVERLAY",
		Width = 32,
		Height = 0,
		Anchor = "Icon",
		Point = "TOPRIGHT",
		RelPoint = "TOPRIGHT",
		OffsetX = 0,
		OffsetY = 0,
	},
	Count = {
		JustifyH = "RIGHT",
		JustifyV = "MIDDLE",
		DrawLayer = "OVERLAY",
		Width = 0,
		Height = 0,
		Anchor = "Icon",
		Point = "BOTTOMRIGHT",
		RelPoint = "BOTTOMRIGHT",
		OffsetX = 0,
		OffsetY = 0,
	},
	-- Duration = Template.Duration,
	Checked = {
		Texture = [[Interface\Buttons\CheckButtonHilight]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "ADD",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SlotHighlight = "Checked",
	Name = {
		JustifyH = "CENTER",
		JustifyV = "MIDDLE",
		DrawLayer = "OVERLAY",
		Width = 36,
		Height = 0,
		Anchor = "Icon",
		Point = "BOTTOM",
		RelPoint = "BOTTOM",
		OffsetX = 0,
		OffsetY = -1,
	},
	Border = {
		Texture = [[Interface\Buttons\UI-ActionButton-Border]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "ADD",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 54,
		Height = 54,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		Debuff = {
			Texture = [[Interface\Buttons\UI-Debuff-Overlays]],
			TexCoords = {0.296875, 0.5703125, 0, 0.515625},
			-- Color = {1, 1, 1, 1},
			BlendMode = "BLEND",
			DrawLayer = "OVERLAY",
			DrawLevel = 0,
			Width = 36,
			Height = 34,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
		},
		Enchant = {
			Texture = [[Interface\Buttons\UI-TempEnchant-Border]],
			-- TexCoords = {0, 1, 0, 1},
			-- Color = {1, 1, 1, 1},
			BlendMode = "BLEND",
			DrawLayer = "OVERLAY",
			DrawLevel = 0,
			Width = 36,
			Height = 36,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
		},
		Item = {
			Texture = [[Interface\Common\WhiteIconFrame]],
			-- TexCoords = {0, 1, 0, 1},
			-- Color = {1, 1, 1, 1},
			BlendMode = "BLEND",
			DrawLayer = "OVERLAY",
			DrawLevel = 0,
			Width = 34,
			Height = 34,
			Point = "CENTER",
			RelPoint = "CENTER",
			OffsetX = 0,
			OffsetY = 0,
			-- SetAllPoints = nil,
		},
	},
	DebuffBorder = {
		Texture = [[Interface\Buttons\UI-Debuff-Overlays]],
		TexCoords = {0.296875, 0.5703125, 0, 0.515625},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 36,
		Height = 34,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	EnchantBorder = {
		Texture = [[Interface\Buttons\UI-TempEnchant-Border]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 36,
		Height = 36,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	IconBorder = {
		Texture = [[Interface\Common\WhiteIconFrame]],
		RelicTexture = [[Interface\Artifacts\RelicIconFrame]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 0,
		Width = 34,
		Height = 34,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	-- Gloss = Template.Gloss,
	NewAction = {
		Atlas = "bags-newitem",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "ADD",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 38,
		Height = 38,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SpellHighlight = "NewAction",
	AutoCastable = {
		Texture = [[Interface\Buttons\UI-AutoCastableOverlay]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 56,
		Height = 56,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0.5,
		OffsetY = -0.5,
		-- SetAllPoints = nil,
	},
	IconOverlay = {
		Atlas = "AzeriteIconFrame",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 34,
		Height = 34,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	UpgradeIcon = {
		Atlas = "bags-greenarrow",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 3, --1
		Width = 16,
		Height = 17,
		Point = "TOPLEFT",
		RelPoint = "TOPLEFT",
		OffsetX = 1,
		OffsetY = -2,
		-- SetAllPoints = nil,
	},
	IconOverlay2 = {
		Atlas = "ConduitIconFrame-Corners",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 2,
		Width = 34,
		Height = 34,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	QuestBorder = {
		Border = [[Interface\ContainerFrame\UI-Icon-QuestBang]],
		Texture = [[Interface\ContainerFrame\UI-Icon-QuestBorder]],
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 2,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	NewItem = {
		Atlas = "bags-glow-white",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "ADD",
		DrawLayer = "OVERLAY",
		DrawLevel = 2,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	SearchOverlay = {
		-- Texture = nil,
		-- TexCoords = {0, 1, 0, 1},
		Color = {0, 0, 0, 0.8},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 4,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		UseColor = true,
		-- SetAllPoints = nil,
	},
	ContextOverlay = "SearchOverlay",
	JunkIcon = {
		Atlas = "bags-junkcoin",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 3,
		Width = 16,
		Height = 16,
		Point = "TOPLEFT",
		RelPoint = "TOPLEFT",
		OffsetX = 2,
		OffsetY = -1,
		-- SetAllPoints = nil,
	},
	Highlight = {
		Texture = [[Interface\Buttons\ButtonHilight-Square]],
		-- TexCoords = {0, 1, 0, 1},
		-- Color = {1, 1, 1, 1},
		BlendMode = "ADD",
		DrawLayer = "HIGHLIGHT",
		DrawLevel = 0,
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
		-- UseColor = nil,
	},
	-- [ AutoCastOverlay (Retail) ]
	-- AutoCast_Frame = Template.AutoCast_Frame,
	-- AutoCast_Shine = Template.AutoCast_Shine,
	AutoCast_Mask = {
		-- Atlas = "UI-HUD-ActionBar-PetAutoCast-Mask",
		-- UseAtlasSize = false,
		Texture = [[Interface\AddOns\Masque\Textures\Square\AutoCast-Mask]],
		-- TexCoords = {0, 1, 0, 1},
		Width = 28,
		Height = 28,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	AutoCast_Corners = {
		Atlas = "UI-HUD-ActionBar-PetAutoCast-Corners",
		UseAtlasSize = false,
		-- Color = {1, 1, 1, 1},
		BlendMode = "BLEND",
		DrawLayer = "OVERLAY",
		DrawLevel = 1,
		Width = 32,
		Height = 32,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = true,
	},
	-- [ AutoCastShine (Classic) ]
	AutoCastShine = {
		Width = 28,
		Height = 28,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0.5,
		OffsetY = -0.5,
		-- SetAllPoints = nil,
	},
	-- [ Cooldowns ]
	Cooldown = {
		Texture = [[Interface\AddOns\Masque\Textures\Square\Mask]],
		EdgeTexture = [[Interface\AddOns\Masque\Textures\Square\Edge]],
		PulseTexture = [[Interface\Cooldown\star4]],
		Color = {0, 0, 0, 0.8},
		Width = 30,
		Height = 30,
		Point = "CENTER",
		RelPoint = "CENTER",
		OffsetX = 0,
		OffsetY = 0,
		-- SetAllPoints = nil,
	},
	ChargeCooldown = "Cooldown",
	-- [ SpellAlert ]
	SpellAlert = {
		Width = 34,
		Height = 34,
		Classic = {
			Height = 30,
			Width = 30,
		},
		Modern = {
			Height = 29,
			Width = 29,
		},
		Thin = {
			Height = 26,
			Width = 26,
		},
	},
}, true)

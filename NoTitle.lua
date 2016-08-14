--[[--------------------------------------------------------------------
	NoTitle
	Prompts to remove the randomly set title from new characters.
	Copyright (c) 2014-2016 Phanx. All rights reserved.
	https://github.com/Phanx/NoTitle
	https://mods.curse.com/addons/wow/no-title
	https://www.wowinterface.com/downloads/info22746-NoTitle.html
----------------------------------------------------------------------]]

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent(event)
	self:SetScript("OnEvent", nil)

	local title = GetCurrentTitle()
	if not title or title < 1 or title == NoTitleSVPC then
		-- no title, or same as last time
		return
	end

	if NoTitleSVPC == nil and UnitLevel("player") > 10 then
		-- first time, but level > 10 so probably intentional
		NoTitleSVPC = title
		return
	end

	local name = strtrim((GetTitleName(title)))
	StaticPopupDialogs["UNSET_TITLE"] = {
		text = GetLocale() == "deDE" and format("Ihr aktueller Titel ist %q.\nMöchtet Ihr er entfernen?", name)
			 or GetLocale() == "esES" and format("Tu título actual es %q.\n¿Quieres quitarlo?", name)
			 or GetLocale() == "esMX" and format("Tu título actual es %q.\n¿Quieres quitarlo?", name)
			 or GetLocale() == "frFR" and format("Votre titre actuel est %q.\nVoulez-vous supprimer?", name)
			 or GetLocale() == "itIT" and format("Il titolo attuale è %q.\nVuoi rimuoverlo?", name)
			 or GetLocale() == "ptBR" and format("Seu título atual é %q.\nVocê quer removê-lo?", name)
			 or GetLocale() == "ruRU" and format("Ваше текущее звание %q.\nХотите, чтобы удалить его?", name) -- needs check
			 or format("Your current title is %q.\nWould you like to remove it?", name),
		button1 = YES,
		button2 = NO,
		OnAccept = function(self)
			SetCurrentTitle(-1)
		end,
		OnCancel = function(self)
			NoTitleSVPC = GetCurrentTitle()
		end,
		hideOnEscape = 1,
		timeout = 0,
		exclusive = 0,
		whileDead = 1,
		preferredIndex = 3,
	}
	StaticPopup_Show("UNSET_TITLE")
end)

local buttons = {}
local click = function(self, button)
	if button == "LeftButton" then
		NoTitleSVPC = self.titleId > 0 and self.titleId or nil
	end
end
PaperDollTitlesPane:HookScript("OnShow", function(self)
	local button = _G["PaperDollTitlesPaneButton" .. (#buttons + 1)]
	while button do
		--print("Hooked button", b:GetName())
		button:HookScript("OnClick", click)
		tinsert(buttons, button)
		button = _G["PaperDollTitlesPaneButton" .. (#buttons + 1)]
	end
end)

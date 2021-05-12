local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

function S:WhatsTraining()
	if not IsAddOnLoaded("WhatsTraining") then return end
	if not C.db["Skins"]["BlizzardSkins"] then return end

	local done
	SpellBookFrame:HookScript("OnShow", function()
		if done then return end

		B.StripTextures(WhatsTrainingFrame)
		local bg = B.CreateBDFrame(WhatsTrainingFrameScrollBar, 1)
		bg:SetPoint("TOPLEFT", 20, 0)
		bg:SetPoint("BOTTOMRIGHT", 4, 0)
		B.ReskinScroll(WhatsTrainingFrameScrollBarScrollBar)
		B:GetModule("Tooltip").ReskinTooltip(WhatsTrainingTooltip)

		for i = 1, 22 do
			local bar = _G["WhatsTrainingFrameRow"..i.."Spell"]
			if bar and bar.icon then
				B.ReskinIcon(bar.icon)
			end
		end

		done = true
	end)
end

function S:ResetRecount()
	Recount:RestoreMainWindowPosition(797, -405, 320, 220)

	Recount.db.profile.Locked = true
	Recount:LockWindows(true)

	Recount.db.profile.MainWindowHeight = 320
	Recount.db.profile.MainWindowWidth = 220
	Recount:ResizeMainWindow()

	Recount.db.profile.MainWindow.RowHeight = 18
	Recount:BarsChanged()

	Recount.db.profile.BarTexture = "normTex"
	Recount.db.profile.Font = nil
	Recount:UpdateBarTextures()

	C.db["Skins"]["ResetRecount"] = false
end

function S:ResetRocountFont()
	for _, row in pairs(Recount.MainWindow.Rows) do
		local font, fontSize = row.LeftText:GetFont()
		row.LeftText:SetFont(font, fontSize, DB.Font[3])
		row.RightText:SetFont(font, fontSize, DB.Font[3])
	end
end

function S:RecountSkin()
	if not C.db["Skins"]["Recount"] then return end
	if not IsAddOnLoaded("Recount") then return end

	local frame = Recount_MainWindow
	B.StripTextures(frame)
	local bg = B.SetBD(frame)
	bg:SetPoint("TOPLEFT", 0, -10)
	frame.bg = bg

	local open, close = S:CreateToggle(frame)
	open:HookScript("OnClick", function()
		Recount.MainWindow:Show()
		Recount:RefreshMainWindow()
	end)
	close:HookScript("OnClick", function()
		Recount.MainWindow:Hide()
	end)

	if C.db["Skins"]["ResetRecount"] then S:ResetRecount() end
	hooksecurefunc(Recount, "ResetPositions", S.ResetRecount)

	S:ResetRocountFont()
	hooksecurefunc(Recount, "BarsChanged", S.ResetRocountFont)

	B.ReskinArrow(frame.LeftButton, "left")
	B.ReskinArrow(frame.RightButton, "right")
	B.ReskinClose(frame.CloseButton, frame.bg, -2, -2)

	-- Force to show window on init
	Recount.MainWindow:Show()
end

function S:BindPad()
	if not IsAddOnLoaded("BindPad") then return end
	if not C.db["Skins"]["BlizzardSkins"] then return end

	BindPadFrame.bg = B.ReskinPortraitFrame(BindPadFrame, 10, -10, -30, 70)
	for i = 1, 4 do
		B.ReskinTab(_G["BindPadFrameTab"..i])
	end
	B.ReskinScroll(BindPadScrollFrameScrollBar)
	B.ReskinCheck(BindPadFrameCharacterButton)
	B.ReskinCheck(BindPadFrameSaveAllKeysButton)
	B.ReskinCheck(BindPadFrameShowHotkeyButton)
	B.Reskin(BindPadFrameExitButton)
	B.ReskinArrow(BindPadShowLessSlotButton, "left")
	B.ReskinArrow(BindPadShowMoreSlotButton, "right")

	B.StripTextures(BindPadDialogFrame)
	B.SetBD(BindPadDialogFrame)
	B.Reskin(BindPadDialogFrame.cancelbutton)
	B.Reskin(BindPadDialogFrame.okaybutton)

	hooksecurefunc("BindPadSlot_UpdateState", function(slot)
		if slot.styled then return end

		slot:DisableDrawLayer("ARTWORK")
		slot:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
		slot.icon:SetTexCoord(unpack(DB.TexCoord))
		B.CreateBDFrame(slot, .25)
		slot.border:SetTexture()

		B.StripTextures(slot.addbutton)
		local nt = slot.addbutton:GetNormalTexture()
		nt:SetTexture("Interface\\Buttons\\UI-PlusMinus-Buttons")
		nt:SetTexCoord(0, .4375, 0, .4375)

		slot.styled = true
	end)

	B.StripTextures(BindPadMacroPopupFrame)
	BindPadMacroPopupFrame:SetPoint("TOPLEFT", BindPadFrame.bg, "TOPRIGHT", 3, -40)
	B.SetBD(BindPadMacroPopupFrame)
	B.StripTextures(BindPadMacroPopupEditBox)
	B.CreateBDFrame(BindPadMacroPopupEditBox, .25)
	B.ReskinScroll(BindPadMacroPopupScrollFrameScrollBar)
	B.Reskin(BindPadMacroPopupOkayButton)
	B.Reskin(BindPadMacroPopupCancelButton)

	hooksecurefunc("BindPadMacroPopupFrame_Update", function()
		for i = 1, 20 do
			local bu = _G["BindPadMacroPopupButton"..i]
			local ic = _G["BindPadMacroPopupButton"..i.."Icon"]

			if not bu.styled then
				bu:SetCheckedTexture(DB.textures.pushed)
				select(2, bu:GetRegions()):Hide()
				local hl = bu:GetHighlightTexture()
				hl:SetColorTexture(1, 1, 1, .25)
				hl:SetAllPoints(ic)

				ic:SetPoint("TOPLEFT", C.mult, -C.mult)
				ic:SetPoint("BOTTOMRIGHT", -C.mult, C.mult)
				ic:SetTexCoord(unpack(DB.TexCoord))
				B.CreateBDFrame(ic, .25)

				bu.styled = true
			end
		end
	end)

	B.StripTextures(BindPadBindFrame)
	B.SetBD(BindPadBindFrame)
	B.ReskinClose(BindPadBindFrameCloseButton)
	B.ReskinCheck(BindPadBindFrameForAllCharacterButton)
	B.Reskin(BindPadBindFrameUnbindButton)
	B.Reskin(BindPadBindFrameExitButton)

	B.ReskinPortraitFrame(BindPadMacroFrame, 10, -10, -30, 70)
	B.ReskinScroll(BindPadMacroFrameScrollFrameScrollBar)
	B.Reskin(BindPadMacroFrameEditButton)
	B.Reskin(BindPadMacroDeleteButton)
	B.Reskin(BindPadMacroFrameTestButton)
	B.Reskin(BindPadMacroFrameExitButton)
	B.StripTextures(BindPadMacroFrameTextBackground)
	B.CreateBDFrame(BindPadMacroFrameTextBackground, .25)
	B.StripTextures(BindPadMacroFrameSlotButton)
	B.ReskinIcon(BindPadMacroFrameSlotButtonIcon)
end

function S:LoadOtherSkins()
	self:WhatsTraining()
	self:RecountSkin()
	self:BindPad()
end
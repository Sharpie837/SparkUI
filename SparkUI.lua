local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

local DEVELOPERS = {
	["Bubblz66"] = true,
}

local function isDeveloper(plr)
	return DEVELOPERS[plr.Name] == true
end

local FONT_REG = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FONT_MED = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FONT_SEMI = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local FONT_BOLD = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local LUCIDE = {
	combat = "rbxassetid://94212016861936",
	movement = "rbxassetid://115123411028382",
	visuals = "rbxassetid://79950339943067",
	world = "rbxassetid://101768155599700",
	settings = "rbxassetid://116544501716299",
	chevronDown = "rbxassetid://134243273101015",
	chevronRight = "rbxassetid://92473583511724",
	check = "rbxassetid://93898873302694",
}

local TWEEN_FAST = TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TWEEN_SPRING = TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local TAB_COLORS = {
	activeBg = Color3.fromRGB(22, 22, 26),
	hoverBg = Color3.fromRGB(16, 16, 19),
	activeBorder = Color3.fromRGB(36, 36, 43),
	hoverBorder = Color3.fromRGB(25, 25, 30),
	activeText = Color3.fromRGB(244, 244, 248),
	hoverText = Color3.fromRGB(200, 200, 208),
	idleText = Color3.fromRGB(118, 118, 128),
}

local KEY_NAMES = {
	RightShift = "RShift",
	LeftShift = "LShift",
	RightControl = "RCtrl",
	LeftControl = "LCtrl",
	RightAlt = "RAlt",
	LeftAlt = "LAlt",
	CapsLock = "Caps",
	Backspace = "Back",
	Insert = "Ins",
	Delete = "Del",
	PageUp = "PgUp",
	PageDown = "PgDn",
}

local function resolveKeyCode(val)
	if typeof(val) == "EnumItem" and val.EnumType == Enum.KeyCode then
		if val == Enum.KeyCode.Unknown then
			return nil
		end
		return val
	elseif type(val) == "string" and val ~= "" and val ~= "None" then
		local ok, kc = pcall(function()
			return Enum.KeyCode[val]
		end)
		if ok and kc and kc ~= Enum.KeyCode.Unknown then
			return kc
		end
	end
	return nil
end

local function formatKeyName(key)
	if not key or key == Enum.KeyCode.Unknown then
		return "None"
	end
	return KEY_NAMES[key.Name] or key.Name
end

local SparkUI = {}
SparkUI.Icons = LUCIDE

local function getGuiParent()
	local ok, target = pcall(function()
		return (gethui and gethui()) or CoreGui
	end)
	if ok and target then
		local test = pcall(function()
			local _ = target.Name
		end)
		if test then
			return target
		end
	end
	return player:WaitForChild("PlayerGui")
end

function SparkUI:CreateWindow(config)
	config = config or {}
	local windowTitle = config.Title or "Spark"
	local toggleKey = resolveKeyCode(config.Keybind) or Enum.KeyCode.RightShift

	local parentContainer = getGuiParent()
	local old = parentContainer:FindFirstChild("Spark Panel")
	if old then
		old:Destroy()
	end

	local connections = {}
	local function trackConn(conn)
		table.insert(connections, conn)
		return conn
	end

	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "Spark Panel"
	screenGui.ResetOnSpawn = false
	screenGui.IgnoreGuiInset = true
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = parentContainer

	screenGui.Destroying:Connect(function()
		for _, conn in connections do
			if conn.Connected then
				conn:Disconnect()
			end
		end
		table.clear(connections)
	end)

	local window = Instance.new("Frame")
	window.Name = "Window"
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Position = UDim2.fromScale(0.5, 0.5)
	window.Size = UDim2.fromOffset(590, 390)
	window.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
	window.BorderSizePixel = 0
	window.Visible = true
	window.Parent = screenGui

	local winScale = Instance.new("UIScale")
	winScale.Name = "Scale"
	winScale.Scale = 1
	winScale.Parent = window

	local winCorner = Instance.new("UICorner")
	winCorner.CornerRadius = UDim.new(0, 8)
	winCorner.Parent = window

	local winStroke = Instance.new("UIStroke")
	winStroke.Name = "Stroke"
	winStroke.Color = Color3.fromRGB(36, 36, 42)
	winStroke.Thickness = 1
	winStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	winStroke.Parent = window

	local dropShadow = Instance.new("ImageLabel")
	dropShadow.Name = "Shadow"
	dropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	dropShadow.Position = UDim2.fromScale(0.5, 0.5)
	dropShadow.Size = UDim2.new(1, 48, 1, 48)
	dropShadow.BackgroundTransparency = 1
	dropShadow.Image = "rbxassetid://3523728077"
	dropShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	dropShadow.ImageTransparency = 0.52
	dropShadow.ZIndex = 0
	dropShadow.Parent = window

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 148, 1, 0)
	sidebar.BackgroundTransparency = 1
	sidebar.BorderSizePixel = 0
	sidebar.Parent = window

	local sideDivider = Instance.new("Frame")
	sideDivider.Name = "Divider"
	sideDivider.Size = UDim2.new(0, 1, 1, 0)
	sideDivider.Position = UDim2.new(1, 0, 0, 0)
	sideDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
	sideDivider.BorderSizePixel = 0
	sideDivider.Parent = sidebar

	local brand = Instance.new("Frame")
	brand.Name = "Brand"
	brand.Size = UDim2.new(1, 0, 0, 38)
	brand.BackgroundTransparency = 1
	brand.Parent = sidebar

	local brandText = Instance.new("TextLabel")
	brandText.Name = "Title"
	brandText.Position = UDim2.fromOffset(16, 0)
	brandText.Size = UDim2.new(1, -24, 1, 0)
	brandText.BackgroundTransparency = 1
	brandText.Text = windowTitle
	brandText.TextColor3 = Color3.fromRGB(242, 242, 247)
	brandText.FontFace = FONT_SEMI
	brandText.TextSize = 14
	brandText.TextXAlignment = Enum.TextXAlignment.Left
	brandText.Parent = brand

	local tabList = Instance.new("Frame")
	tabList.Name = "TabList"
	tabList.Position = UDim2.fromOffset(0, 44)
	tabList.Size = UDim2.new(1, 0, 1, -106)
	tabList.BackgroundTransparency = 1
	tabList.Parent = sidebar

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingLeft = UDim.new(0, 8)
	tabPad.PaddingRight = UDim.new(0, 8)
	tabPad.PaddingTop = UDim.new(0, 2)
	tabPad.Parent = tabList

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0, 3)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent = tabList

	local profileCard = Instance.new("Frame")
	profileCard.Name = "ProfileCard"
	profileCard.AnchorPoint = Vector2.new(0, 1)
	profileCard.Position = UDim2.new(0, 0, 1, 0)
	profileCard.Size = UDim2.new(1, 0, 0, 54)
	profileCard.BackgroundTransparency = 1
	profileCard.Parent = sidebar

	local profileTopLine = Instance.new("Frame")
	profileTopLine.Name = "TopLine"
	profileTopLine.Size = UDim2.new(1, 0, 0, 1)
	profileTopLine.Position = UDim2.fromOffset(0, 0)
	profileTopLine.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
	profileTopLine.BorderSizePixel = 0
	profileTopLine.Parent = profileCard

	local avatarWrap = Instance.new("Frame")
	avatarWrap.Name = "AvatarWrap"
	avatarWrap.AnchorPoint = Vector2.new(0, 0.5)
	avatarWrap.Position = UDim2.new(0, 12, 0.5, 1)
	avatarWrap.Size = UDim2.fromOffset(32, 32)
	avatarWrap.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	avatarWrap.BorderSizePixel = 0
	avatarWrap.Parent = profileCard

	local avCorner = Instance.new("UICorner")
	avCorner.CornerRadius = UDim.new(0, 6)
	avCorner.Parent = avatarWrap

	local avStroke = Instance.new("UIStroke")
	avStroke.Color = Color3.fromRGB(38, 38, 45)
	avStroke.Thickness = 1
	avStroke.Parent = avatarWrap

	local avatarImg = Instance.new("ImageLabel")
	avatarImg.Name = "Avatar"
	avatarImg.Size = UDim2.fromScale(1, 1)
	avatarImg.BackgroundTransparency = 1
	avatarImg.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId)
	avatarImg.ScaleType = Enum.ScaleType.Crop
	avatarImg.Parent = avatarWrap

	local avImgCorner = Instance.new("UICorner")
	avImgCorner.CornerRadius = UDim.new(0, 6)
	avImgCorner.Parent = avatarImg

	local userLbl = Instance.new("TextLabel")
	userLbl.Name = "Username"
	userLbl.Position = UDim2.fromOffset(52, 10)
	userLbl.Size = UDim2.new(1, -58, 0, 15)
	userLbl.BackgroundTransparency = 1
	userLbl.Text = player.DisplayName or player.Name
	userLbl.TextColor3 = Color3.fromRGB(238, 238, 244)
	userLbl.FontFace = FONT_SEMI
	userLbl.TextSize = 12
	userLbl.TextXAlignment = Enum.TextXAlignment.Left
	userLbl.TextTruncate = Enum.TextTruncate.AtEnd
	userLbl.Parent = profileCard

	local roleBadge = Instance.new("Frame")
	roleBadge.Name = "RoleBadge"
	roleBadge.Position = UDim2.fromOffset(52, 27)
	roleBadge.AutomaticSize = Enum.AutomaticSize.X
	roleBadge.Size = UDim2.fromOffset(0, 15)
	roleBadge.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	roleBadge.BorderSizePixel = 0
	roleBadge.Parent = profileCard

	local badgePad = Instance.new("UIPadding")
	badgePad.PaddingLeft = UDim.new(0, 6)
	badgePad.PaddingRight = UDim.new(0, 6)
	badgePad.Parent = roleBadge

	local proCorner = Instance.new("UICorner")
	proCorner.CornerRadius = UDim.new(0, 4)
	proCorner.Parent = roleBadge

	local bgGrad = Instance.new("UIGradient")
	bgGrad.Name = "BgGradient"
	bgGrad.Rotation = 25
	bgGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 45, 18)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(38, 29, 11)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(68, 52, 20)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 24, 9)),
	})
	bgGrad.Parent = roleBadge

	local proStroke = Instance.new("UIStroke")
	proStroke.Name = "Border"
	proStroke.Color = Color3.fromRGB(255, 255, 255)
	proStroke.Thickness = 1
	proStroke.Transparency = 0.15
	proStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	proStroke.Parent = roleBadge

	local strokeGrad = Instance.new("UIGradient")
	strokeGrad.Name = "StrokeGradient"
	strokeGrad.Rotation = 35
	strokeGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(245, 208, 105)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(165, 125, 42)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 232, 155)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 98, 28)),
	})
	strokeGrad.Parent = proStroke

	local roleText = Instance.new("TextLabel")
	roleText.Name = "RoleText"
	roleText.AutomaticSize = Enum.AutomaticSize.X
	roleText.Size = UDim2.new(0, 0, 1, 0)
	roleText.BackgroundTransparency = 1
	roleText.Text = if isDeveloper(player) then "DEVELOPER" else "PRO"
	roleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	roleText.FontFace = FONT_BOLD
	roleText.TextSize = 9
	roleText.Parent = roleBadge

	local textGrad = Instance.new("UIGradient")
	textGrad.Name = "TextGradient"
	textGrad.Rotation = 20
	textGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 192, 90)),
		ColorSequenceKeypoint.new(0.42, Color3.fromRGB(212, 162, 58)),
		ColorSequenceKeypoint.new(0.52, Color3.fromRGB(255, 238, 175)),
		ColorSequenceKeypoint.new(0.65, Color3.fromRGB(218, 168, 62)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(188, 138, 42)),
	})
	textGrad.Parent = roleText

	local contentArea = Instance.new("Frame")
	contentArea.Name = "ContentArea"
	contentArea.Position = UDim2.fromOffset(149, 0)
	contentArea.Size = UDim2.new(1, -149, 1, 0)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = window

	local topHeader = Instance.new("Frame")
	topHeader.Name = "TopHeader"
	topHeader.Size = UDim2.new(1, 0, 0, 38)
	topHeader.BackgroundTransparency = 1
	topHeader.Parent = contentArea

	local pageTitle = Instance.new("TextLabel")
	pageTitle.Name = "PageTitle"
	pageTitle.Position = UDim2.fromOffset(20, 0)
	pageTitle.Size = UDim2.new(0.6, 0, 1, 0)
	pageTitle.BackgroundTransparency = 1
	pageTitle.Text = ""
	pageTitle.TextColor3 = Color3.fromRGB(235, 235, 240)
	pageTitle.FontFace = FONT_MED
	pageTitle.TextSize = 13
	pageTitle.TextXAlignment = Enum.TextXAlignment.Left
	pageTitle.Parent = topHeader

	local topDivider = Instance.new("Frame")
	topDivider.Name = "Divider"
	topDivider.Position = UDim2.fromOffset(0, 38)
	topDivider.Size = UDim2.new(1, 0, 0, 1)
	topDivider.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
	topDivider.BorderSizePixel = 0
	topDivider.Parent = contentArea

	local pagesHolder = Instance.new("Frame")
	pagesHolder.Name = "Pages"
	pagesHolder.Position = UDim2.fromOffset(0, 39)
	pagesHolder.Size = UDim2.new(1, 0, 1, -39)
	pagesHolder.BackgroundTransparency = 1
	pagesHolder.ClipsDescendants = true
	pagesHolder.Parent = contentArea

	local dragging = false
	local dragStart = Vector2.zero
	local startPos = window.Position

	local function beginDrag(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = UserInputService:GetMouseLocation()
			startPos = window.Position
		end
	end

	brand.InputBegan:Connect(beginDrag)
	topHeader.InputBegan:Connect(beginDrag)

	trackConn(UserInputService.InputEnded:Connect(function(io)
		if io.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end))

	trackConn(UserInputService.InputChanged:Connect(function(io)
		if dragging and io.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = UserInputService:GetMouseLocation() - dragStart
			TweenService:Create(window, TWEEN_FAST, {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y),
			}):Play()
		end
	end))

	local isBindingAnyKey = false

	local isMenuOpen = true
	trackConn(UserInputService.InputBegan:Connect(function(io)
		if UserInputService:GetFocusedTextBox() then
			return
		end
		if not isBindingAnyKey and io.KeyCode == toggleKey then
			isMenuOpen = not isMenuOpen
			dragging = false
			if isMenuOpen then
				winScale.Scale = 0.95
				window.Visible = true
				TweenService:Create(winScale, TWEEN_SMOOTH, { Scale = 1 }):Play()
			else
				window.Visible = false
			end
		end
	end))

	local tabs = {}
	local currentTab = nil

	local function selectTab(tab)
		if currentTab == tab then
			return
		end
		currentTab = tab
		pageTitle.Text = tab.name

		for _, t in tabs do
			local active = (t == tab)
			TweenService:Create(t.btn, TWEEN_SMOOTH, {
				BackgroundTransparency = if active then 0 else 1,
				BackgroundColor3 = if active then TAB_COLORS.activeBg else TAB_COLORS.hoverBg,
			}):Play()
			TweenService:Create(t.stroke, TWEEN_SMOOTH, {
				Transparency = if active then 0 else 1,
				Color = if active then TAB_COLORS.activeBorder else TAB_COLORS.hoverBorder,
			}):Play()
			TweenService:Create(t.icon, TWEEN_FAST, {
				ImageColor3 = if active then TAB_COLORS.activeText else TAB_COLORS.idleText,
			}):Play()
			TweenService:Create(t.label, TWEEN_FAST, {
				TextColor3 = if active then TAB_COLORS.activeText else TAB_COLORS.idleText,
			}):Play()

			if active then
				t.page.Visible = true
				t.page.Position = UDim2.fromOffset(0, 5)
				TweenService:Create(t.page, TWEEN_SMOOTH, {
					Position = UDim2.fromOffset(0, 0),
				}):Play()
			else
				t.page.Visible = false
			end
		end
	end

	local WindowObj = {}

	function WindowObj:Destroy()
		screenGui:Destroy()
	end

	local function formatIconId(iconVal)
		if type(iconVal) == "number" then
			return "rbxassetid://" .. tostring(iconVal)
		elseif type(iconVal) == "string" and iconVal ~= "" then
			if string.match(iconVal, "^%d+$") then
				return "rbxassetid://" .. iconVal
			elseif LUCIDE[iconVal] then
				return LUCIDE[iconVal]
			end
			return iconVal
		end
		return LUCIDE.combat
	end

	function WindowObj:CreateTab(tabConfig)
		tabConfig = tabConfig or {}
		local name = tabConfig.Name or "Tab"
		local iconId = formatIconId(tabConfig.Icon)

		local idx = #tabs + 1

		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.LayoutOrder = idx
		btn.Size = UDim2.new(1, 0, 0, 32)
		btn.BackgroundColor3 = TAB_COLORS.hoverBg
		btn.BackgroundTransparency = 1
		btn.AutoButtonColor = false
		btn.Text = ""
		btn.Parent = tabList

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn

		local stroke = Instance.new("UIStroke")
		stroke.Color = TAB_COLORS.hoverBorder
		stroke.Thickness = 1
		stroke.Transparency = 1
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = btn

		local ic = Instance.new("ImageLabel")
		ic.AnchorPoint = Vector2.new(0, 0.5)
		ic.Position = UDim2.new(0, 10, 0.5, 0)
		ic.Size = UDim2.fromOffset(16, 16)
		ic.BackgroundTransparency = 1
		ic.Image = iconId
		ic.ImageColor3 = TAB_COLORS.idleText
		ic.ScaleType = Enum.ScaleType.Fit
		ic.Parent = btn

		local lbl = Instance.new("TextLabel")
		lbl.Position = UDim2.fromOffset(34, 0)
		lbl.Size = UDim2.new(1, -38, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = name
		lbl.TextColor3 = TAB_COLORS.idleText
		lbl.FontFace = FONT_MED
		lbl.TextSize = 12
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = btn

		local page = Instance.new("ScrollingFrame")
		page.Name = name .. "Page"
		page.Size = UDim2.fromScale(1, 1)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.ScrollBarThickness = 2
		page.ScrollBarImageColor3 = Color3.fromRGB(48, 48, 56)
		page.AutomaticCanvasSize = Enum.AutomaticSize.Y
		page.CanvasSize = UDim2.new(0, 0, 0, 0)
		page.Visible = false
		page.Parent = pagesHolder

		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, 14)
		pad.PaddingBottom = UDim.new(0, 14)
		pad.PaddingLeft = UDim.new(0, 18)
		pad.PaddingRight = UDim.new(0, 18)
		pad.Parent = page

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 6)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = page

		local tabData = {
			name = name,
			btn = btn,
			stroke = stroke,
			icon = ic,
			label = lbl,
			page = page,
		}
		table.insert(tabs, tabData)

		btn.MouseEnter:Connect(function()
			if currentTab ~= tabData then
				TweenService:Create(btn, TWEEN_FAST, {
					BackgroundTransparency = 0,
					BackgroundColor3 = TAB_COLORS.hoverBg,
				}):Play()
				TweenService:Create(stroke, TWEEN_FAST, {
					Transparency = 0,
					Color = TAB_COLORS.hoverBorder,
				}):Play()
				TweenService:Create(lbl, TWEEN_FAST, { TextColor3 = TAB_COLORS.hoverText }):Play()
				TweenService:Create(ic, TWEEN_FAST, { ImageColor3 = TAB_COLORS.hoverText }):Play()
			end
		end)

		btn.MouseLeave:Connect(function()
			if currentTab ~= tabData then
				TweenService:Create(btn, TWEEN_FAST, { BackgroundTransparency = 1 }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Transparency = 1 }):Play()
				TweenService:Create(lbl, TWEEN_FAST, { TextColor3 = TAB_COLORS.idleText }):Play()
				TweenService:Create(ic, TWEEN_FAST, { ImageColor3 = TAB_COLORS.idleText }):Play()
			end
		end)

		btn.MouseButton1Click:Connect(function()
			selectTab(tabData)
		end)

		if #tabs == 1 then
			selectTab(tabData)
		end

		local itemOrder = 0
		local TabObj = {}

		function TabObj:SetIcon(newIcon)
			ic.Image = formatIconId(newIcon)
		end

		local function createKeybindPill(parent, rightOffset, initialKey, onKeyChanged, onKeyTriggered)
			local boundKey = resolveKeyCode(initialKey)
			local binding = false

			local pill = Instance.new("TextButton")
			pill.Name = "KeybindPill"
			pill.AnchorPoint = Vector2.new(1, 0.5)
			pill.Position = UDim2.new(1, rightOffset, 0.5, 0)
			pill.AutomaticSize = Enum.AutomaticSize.X
			pill.Size = UDim2.fromOffset(0, 20)
			pill.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
			pill.AutoButtonColor = false
			pill.Text = formatKeyName(boundKey)
			pill.TextColor3 = Color3.fromRGB(165, 165, 178)
			pill.FontFace = FONT_SEMI
			pill.TextSize = 11
			pill.Parent = parent

			local pPad = Instance.new("UIPadding")
			pPad.PaddingLeft = UDim.new(0, 7)
			pPad.PaddingRight = UDim.new(0, 7)
			pPad.Parent = pill

			local pCorner = Instance.new("UICorner")
			pCorner.CornerRadius = UDim.new(0, 4)
			pCorner.Parent = pill

			local pStroke = Instance.new("UIStroke")
			pStroke.Color = Color3.fromRGB(34, 34, 42)
			pStroke.Thickness = 1
			pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			pStroke.Parent = pill

			pill.MouseEnter:Connect(function()
				if not binding then
					TweenService:Create(pill, TWEEN_FAST, {
						BackgroundColor3 = Color3.fromRGB(24, 24, 30),
						TextColor3 = Color3.fromRGB(235, 235, 244),
					}):Play()
					TweenService:Create(pStroke, TWEEN_FAST, { Color = Color3.fromRGB(52, 52, 64) }):Play()
				end
			end)

			pill.MouseLeave:Connect(function()
				if not binding then
					TweenService:Create(pill, TWEEN_FAST, {
						BackgroundColor3 = Color3.fromRGB(20, 20, 25),
						TextColor3 = Color3.fromRGB(165, 165, 178),
					}):Play()
					TweenService:Create(pStroke, TWEEN_FAST, { Color = Color3.fromRGB(34, 34, 42) }):Play()
				end
			end)

			pill.MouseButton1Click:Connect(function()
				if binding then
					return
				end
				binding = true
				isBindingAnyKey = true
				pill.Text = "..."
				TweenService:Create(pill, TWEEN_FAST, {
					BackgroundColor3 = Color3.fromRGB(26, 26, 33),
					TextColor3 = Color3.fromRGB(245, 245, 252),
				}):Play()
				TweenService:Create(pStroke, TWEEN_FAST, { Color = Color3.fromRGB(215, 215, 228) }):Play()
			end)

			trackConn(UserInputService.InputBegan:Connect(function(io)
				if binding then
					if io.UserInputType == Enum.UserInputType.Keyboard then
						if io.KeyCode == Enum.KeyCode.Backspace or io.KeyCode == Enum.KeyCode.Escape then
							boundKey = nil
						elseif io.KeyCode ~= Enum.KeyCode.Unknown then
							boundKey = io.KeyCode
						else
							return
						end

						binding = false
						pill.Text = formatKeyName(boundKey)
						TweenService:Create(pill, TWEEN_FAST, {
							BackgroundColor3 = Color3.fromRGB(20, 20, 25),
							TextColor3 = Color3.fromRGB(165, 165, 178),
						}):Play()
						TweenService:Create(pStroke, TWEEN_FAST, { Color = Color3.fromRGB(34, 34, 42) }):Play()

						if onKeyChanged then
							onKeyChanged(boundKey)
						end

						task.defer(function()
							isBindingAnyKey = false
						end)
					end
					return
				end

				if not UserInputService:GetFocusedTextBox() and not isBindingAnyKey and boundKey and io.KeyCode == boundKey then
					if onKeyTriggered then
						onKeyTriggered(boundKey)
					end
				end
			end))

			return pill
		end

		function TabObj:AddToggle(opts)
			opts = opts or {}
			local title = opts.Title or "Toggle"
			local defaultOn = opts.Default or false
			local hasKeybind = opts.Keybind ~= nil and opts.Keybind ~= false
			local callback = opts.Callback
			local keybindCallback = opts.KeybindCallback

			itemOrder += 1

			local row = Instance.new("TextButton")
			row.Name = title
			row.LayoutOrder = itemOrder
			row.Size = UDim2.new(1, 0, 0, 38)
			row.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
			row.AutoButtonColor = false
			row.Text = ""
			row.Parent = page

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = row

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(26, 26, 31)
			stroke.Thickness = 1
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = row

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Position = UDim2.fromOffset(14, 0)
			titleLbl.Size = UDim2.new(1, if hasKeybind then -125 else -70, 1, 0)
			titleLbl.BackgroundTransparency = 1
			titleLbl.Text = title
			titleLbl.TextColor3 = if defaultOn then Color3.fromRGB(240, 240, 245) else Color3.fromRGB(185, 185, 195)
			titleLbl.FontFace = FONT_MED
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = row

			local switch = Instance.new("Frame")
			switch.AnchorPoint = Vector2.new(1, 0.5)
			switch.Position = UDim2.new(1, -14, 0.5, 0)
			switch.Size = UDim2.fromOffset(32, 17)
			switch.BackgroundColor3 = if defaultOn then Color3.fromRGB(240, 240, 246) else Color3.fromRGB(20, 20, 24)
			switch.BorderSizePixel = 0
			switch.Parent = row

			local swCorner = Instance.new("UICorner")
			swCorner.CornerRadius = UDim.new(1, 0)
			swCorner.Parent = switch

			local swStroke = Instance.new("UIStroke")
			swStroke.Color = if defaultOn then Color3.fromRGB(240, 240, 246) else Color3.fromRGB(38, 38, 45)
			swStroke.Thickness = 1
			swStroke.Parent = switch

			local knob = Instance.new("Frame")
			knob.AnchorPoint = Vector2.new(0, 0.5)
			knob.Position = if defaultOn then UDim2.new(1, -14, 0.5, 0) else UDim2.new(0, 3, 0.5, 0)
			knob.Size = UDim2.fromOffset(11, 11)
			knob.BackgroundColor3 = if defaultOn then Color3.fromRGB(11, 11, 13) else Color3.fromRGB(115, 115, 126)
			knob.BorderSizePixel = 0
			knob.Parent = switch

			local knobCorner = Instance.new("UICorner")
			knobCorner.CornerRadius = UDim.new(1, 0)
			knobCorner.Parent = knob

			local isOn = defaultOn

			local function setState(newState)
				isOn = newState

				TweenService:Create(titleLbl, TWEEN_FAST, {
					TextColor3 = if isOn then Color3.fromRGB(240, 240, 245) else Color3.fromRGB(185, 185, 195),
				}):Play()
				TweenService:Create(knob, TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = UDim2.fromOffset(14, 11),
				}):Play()
				TweenService:Create(switch, TWEEN_SMOOTH, {
					BackgroundColor3 = if isOn then Color3.fromRGB(240, 240, 246) else Color3.fromRGB(20, 20, 24),
				}):Play()
				TweenService:Create(swStroke, TWEEN_SMOOTH, {
					Color = if isOn then Color3.fromRGB(240, 240, 246) else Color3.fromRGB(38, 38, 45),
				}):Play()

				task.delay(0.05, function()
					TweenService:Create(knob, TWEEN_SPRING, {
						Size = UDim2.fromOffset(11, 11),
						Position = if isOn then UDim2.new(1, -14, 0.5, 0) else UDim2.new(0, 3, 0.5, 0),
						BackgroundColor3 = if isOn then Color3.fromRGB(11, 11, 13) else Color3.fromRGB(115, 115, 126),
					}):Play()
				end)

				if callback then
					callback(isOn)
				end
			end

			if hasKeybind then
				createKeybindPill(row, -54, opts.Keybind, keybindCallback, function()
					setState(not isOn)
				end)
			end

			row.MouseEnter:Connect(function()
				TweenService:Create(row, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(18, 18, 22) }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Color = Color3.fromRGB(36, 36, 43) }):Play()
			end)

			row.MouseLeave:Connect(function()
				TweenService:Create(row, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(15, 15, 18) }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Color = Color3.fromRGB(26, 26, 31) }):Play()
			end)

			row.MouseButton1Click:Connect(function()
				setState(not isOn)
			end)
		end

		function TabObj:AddKeybind(opts)
			opts = opts or {}
			local title = opts.Title or "Keybind"
			local defaultKey = opts.Default or opts.Keybind
			local callback = opts.Callback
			local changedCallback = opts.ChangedCallback

			itemOrder += 1

			local row = Instance.new("Frame")
			row.Name = title
			row.LayoutOrder = itemOrder
			row.Size = UDim2.new(1, 0, 0, 38)
			row.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
			row.BorderSizePixel = 0
			row.Parent = page

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = row

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(26, 26, 31)
			stroke.Thickness = 1
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = row

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Position = UDim2.fromOffset(14, 0)
			titleLbl.Size = UDim2.new(1, -90, 1, 0)
			titleLbl.BackgroundTransparency = 1
			titleLbl.Text = title
			titleLbl.TextColor3 = Color3.fromRGB(195, 195, 205)
			titleLbl.FontFace = FONT_MED
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = row

			createKeybindPill(row, -14, defaultKey, changedCallback, callback)
		end

		function TabObj:AddDropdown(opts)
			opts = opts or {}
			local title = opts.Title or "Dropdown"
			local options = opts.Options or { "Option 1" }
			local defaultVal = opts.Default or options[1]
			local callback = opts.Callback

			itemOrder += 1

			local selected = if type(defaultVal) == "number" then (options[defaultVal] or options[1]) else defaultVal
			local isExpanded = false

			local card = Instance.new("Frame")
			card.Name = title
			card.LayoutOrder = itemOrder
			card.Size = UDim2.new(1, 0, 0, 38)
			card.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
			card.BorderSizePixel = 0
			card.ClipsDescendants = true
			card.Parent = page

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = card

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(26, 26, 31)
			stroke.Thickness = 1
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = card

			local topBtn = Instance.new("TextButton")
			topBtn.Name = "Header"
			topBtn.Size = UDim2.new(1, 0, 0, 38)
			topBtn.BackgroundTransparency = 1
			topBtn.AutoButtonColor = false
			topBtn.Text = ""
			topBtn.Parent = card

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Position = UDim2.fromOffset(14, 0)
			titleLbl.Size = UDim2.new(1, -140, 1, 0)
			titleLbl.BackgroundTransparency = 1
			titleLbl.Text = title
			titleLbl.TextColor3 = Color3.fromRGB(195, 195, 205)
			titleLbl.FontFace = FONT_MED
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = topBtn

			local selectorPill = Instance.new("Frame")
			selectorPill.AnchorPoint = Vector2.new(1, 0.5)
			selectorPill.Position = UDim2.new(1, -10, 0.5, 0)
			selectorPill.Size = UDim2.fromOffset(108, 24)
			selectorPill.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
			selectorPill.BorderSizePixel = 0
			selectorPill.Parent = topBtn

			local pillCorner = Instance.new("UICorner")
			pillCorner.CornerRadius = UDim.new(0, 5)
			pillCorner.Parent = selectorPill

			local pillStroke = Instance.new("UIStroke")
			pillStroke.Color = Color3.fromRGB(34, 34, 41)
			pillStroke.Thickness = 1
			pillStroke.Parent = selectorPill

			local valueLbl = Instance.new("TextLabel")
			valueLbl.Position = UDim2.fromOffset(9, 0)
			valueLbl.Size = UDim2.new(1, -26, 1, 0)
			valueLbl.BackgroundTransparency = 1
			valueLbl.Text = selected
			valueLbl.TextColor3 = Color3.fromRGB(225, 225, 232)
			valueLbl.FontFace = FONT_REG
			valueLbl.TextSize = 12
			valueLbl.TextXAlignment = Enum.TextXAlignment.Left
			valueLbl.TextTruncate = Enum.TextTruncate.AtEnd
			valueLbl.Parent = selectorPill

			local chev = Instance.new("ImageLabel")
			chev.AnchorPoint = Vector2.new(1, 0.5)
			chev.Position = UDim2.new(1, -7, 0.5, 0)
			chev.Size = UDim2.fromOffset(12, 12)
			chev.BackgroundTransparency = 1
			chev.Image = LUCIDE.chevronDown
			chev.ImageColor3 = Color3.fromRGB(125, 125, 136)
			chev.ScaleType = Enum.ScaleType.Fit
			chev.Parent = selectorPill

			local optDivider = Instance.new("Frame")
			optDivider.Position = UDim2.fromOffset(12, 38)
			optDivider.Size = UDim2.new(1, -24, 0, 1)
			optDivider.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
			optDivider.BorderSizePixel = 0
			optDivider.Parent = card

			local optHolder = Instance.new("Frame")
			optHolder.Position = UDim2.fromOffset(8, 43)
			optHolder.Size = UDim2.new(1, -16, 0, #options * 28)
			optHolder.BackgroundTransparency = 1
			optHolder.Parent = card

			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding = UDim.new(0, 2)
			optLayout.SortOrder = Enum.SortOrder.LayoutOrder
			optLayout.Parent = optHolder

			local optionRows = {}

			local function refreshOptions()
				for _, opt in optionRows do
					local isChosen = (opt.name == selected)
					TweenService:Create(opt.btn, TWEEN_FAST, {
						BackgroundTransparency = if isChosen then 0 else 1,
						BackgroundColor3 = Color3.fromRGB(22, 22, 27),
					}):Play()
					TweenService:Create(opt.lbl, TWEEN_FAST, {
						TextColor3 = if isChosen then Color3.fromRGB(244, 244, 250) else Color3.fromRGB(140, 140, 152),
					}):Play()
					TweenService:Create(opt.check, TWEEN_FAST, {
						ImageTransparency = if isChosen then 0 else 1,
					}):Play()
				end
			end

			for i, optName in options do
				local optBtn = Instance.new("TextButton")
				optBtn.Name = optName
				optBtn.LayoutOrder = i
				optBtn.Size = UDim2.new(1, 0, 0, 26)
				optBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
				optBtn.BackgroundTransparency = 1
				optBtn.AutoButtonColor = false
				optBtn.Text = ""
				optBtn.Parent = optHolder

				local oCorner = Instance.new("UICorner")
				oCorner.CornerRadius = UDim.new(0, 5)
				oCorner.Parent = optBtn

				local oLbl = Instance.new("TextLabel")
				oLbl.Position = UDim2.fromOffset(8, 0)
				oLbl.Size = UDim2.new(1, -30, 1, 0)
				oLbl.BackgroundTransparency = 1
				oLbl.Text = optName
				oLbl.TextColor3 = Color3.fromRGB(140, 140, 152)
				oLbl.FontFace = FONT_REG
				oLbl.TextSize = 12
				oLbl.TextXAlignment = Enum.TextXAlignment.Left
				oLbl.Parent = optBtn

				local chk = Instance.new("ImageLabel")
				chk.AnchorPoint = Vector2.new(1, 0.5)
				chk.Position = UDim2.new(1, -8, 0.5, 0)
				chk.Size = UDim2.fromOffset(12, 12)
				chk.BackgroundTransparency = 1
				chk.Image = LUCIDE.check
				chk.ImageColor3 = Color3.fromRGB(240, 240, 246)
				chk.ImageTransparency = 1
				chk.ScaleType = Enum.ScaleType.Fit
				chk.Parent = optBtn

				optBtn.MouseEnter:Connect(function()
					if selected ~= optName then
						TweenService:Create(optBtn, TWEEN_FAST, { BackgroundTransparency = 0.45 }):Play()
						TweenService:Create(oLbl, TWEEN_FAST, { TextColor3 = Color3.fromRGB(215, 215, 225) }):Play()
					end
				end)

				optBtn.MouseLeave:Connect(function()
					if selected ~= optName then
						TweenService:Create(optBtn, TWEEN_FAST, { BackgroundTransparency = 1 }):Play()
						TweenService:Create(oLbl, TWEEN_FAST, { TextColor3 = Color3.fromRGB(140, 140, 152) }):Play()
					end
				end)

				optBtn.MouseButton1Click:Connect(function()
					selected = optName
					valueLbl.Text = optName
					refreshOptions()

					isExpanded = false
					TweenService:Create(card, TWEEN_SMOOTH, { Size = UDim2.new(1, 0, 0, 38) }):Play()
					TweenService:Create(chev, TWEEN_SMOOTH, { Rotation = 0, ImageColor3 = Color3.fromRGB(125, 125, 136) }):Play()
					TweenService:Create(pillStroke, TWEEN_FAST, { Color = Color3.fromRGB(34, 34, 41) }):Play()

					if callback then
						callback(optName)
					end
				end)

				table.insert(optionRows, { btn = optBtn, lbl = oLbl, check = chk, name = optName })
			end

			refreshOptions()

			topBtn.MouseEnter:Connect(function()
				TweenService:Create(card, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(18, 18, 22) }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Color = Color3.fromRGB(36, 36, 43) }):Play()
			end)

			topBtn.MouseLeave:Connect(function()
				TweenService:Create(card, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(15, 15, 18) }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Color = Color3.fromRGB(26, 26, 31) }):Play()
			end)

			topBtn.MouseButton1Click:Connect(function()
				isExpanded = not isExpanded
				local expandedHeight = 44 + (#options * 28) + 5
				TweenService:Create(card, TWEEN_SMOOTH, {
					Size = UDim2.new(1, 0, 0, if isExpanded then expandedHeight else 38),
				}):Play()
				TweenService:Create(chev, TWEEN_SMOOTH, {
					Rotation = if isExpanded then 180 else 0,
					ImageColor3 = if isExpanded then Color3.fromRGB(240, 240, 248) else Color3.fromRGB(125, 125, 136),
				}):Play()
				TweenService:Create(pillStroke, TWEEN_FAST, {
					Color = if isExpanded then Color3.fromRGB(52, 52, 62) else Color3.fromRGB(34, 34, 41),
				}):Play()
			end)
		end

		function TabObj:AddSlider(opts)
			opts = opts or {}
			local title = opts.Title or "Slider"
			local minVal = opts.Min or 0
			local maxVal = opts.Max or 100
			local defaultVal = opts.Default or minVal
			local suffix = opts.Suffix or ""
			local callback = opts.Callback

			itemOrder += 1

			local row = Instance.new("Frame")
			row.Name = title
			row.LayoutOrder = itemOrder
			row.Size = UDim2.new(1, 0, 0, 38)
			row.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
			row.BorderSizePixel = 0
			row.Parent = page

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = row

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(26, 26, 31)
			stroke.Thickness = 1
			stroke.Parent = row

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Position = UDim2.fromOffset(14, 0)
			titleLbl.Size = UDim2.new(0.45, 0, 1, 0)
			titleLbl.BackgroundTransparency = 1
			titleLbl.Text = title
			titleLbl.TextColor3 = Color3.fromRGB(195, 195, 205)
			titleLbl.FontFace = FONT_MED
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = row

			local valLbl = Instance.new("TextLabel")
			valLbl.AnchorPoint = Vector2.new(1, 0.5)
			valLbl.Position = UDim2.new(1, -14, 0.5, 0)
			valLbl.Size = UDim2.fromOffset(52, 18)
			valLbl.BackgroundTransparency = 1
			valLbl.Text = tostring(defaultVal) .. suffix
			valLbl.TextColor3 = Color3.fromRGB(145, 145, 156)
			valLbl.FontFace = FONT_REG
			valLbl.TextSize = 12
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.Parent = row

			local track = Instance.new("TextButton")
			track.AnchorPoint = Vector2.new(1, 0.5)
			track.Position = UDim2.new(1, -74, 0.5, 0)
			track.Size = UDim2.fromOffset(135, 4)
			track.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
			track.AutoButtonColor = false
			track.Text = ""
			track.Parent = row

			local trackCorner = Instance.new("UICorner")
			trackCorner.CornerRadius = UDim.new(1, 0)
			trackCorner.Parent = track

			local fill = Instance.new("Frame")
			fill.Size = UDim2.fromScale((defaultVal - minVal) / math.max(1, maxVal - minVal), 1)
			fill.BackgroundColor3 = Color3.fromRGB(238, 238, 245)
			fill.BorderSizePixel = 0
			fill.Parent = track

			local fillCorner = Instance.new("UICorner")
			fillCorner.CornerRadius = UDim.new(1, 0)
			fillCorner.Parent = fill

			local thumb = Instance.new("Frame")
			thumb.AnchorPoint = Vector2.new(0.5, 0.5)
			thumb.Position = UDim2.fromScale(1, 0.5)
			thumb.Size = UDim2.fromOffset(10, 10)
			thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			thumb.BorderSizePixel = 0
			thumb.Parent = fill

			local thumbCorner = Instance.new("UICorner")
			thumbCorner.CornerRadius = UDim.new(1, 0)
			thumbCorner.Parent = thumb

			local sliding = false
			local function updateSlider()
				local mouseX = UserInputService:GetMouseLocation().X
				local alpha = math.clamp((mouseX - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
				local value = math.round(minVal + alpha * (maxVal - minVal))
				valLbl.Text = tostring(value) .. suffix
				TweenService:Create(fill, TWEEN_FAST, { Size = UDim2.fromScale(alpha, 1) }):Play()
				if callback then
					callback(value)
				end
			end

			track.MouseButton1Down:Connect(function()
				sliding = true
				updateSlider()
			end)

			UserInputService.InputEnded:Connect(function(io)
				if io.UserInputType == Enum.UserInputType.MouseButton1 then
					sliding = false
				end
			end)

			UserInputService.InputChanged:Connect(function(io)
				if sliding and io.UserInputType == Enum.UserInputType.MouseMovement then
					updateSlider()
				end
			end)
		end

		function TabObj:AddButton(opts)
			opts = opts or {}
			local title = opts.Title or "Button"
			local callback = opts.Callback

			itemOrder += 1

			local row = Instance.new("TextButton")
			row.Name = title
			row.LayoutOrder = itemOrder
			row.Size = UDim2.new(1, 0, 0, 38)
			row.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
			row.AutoButtonColor = false
			row.Text = ""
			row.Parent = page

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0, 6)
			corner.Parent = row

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(26, 26, 31)
			stroke.Thickness = 1
			stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			stroke.Parent = row

			local titleLbl = Instance.new("TextLabel")
			titleLbl.Position = UDim2.fromOffset(14, 0)
			titleLbl.Size = UDim2.new(1, -44, 1, 0)
			titleLbl.BackgroundTransparency = 1
			titleLbl.Text = title
			titleLbl.TextColor3 = Color3.fromRGB(215, 215, 224)
			titleLbl.FontFace = FONT_MED
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.Parent = row

			local arrow = Instance.new("ImageLabel")
			arrow.AnchorPoint = Vector2.new(1, 0.5)
			arrow.Position = UDim2.new(1, -14, 0.5, 0)
			arrow.Size = UDim2.fromOffset(14, 14)
			arrow.BackgroundTransparency = 1
			arrow.Image = LUCIDE.chevronRight
			arrow.ImageColor3 = Color3.fromRGB(110, 110, 122)
			arrow.ScaleType = Enum.ScaleType.Fit
			arrow.Parent = row

			row.MouseEnter:Connect(function()
				TweenService:Create(row, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(19, 19, 23) }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Color = Color3.fromRGB(38, 38, 46) }):Play()
				TweenService:Create(arrow, TWEEN_FAST, {
					Position = UDim2.new(1, -11, 0.5, 0),
					ImageColor3 = Color3.fromRGB(235, 235, 242),
				}):Play()
			end)

			row.MouseLeave:Connect(function()
				TweenService:Create(row, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(15, 15, 18) }):Play()
				TweenService:Create(stroke, TWEEN_FAST, { Color = Color3.fromRGB(26, 26, 31) }):Play()
				TweenService:Create(arrow, TWEEN_FAST, {
					Position = UDim2.new(1, -14, 0.5, 0),
					ImageColor3 = Color3.fromRGB(110, 110, 122),
				}):Play()
			end)

			row.MouseButton1Click:Connect(function()
				row.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
				TweenService:Create(row, TWEEN_FAST, { BackgroundColor3 = Color3.fromRGB(19, 19, 23) }):Play()
				if callback then
					callback()
				end
			end)
		end

		return TabObj
	end

	return WindowObj
end

return SparkUI

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/Library.lua"))()

local Window = Library:CreateWindow({
	Title = "Spark",
	ToggleKey = Enum.KeyCode.LeftAlt,
})

local Main = Window:AddTab({ Name = "Main", Icon = "rbxassetid://81589895647169" })
local Extra = Window:AddTab({ Name = "Extra", Icon = "rbxassetid://134242818164054" })
local Info = Window:AddTab({ Name = "Info", Icon = "rbxassetid://84279202219901" })

local Toggles = Main:AddSection({ Name = "Toggles", Side = "Left" })
local Controls = Main:AddSection({ Name = "Controls", Side = "Right" })

local MyToggle = Toggles:AddToggle({
	Name = "Toggle",
	Default = false,
	Flag = "MyToggle",
	Callback = function(enabled)
		print("Toggle:", enabled)
	end,
})

local KeyToggle = Toggles:AddToggle({
	Name = "Toggle With Keybind",
	Keybind = Enum.KeyCode.F,
	KeybindMode = "Toggle",
	Callback = function(enabled)
		print("Keybind toggle:", enabled)
	end,
	KeybindChanged = function(key)
		print("New key:", key and key.Name or "None")
	end,
})

Toggles:AddToggle({
	Name = "Hold Toggle",
	Keybind = Enum.KeyCode.E,
	KeybindMode = "Hold",
	Callback = function(enabled)
		print("Held:", enabled)
	end,
})

Toggles:AddButton({
	Name = "Button",
	Callback = function()
		Library:Notify({ Text = "Button pressed!", Duration = 3 })
	end,
})

Toggles:AddKeybind({
	Name = "Keybind",
	Default = Enum.KeyCode.P,
	Mode = "Press",
	Callback = function()
		print("Keybind pressed")
	end,
	ChangedCallback = function(key)
		print("Keybind changed to", key and key.Name or "None")
	end,
})

Controls:AddSlider({
	Name = "Slider",
	Min = 0,
	Max = 200,
	Default = 16,
	Increment = 1,
	Callback = function(value)
		print("Slider:", value)
	end,
})

local MyDropdown = Controls:AddDropdown({
	Name = "Dropdown",
	Options = { "Option 1", "Option 2", "Option 3", "Option 4" },
	Default = "Option 1",
	Callback = function(option)
		print("Dropdown:", option)
	end,
})

Controls:AddColorPicker({
	Name = "Color",
	Default = Color3.fromRGB(69, 255, 122),
	Callback = function(color)
		print("Color:", color:ToHex())
	end,
})

local More = Extra:AddSection({ Name = "More", Side = "Left" })
More:AddSlider({ Name = "Decimal Slider", Min = 0, Max = 1, Default = 0.5, Increment = 0.05 })
More:AddButton({
	Name = "Refresh Dropdown",
	Callback = function()
		MyDropdown:Refresh({ "New A", "New B", "New C" })
		MyDropdown:Set("New A")
	end,
})

local About = Info:AddSection({ Name = "Script Info", Side = "Left" })
About:AddLabel({ Text = "Script created by", Right = "@YourName" })
About:AddButton({
	Name = "Copy Discord",
	Icon = "Copy",
	ClickText = "Copied!",
	Callback = function()
		if setclipboard then
			setclipboard("https://discord.gg/your-invite")
		end
	end,
})
About:AddKeybind({
	Name = "UI Toggle",
	Default = Enum.KeyCode.LeftAlt,
	ChangedCallback = function(key)
		Window:SetToggleKey(key)
	end,
})

local Status = Info:AddSection({ Name = "Status", Side = "Right" })

local ServerStatus = Status:AddStatus({ Name = "Server", Status = "Online", Color = Color3.fromRGB(69, 255, 122) })

Status:AddTextbox({
	Name = "Player",
	Placeholder = "Username...",
	Callback = function(text, enterPressed)
		print("Textbox:", text, enterPressed)
	end,
})

Status:AddDivider()

Status:AddParagraph({
	Title = "Changelog",
	Text = "Added the status list, status rows, textboxes, paragraphs and dividers.",
})

local List = Status:AddStatusList({ Name = "Active" })
local Line = List:Add("Server", "Online", Color3.fromRGB(69, 255, 122))

task.delay(5, function()
	ServerStatus:Set("Slow", Color3.fromRGB(255, 190, 70))
	Line:Set("Slow", Color3.fromRGB(255, 190, 70))
end)

MyToggle:Set(true)
print("Flag value:", Library.Flags.MyToggle)

Library:Notify({ Text = "Spark loaded!", Duration = 6 })

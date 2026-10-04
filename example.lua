local SparkUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sharpie837/SparkUI/main/SparkUI.lua"))()

local Window = SparkUI:CreateWindow({
	Title = "Spark",
	Keybind = Enum.KeyCode.RightShift,
})

local MainTab = Window:CreateTab({
	Name = "Example Tab",
	Icon = "94212016861936",
})

MainTab:AddToggle({
	Title = "Example Toggle",
	Default = false,
	Keybind = Enum.KeyCode.F,
	Callback = function(state) end,
})

MainTab:AddDropdown({
	Title = "Example Dropdown",
	Options = { "Option 1", "Option 2", "Option 3" },
	Default = "Option 1",
	Callback = function(option) end,
})

MainTab:AddSlider({
	Title = "Example Slider",
	Min = 0,
	Max = 100,
	Default = 50,
	Suffix = "",
	Callback = function(value) end,
})

MainTab:AddColorPicker({
	Title = "Example Colorpicker",
	Default = Color3.fromRGB(255, 255, 255),
	Callback = function(color) end,
})

MainTab:AddKeybind({
	Title = "Example Keybind",
	Default = Enum.KeyCode.E,
	Callback = function(key) end,
})

MainTab:AddButton({
	Title = "Example Button",
	Callback = function() end,
})

local SettingsTab = Window:CreateTab({
	Name = "Settings",
	Icon = "116544501716299",
})

SettingsTab:AddButton({
	Title = "Unload Interface",
	Callback = function()
		Window:Destroy()
	end,
})

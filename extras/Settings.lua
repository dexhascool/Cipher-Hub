local Settings = {}

local toggleYOffset = 60
function Settings:AddToggle(settingKey, displayName, defaultState, fileName)
    if not _G.CipherUtils then
        warn("CipherUtils not found! Load the loader script first.")
        return
    end

    local settingsPath = "ciphub/settings/" .. fileName
    local toggleState = defaultState
    if isfile(settingsPath) then
        local savedState = readfile(settingsPath)
        toggleState = (savedState == "true")
    else
        writefile(settingsPath, tostring(toggleState))
    end

    local label = _G.CipherUtils.createInstance("TextLabel", {
        Name = settingKey .. "Label",
        Text = displayName,
        Size = UDim2.new(0, 140, 0, 30),
        Position = UDim2.new(0, 10, 0, toggleYOffset),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, self.UIFrame)

    local toggleContainer = _G.CipherUtils.createInstance("Frame", {
        Name = settingKey .. "ToggleContainer",
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(0, 160, 0, toggleYOffset),
        BackgroundColor3 = (toggleState and Color3.fromRGB(0, 150, 0)) or Color3.fromRGB(180, 180, 180),
    }, self.UIFrame)

    local knobPosition = toggleState and UDim2.new(1, -28, 0, 2) or UDim2.new(0, 2, 0, 2)
    local knob = _G.CipherUtils.createInstance("Frame", {
        Name = settingKey .. "ToggleKnob",
        Size = UDim2.new(0, 26, 0, 26),
        Position = knobPosition,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, toggleContainer)

    local toggleButton = _G.CipherUtils.createInstance("TextButton", {
        Name = settingKey .. "ToggleButton",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
    }, toggleContainer)

    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        if toggleState then
            knob.Position = UDim2.new(1, -28, 0, 2)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        else
            knob.Position = UDim2.new(0, 2, 0, 2)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
        end
        writefile(settingsPath, tostring(toggleState))
        if Settings.OnToggle then
            Settings.OnToggle(settingKey, toggleState)
        end
    end)

    toggleYOffset = toggleYOffset + 40
end

function Settings:CreateSettingsUI()
    if not _G.CipherUtils then
        warn("CipherUtils not found! Load the loader script first.")
        return
    end

    local screenGui = game:GetService("CoreGui"):FindFirstChild("CipherHubGui") or game:GetService("CoreGui")
    self.UIFrame = _G.CipherUtils.createInstance("Frame", {
        Name = "SettingsFrame",
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
    }, screenGui)

    _G.CipherUtils.createInstance("TextLabel", {
        Name = "TitleLabel",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 10),
        Text = "Settings",
        Font = Enum.Font.SourceSansBold,
        TextSize = 20,
        BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
    }, self.UIFrame)

    toggleYOffset = 60

    self:AddToggle("ShowChangelog", "Show Changelog:", true, "ShowChangelog.txt")
    self:AddToggle("ExampleToggle", "Example Toggle:", false, "ExampleToggle.txt")

    return self.UIFrame
end
return Settings

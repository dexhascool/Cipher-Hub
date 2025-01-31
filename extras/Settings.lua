local Settings = {}

function Settings:CreateSettingsUI()
    if not _G.CipherUtils then
        warn("CipherUtils not found! Load the loader script first.")
        return
    end

    settingsFrame = _G.CipherUtils.createInstance("Frame", {
        Name = "SettingsFrame",
        Size = UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
    }, nil)

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
    }, settingsFrame)

    _G.CipherUtils.createInstance("TextLabel", {
        Name = "ToggleLabel",
        Text = "Example Toggle",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
    }, settingsFrame)

    local toggleButton = _G.CipherUtils.createInstance("TextButton", {
        Name = "ToggleButton",
        Text = "OFF",
        Size = UDim2.new(0, 80, 0, 30),
        Position = UDim2.new(0, 10, 0, 90),
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
    }, settingsFrame)

    local toggleState = false
    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        toggleButton.Text = toggleState and "ON" or "OFF"
        toggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(0, 150, 0) or Color3.new(0.2, 0.2, 0.2)

        local settingsPath = "ciphub/settings/ExampleToggle.txt"
        writefile(settingsPath, tostring(toggleState))

        if Settings.OnToggle then
            Settings.OnToggle("ExampleToggle", toggleState)
        end
    end)

    local settingsPath = "ciphub/settings/ExampleToggle.txt"
    if isfile(settingsPath) then
        local savedState = readfile(settingsPath)
        toggleState = savedState == "true"
        toggleButton.Text = toggleState and "ON" or "OFF"
        toggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(0, 150, 0) or Color3.new(0.2, 0.2, 0.2)
    end

    return settingsFrame
end

return Settings

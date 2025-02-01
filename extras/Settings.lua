local Settings = {}

function Settings:CreateSettingsUI()
    if not _G.CipherUtils then
        warn("CipherUtils not found! Load the loader script first.")
        return
    end

    local screenGui = game:GetService("CoreGui"):FindFirstChild("CipherHubGui") or game:GetService("CoreGui")
    settingsFrame = _G.CipherUtils.createInstance("Frame", {
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
    }, settingsFrame)

    _G.CipherUtils.createInstance("TextLabel", {
        Name = "ToggleLabel",
        Text = "Example Toggle:",
        Size = UDim2.new(0, 120, 0, 30),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, settingsFrame)

    local toggleContainer = _G.CipherUtils.createInstance("Frame", {
        Name = "ToggleContainer",
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(0, 140, 0, 60),
        BackgroundColor3 = Color3.fromRGB(180, 180, 180),
    }, settingsFrame)
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 15)
    containerCorner.Parent = toggleContainer

    local knob = _G.CipherUtils.createInstance("Frame", {
        Name = "ToggleKnob",
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    }, toggleContainer)
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0, 13)
    knobCorner.Parent = knob

    local toggleStateLabel = _G.CipherUtils.createInstance("TextLabel", {
        Name = "ToggleStateLabel",
        Size = UDim2.new(0, 50, 0, 30),
        Position = UDim2.new(0, 210, 0, 60),
        Text = "OFF",
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        BackgroundTransparency = 1,
        TextColor3 = Color3.new(1, 1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
    }, settingsFrame)

    local toggleButton = _G.CipherUtils.createInstance("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
    }, toggleContainer)

    local toggleState = false
    toggleButton.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        if toggleState then
            knob.Position = UDim2.new(1, -28, 0, 2)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            toggleStateLabel.Text = "ON"
        else
            knob.Position = UDim2.new(0, 2, 0, 2)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            toggleStateLabel.Text = "OFF"
        end

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
        if toggleState then
            knob.Position = UDim2.new(1, -28, 0, 2)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            toggleStateLabel.Text = "ON"
        else
            knob.Position = UDim2.new(0, 2, 0, 2)
            toggleContainer.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            toggleStateLabel.Text = "OFF"
        end
    end

    return settingsFrame
end
return Settings

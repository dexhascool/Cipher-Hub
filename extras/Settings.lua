local Settings = {}

function Settings:CreateSettingsUI()
    if not _G.CipherUtils then
        warn("CipherUtils not found! Load the loader script first.")
        return
    end

    local settingsFrame = _G.CipherUtils.createInstance("Frame", {
        Name = "SettingsFrame",
        Size = UDim2.new(0, 300, 0, 400),
        Position = UDim2.new(0.5, -150, 0.5, -200),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Visible = false,
        Parent = nil
    })

    _G.CipherUtils.createInstance("TextButton", {
        Name = "CloseButton",
        Text = "Close",
        Size = UDim2.new(0, 80, 0, 30),
        Position = UDim2.new(1, -90, 0, 10),
        BackgroundColor3 = Color3.fromRGB(150, 0, 0),
        Parent = settingsFrame,
        MouseButton1Click = function()
            settingsFrame.Visible = false
        end
    })

    _G.CipherUtils.createInstance("TextLabel", {
        Name = "TitleLabel",
        Text = "Settings",
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 20,
        Parent = settingsFrame
    })

    local toggleLabel = _G.CipherUtils.createInstance("TextLabel", {
        Name = "ToggleLabel",
        Text = "Example Toggle",
        Size = UDim2.new(0, 200, 0, 30),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        Parent = settingsFrame
    })

    local toggleButton = _G.CipherUtils.createInstance("TextButton", {
        Name = "ToggleButton",
        Text = "OFF",
        Size = UDim2.new(0, 80, 0, 30),
        Position = UDim2.new(0, 220, 0, 60),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        Parent = settingsFrame
    })

    local toggleState = false
    toggleButton.MouseButton1Click = function()
        toggleState = not toggleState
        toggleButton.Text = toggleState and "ON" or "OFF"
        toggleButton.BackgroundColor3 = toggleState and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(50, 50, 50)

        if Settings.OnToggle then
            Settings.OnToggle("ExampleToggle", toggleState)
        end
    end

    return settingsFrame
end

return Settings

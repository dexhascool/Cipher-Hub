if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local createInstance = _G.CipherUtils.createInstance
local baseUi = {}

function baseUi.createUi(title, uiElements)
    local screenGui = createInstance("ScreenGui", { Name = title .. "Gui" }, game:GetService("CoreGui"))

    local frameHeight = 50 + (uiElements * 50)
    local frame = createInstance("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 400, 0, frameHeight),
        Position = UDim2.new(0.5, -200, 0, 10),
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        BorderSizePixel = 0,
    }, screenGui)

    local topBar = createInstance("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = Color3.fromRGB(70, 70, 70),
        BorderSizePixel = 0,
    }, frame)

    createInstance("TextLabel", {
        Name = "TitleLabel",
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        Text = title,
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
    }, topBar)

    local minimizeButton = createInstance("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        Text = "-",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 18,
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
    }, topBar)

    local reloadButton = createInstance("TextButton", {
        Name = "ReloadButton",
        Size = UDim2.new(0, 60, 1, 0),
        Position = UDim2.new(1, -100, 0, 0),
        Text = "Reload",
        TextColor3 = Color3.new(1, 1, 1),
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        BackgroundColor3 = Color3.fromRGB(120, 60, 60),
        BorderSizePixel = 0,
    }, topBar)

    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        frame.Size = UDim2.new(0, 400, 0, isMinimized and 30 or frameHeight)
        for _, child in pairs(frame:GetChildren()) do
            if child ~= topBar then
                child.Visible = not isMinimized
            end
        end
        minimizeButton.Text = isMinimized and "+" or "-"
    end)

    reloadButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/loader.lua"))()
    end)

    return frame
end

function baseUi.addInputBox(parent, placeholder, position)
    return createInstance("TextBox", {
        Name = placeholder .. "Box",
        Size = UDim2.new(1, -20, 0, 40),
        Position = position,
        PlaceholderText = placeholder,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Text = "",
        TextWrapped = true,
    }, parent)
end

function baseUi.addEncodeButton(parent, position)
    return createInstance("TextButton", {
        Name = "EncodeButton",
        Size = UDim2.new(1, -40, 0, 36),
        Position = position,
        Text = "Encode",
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.new(1, 1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 115, 200),
        BorderSizePixel = 0,
    }, parent)
end

function baseUi.addResultLabel(parent, position)
    return createInstance("TextLabel", {
        Name = "ResultLabel",
        Size = UDim2.new(1, -20, 0, 40),
        Position = position,
        Text = "<b>Encoded:</b> ",
        RichText = true,
        TextWrapped = true,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
    }, parent)
end

return baseUi

loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/Ciphers.lua"))()

_G.CipherUtils = _G.CipherUtils or {}

local parentFolderName = "ciphub"
if not isfolder(parentFolderName) then
    makefolder(parentFolderName)
end

local logsFolderPath = parentFolderName .. "/logs"
if not isfolder(logsFolderPath) then
    makefolder(logsFolderPath)
end

local settingsFolderPath = parentFolderName .. "/settings"
if not isfolder(settingsFolderPath) then
    makefolder(settingsFolderPath)
end

local timestamp = os.date("%Y%m%d_%H%M%S")
local logFileName = logsFolderPath .. "/CipherHub_" .. timestamp .. ".txt"
if not isfile(logFileName) then
    writefile(logFileName, "")
end

function _G.CipherUtils.log(message)
    local formattedMessage = "[CipherUtils]: " .. message
    print(formattedMessage)
    appendfile(logFileName, formattedMessage .. "\n")
end

function _G.CipherUtils.fetchCiphers()
    return _G.ciphers
end

function _G.CipherUtils.createInstance(className, properties, parent)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop == "MouseButton1Click" then
            instance[prop]:Connect(value)
        else
            instance[prop] = value
        end
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

function _G.CipherUtils.chatMessage(str)
    str = tostring(str)
    local TextChatService = game:GetService("TextChatService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local isLegacyChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") ~= nil

    if not isLegacyChat then
        local channelsFolder = TextChatService:FindFirstChild("TextChannels")
        if channelsFolder then
            local targetChannel = channelsFolder:FindFirstChild("RBXGeneral") or 
                                  channelsFolder:FindFirstChildWhichIsA("TextChannel")
            if targetChannel then
                local success, err = pcall(function()
                    targetChannel:SendAsync(str)
                end)
                if not success then
                    warn("Failed to send message: " .. tostring(err))
                end
            else
                warn("Error: No valid text channels found.")
            end
        else
            warn("Error: No text channels available. The game may have chat disabled.")
        end
    else
        local sayMessageEvent = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and 
                                ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if sayMessageEvent then
            local success, err = pcall(function()
                sayMessageEvent:FireServer(str, "All")
            end)
            if not success then
                warn("Failed to send message via legacy chat system: " .. tostring(err))
            end
        else
            warn("Error: Legacy chat system not found. Ensure chat is enabled in this game.")
        end
    end
end

local screenGui = _G.CipherUtils.createInstance("ScreenGui", { Name = "CipherHubGui" }, game:GetService("CoreGui"))

local titleLabel = _G.CipherUtils.createInstance("TextLabel", {
    Size = UDim2.new(0, 400, 0, 50),
    Position = UDim2.new(0.5, -200, 0, 10),
    Text = "Cipher Hub",
    Font = Enum.Font.SourceSansBold,
    TextSize = 32,
    BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
    TextColor3 = Color3.new(1, 1, 1),
}, screenGui)

local buttonSlotFrame = _G.CipherUtils.createInstance("Frame", {
    Size = UDim2.new(0, 400, 0, 40),
    Position = UDim2.new(0.5, -200, 0, 60),
    BackgroundColor3 = Color3.new(0.15, 0.15, 0.15),
    BorderSizePixel = 1,
}, screenGui)

local scrollingFrame = _G.CipherUtils.createInstance("ScrollingFrame", {
    Size = UDim2.new(0, 400, 0, 300),
    Position = UDim2.new(0.5, -200, 0, 110),
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 8,
    BackgroundColor3 = Color3.new(0.1, 0.1, 0.1),
    BorderSizePixel = 1,
}, screenGui)

local yOffset = 0
for cipherName, data in pairs(_G.CipherUtils.fetchCiphers()) do
    _G.CipherUtils.createInstance("TextButton", {
        Size = UDim2.new(0, 380, 0, 50),
        Position = UDim2.new(0, 10, 0, yOffset),
        Text = "Load " .. cipherName,
        Font = Enum.Font.SourceSans,
        TextSize = 24,
        BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
        TextColor3 = Color3.new(1, 1, 1),
        MouseButton1Click = function()
            local success, result = pcall(function()
                loadstring(game:HttpGet(data.url))()
            end)
            if success then
                _G.CipherUtils.log(cipherName .. " Cipher successfully loaded.")
                screenGui:Destroy()
            else
                warn("Failed to load " .. cipherName .. ": " .. tostring(result))
            end
        end
    }, scrollingFrame)

    _G.CipherUtils.createInstance("TextLabel", {
        Size = UDim2.new(0, 380, 0, 30),
        Position = UDim2.new(0, 10, 0, yOffset + 50),
        Text = data.description,
        Font = Enum.Font.SourceSansItalic,
        TextSize = 18,
        BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
        TextColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0
    }, scrollingFrame)

    yOffset = yOffset + 90
end

scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)

local versionData = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/main/extras/Version.lua"))()

local versionFrame

_G.CipherUtils.createInstance("TextButton", {
    Size = UDim2.new(0, 120, 0, 30),
    Position = UDim2.new(0, 10, 0.5, -15),
    Text = "Version Info",
    Font = Enum.Font.SourceSans,
    TextSize = 18,
    BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
    TextColor3 = Color3.new(1, 1, 1),
    MouseButton1Click = function()
        if versionFrame then
            versionFrame:Destroy()
            versionFrame = nil
        else
            versionFrame = _G.CipherUtils.createInstance("Frame", {
                Size = UDim2.new(0, 300, 0, 200),
                Position = UDim2.new(0.5, 0, 0.5, 0),
                BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Visible = false,
            }, screenGui)

            local versionLabel = _G.CipherUtils.createInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 30),
                Position = UDim2.new(0, 10, 0, 10),
                Text = "Version: " .. versionData.version,
                Font = Enum.Font.SourceSansBold,
                TextSize = 20,
                BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
            }, versionFrame)

            local descriptionLabel = _G.CipherUtils.createInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 50),
                Position = UDim2.new(0, 10, 0, 50),
                Text = "Description: " .. versionData.description,
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                BackgroundTransparency = 1,
                TextWrapped = true,
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Center,
            }, versionFrame)

            local changelogLabel = _G.CipherUtils.createInstance("TextLabel", {
                Size = UDim2.new(1, -20, 0, 80),
                Position = UDim2.new(0, 10, 0, 110),
                Text = "Changelog:\n" .. table.concat(versionData.changelog, "\n"),
                Font = Enum.Font.SourceSans,
                TextSize = 16,
                BackgroundTransparency = 1,
                TextWrapped = true,
                TextColor3 = Color3.new(1, 1, 1),
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
            }, versionFrame)

            versionFrame.Visible = not versionFrame.Visible
        end
    end
}, buttonSlotFrame)

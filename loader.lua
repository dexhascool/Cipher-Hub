_G.CipherUtils = _G.CipherUtils or {}

local ciphers = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/Ciphers.lua"))()

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

local versionData = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/main/extras/Version.lua"))()
local titleLabel = _G.CipherUtils.createInstance("TextLabel", {
    Size = UDim2.new(0, 400, 0, 50),
    Position = UDim2.new(0.5, -200, 0, 10),
    Text = "Cipher Hub v" .. versionData.version,
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
for cipherName, data in pairs(ciphers) do
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

local versionFrame
local parentFolderName = "ciphub"

if not isfolder(parentFolderName) then
    makefolder(parentFolderName)
end

local versionFilePath = parentFolderName .. "/version.txt"
local githubVersion = versionData.version

local function showVersionInfo()
    if versionFrame then
        versionFrame:Destroy()
        versionFrame = nil
    else
        local function processChangelog(changelog)
            local processed = {}
            for _, line in ipairs(changelog) do
                if string.find(line, "Added") or string.find(line, "Implemented") or string.find(line, "Improved") then
                    table.insert(processed, '<font color="#00FF00">[+]</font> ' .. line)
                elseif string.find(line, "Removed") then
                    table.insert(processed, '<font color="#FF0000">[-]</font> ' .. line)
                else
                    table.insert(processed, line)
                end
            end
            return table.concat(processed, "\n")
        end

        local newChangelog = processChangelog(versionData.changelog)

        versionFrame = _G.CipherUtils.createInstance("Frame", {
            Size = UDim2.new(0, 300, 0, 200),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Color3.new(0.2, 0.2, 0.2),
            AnchorPoint = Vector2.new(0.5, 0.5),
        }, screenGui)

        _G.CipherUtils.createInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 30),
            Position = UDim2.new(0, 10, 0, 10),
            Text = "Version: " .. githubVersion,
            Font = Enum.Font.SourceSansBold,
            TextSize = 20,
            BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
        }, versionFrame)

        _G.CipherUtils.createInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 50),
            Position = UDim2.new(0, 10, 0, 50),
            Text = "<b>Description:</b> " .. versionData.description,
            RichText = true,
            Font = Enum.Font.SourceSans,
            TextSize = 16,
            BackgroundTransparency = 1,
            TextWrapped = true,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Center,
        }, versionFrame)

        _G.CipherUtils.createInstance("TextLabel", {
            Size = UDim2.new(1, -20, 0, 80),
            Position = UDim2.new(0, 10, 0, 110),
            Text = "<b>Changelog:</b>\n" .. newChangelog,
            RichText = true,
            Font = Enum.Font.SourceSans,
            TextSize = 16,
            BackgroundTransparency = 1,
            TextWrapped = true,
            TextColor3 = Color3.new(1, 1, 1),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
        }, versionFrame)
    end
end

local settingsFrame
local function showSettings()
    if settingsFrame then
        settingsFrame:Destroy()
        settingsFrame = nil
    else
        local Settings = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/Settings.lua"))()
        settingsFrame = Settings:CreateSettingsUI()
    end
end

_G.CipherUtils.createInstance("TextButton", {
    Size = UDim2.new(0, 120, 0, 30),
    Position = UDim2.new(0, 140, 0.5, -15),
    Text = "Settings",
    Font = Enum.Font.SourceSans,
    TextSize = 18,
    BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
    TextColor3 = Color3.new(1, 1, 1),
    MouseButton1Click = showSettings
}, buttonSlotFrame)

if isfile(versionFilePath) then
    local savedVersion = readfile(versionFilePath)
    if savedVersion == githubVersion then
        _G.CipherUtils.log("Version is up to date: " .. savedVersion)
    else
        _G.CipherUtils.log("Version mismatch! Updating version file and showing changelog.")
        writefile(versionFilePath, githubVersion)
        
        local showChangelogPath = "ciphub/settings/ShowChangelog.txt"
        if isfile(showChangelogPath) then
            local showChangelogState = readfile(showChangelogPath)
            if showChangelogState == "true" then
                showVersionInfo()
            end
        else
            showVersionInfo()
        end
    end
else
    _G.CipherUtils.log("Version file not found. Creating a new one and showing changelog.")
    writefile(versionFilePath, githubVersion)
    
    local showChangelogPath = "ciphub/settings/ShowChangelog.txt"
    if isfile(showChangelogPath) then
        local showChangelogState = readfile(showChangelogPath)
        if showChangelogState == "true" then
            showVersionInfo()
        end
    else
        showVersionInfo()
    end
end

_G.CipherUtils.createInstance("TextButton", {
    Size = UDim2.new(0, 120, 0, 30),
    Position = UDim2.new(0, 10, 0.5, -15),
    Text = "Version Info",
    Font = Enum.Font.SourceSans,
    TextSize = 18,
    BackgroundColor3 = Color3.new(0.3, 0.3, 0.3),
    TextColor3 = Color3.new(1, 1, 1),
    MouseButton1Click = showVersionInfo
}, buttonSlotFrame)

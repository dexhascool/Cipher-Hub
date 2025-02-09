if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function byteToBinary(byte)
    local bits = {}
    for i = 7, 0, -1 do
        local bit = math.floor(byte / 2^i) % 2
        table.insert(bits, tostring(bit))
    end
    return table.concat(bits)
end

local function textToBinary(text)
    local binary = {}
    for i = 1, #text do
        local byte = string.byte(text, i)
        table.insert(binary, byteToBinary(byte))
    end
    return table.concat(binary, " ")
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Binary Encoder", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 100))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 150))

local lastInputText = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if inputText == lastInputText then
        log("Input is identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input is the same as last time"
        return
    end

    lastInputText = inputText
    local binaryText = textToBinary(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. binaryText
    log("Encoded: " .. binaryText)
    chatMessage(binaryText)
end)

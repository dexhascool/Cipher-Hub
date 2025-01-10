if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function gilbertCipher(text, key)
    local result = {}
    local keyIndex = 1
    local keyLength = #key

    for char in text:gmatch(".") do
        if char:match("[A-Za-z]") then
            local base = (char:match("[A-Z]") and 65 or 97)
            local shift = key:byte(keyIndex) - (key:match("[A-Z]") and 65 or 97)
            local newChar = string.char(((char:byte() - base + shift) % 26) + base)
            table.insert(result, newChar)
            keyIndex = (keyIndex % keyLength) + 1
        else
            table.insert(result, char)
        end
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Gilbert Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter key", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastKeyText = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local keyText = keyBox.Text

    if inputText == "" or keyText == "" then
        log("Input or key is blank. No encoding performed.")
        resultLabel.Text = "Input or key is blank"
        return
    end

    if inputText == lastInputText and keyText == lastKeyText then
        log("Input and key are identical to the last processed values. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKeyText = keyText
    local encodedText = gilbertCipher(inputText, keyText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

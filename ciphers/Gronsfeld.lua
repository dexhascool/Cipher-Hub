if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function gronsfeldCipher(text, key)
    local result = {}
    local keyLength = #key
    local keyIndex = 1

    for char in text:gmatch(".") do
        local charCode = string.byte(char)
        local shiftValue = tonumber(key:sub(keyIndex, keyIndex))
        
        if char:match("%a") then
            if char:match("%u") then
                charCode = ((charCode - 65 + shiftValue) % 26) + 65 -- Uppercase
            else
                charCode = ((charCode - 97 + shiftValue) % 26) + 97 -- Lowercase
            end
            keyIndex = keyIndex == keyLength and 1 or keyIndex + 1
        end

        table.insert(result, string.char(charCode))
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Gronsfeld Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter key (numbers only)", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastKey = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local key = keyBox.Text

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if key == "" or not key:match("^[0-9]+$") then
        log("Invalid key. Enter a numeric key.")
        resultLabel.Text = "Invalid key"
        return
    end

    if inputText == lastInputText and key == lastKey then
        log("Input and key are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKey = key
    local encodedText = gronsfeldCipher(inputText, key)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

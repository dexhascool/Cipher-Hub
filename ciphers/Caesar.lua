if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function caesarCipher(text, shift)
    shift = shift % 26
    local result = {}
    
    for char in text:gmatch(".") do
        local byte = char:byte()

        if byte >= 65 and byte <= 90 then -- Uppercase
            table.insert(result, string.char(((byte - 65 + shift) % 26) + 65))
        elseif byte >= 97 and byte <= 122 then -- Lowercase
            table.insert(result, string.char(((byte - 97 + shift) % 26) + 97))
        else
            table.insert(result, char)
        end
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Caesar Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local shiftBox = baseUi.addInputBox(frame, "Enter shift value", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastShiftValue = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local shiftValue = tonumber(shiftBox.Text)

    if not shiftValue then
        log("Shift value is not valid. Please enter a number.")
        resultLabel.Text = "Invalid shift value"
        return
    end

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if inputText == lastInputText and shiftValue == lastShiftValue then
        log("Input and shift are identical to the last processed values. No encoding performed.")
        resultLabel.Text = "Input and shift are the same as last time"
        return
    end

    lastInputText = inputText
    lastShiftValue = shiftValue
    local encodedText = caesarCipher(inputText, shiftValue)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

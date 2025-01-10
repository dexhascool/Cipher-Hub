if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function autokeyCipher(text, key)
    local result = {}
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    text = text:upper()
    key = key:upper()

    local extendedKey = key .. text
    local keyIndex = 1

    for i = 1, #text do
        local textChar = text:sub(i, i)
        if textChar:match("%A") then
            table.insert(result, textChar)
        else
            local textPos = alphabet:find(textChar)
            local keyPos = alphabet:find(extendedKey:sub(keyIndex, keyIndex))

            if textPos and keyPos then
                local encryptedPos = (textPos + keyPos - 2) % 26 + 1
                table.insert(result, alphabet:sub(encryptedPos, encryptedPos))
                keyIndex = keyIndex + 1
            end
        end
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Autokey Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter key", UDim2.new(0, 10, 0, 100))
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

    if key == "" then
        log("Key is blank. No encoding performed.")
        resultLabel.Text = "Key cannot be blank"
        return
    end

    if inputText == lastInputText and key == lastKey then
        log("Input and key are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKey = key

    local encodedText = autokeyCipher(inputText, key)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

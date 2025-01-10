if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function vernamCipher(text, key)
    if #text ~= #key then
        return nil, "Key must be the same length as the input text"
    end

    local result = {}
    for i = 1, #text do
        local textChar = text:byte(i)
        local keyChar = key:byte(i)
        table.insert(result, string.char(bit32.bxor(textChar, keyChar)))
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Vernam Cipher", uiElements)

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
        log("Input and key are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    if #inputText ~= #keyText then
        log("Key length does not match input length. No encoding performed.")
        resultLabel.Text = "Key must match input length"
        return
    end

    lastInputText = inputText
    lastKeyText = keyText

    local encodedText, err = vernamCipher(inputText, keyText)
    if not encodedText then
        log(err)
        resultLabel.Text = err
        return
    end

    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

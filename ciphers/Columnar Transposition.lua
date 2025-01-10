if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function columnarTranspositionCipher(input, key)
    if not key or #key == 0 then
        return "Key cannot be empty."
    end

    local columns = {}
    for i = 1, #key do
        columns[i] = {}
    end

    local keyOrder = {}
    for i = 1, #key do
        table.insert(keyOrder, { char = key:sub(i, i), index = i })
    end
    table.sort(keyOrder, function(a, b) return a.char < b.char end)

    for i = 1, #input do
        local column = (i - 1) % #key + 1
        table.insert(columns[column], input:sub(i, i))
    end

    local result = {}
    for _, column in ipairs(keyOrder) do
        for _, char in ipairs(columns[column.index]) do
            table.insert(result, char)
        end
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Columnar Transposition Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter key", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText, lastKeyText = "", ""

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
        resultLabel.Text = "Key is blank"
        return
    end

    if inputText == key then
        log("Input and key are identical. No encoding performed.")
        resultLabel.Text = "Input and key cannot be identical"
        return
    end

    if inputText == lastInputText and key == lastKeyText then
        log("Input and key are identical to the last processed values.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKeyText = key
    local encodedText = columnarTranspositionCipher(inputText, key)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local square = {
    { "A", "B", "C", "D", "E", "F" },
    { "G", "H", "I", "J", "K", "L" },
    { "M", "N", "O", "P", "Q", "R" },
    { "S", "T", "U", "V", "W", "X" },
    { "Y", "Z", "1", "2", "3", "4" },
    { "5", "6", "7", "8", "9", "0" }
}

local function createADFGVXMap()
    local map = {}
    for row = 1, 6 do
        for col = 1, 6 do
            map[square[row][col]] = string.char(64 + row) .. string.char(64 + col)
        end
    end
    return map
end

local function adfgvxCipher(text)
    local map = createADFGVXMap()
    local result = {}

    text = text:upper():gsub("[^A-Z0-9]", "")

    for char in text:gmatch(".") do
        table.insert(result, map[char] or char)
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("ADFGVX Cipher", uiElements)

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
    local encodedText = adfgvxCipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

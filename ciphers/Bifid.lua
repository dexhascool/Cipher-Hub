-- broken rn
if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local bifidSquare = {
    "ABCDEFGHIKLMNOPQRSTUVWXYZ"
}

local function getPosition(char)
    for row = 1, 5 do
        local col = bifidSquare[1]:find(char, (row - 1) * 5 + 1)
        if col then
            return row, col
        end
    end
    return nil
end

local function bifidCipher(text)
    local result = {}
    local coordinates = {}

    text = text:upper():gsub("J", "I"):gsub("[^A-Z]", "")

    for i = 1, #text do
        local row, col = getPosition(text:sub(i, i))
        if row and col then
            table.insert(coordinates, row)
            table.insert(coordinates, col)
        end
    end

    local rowCoords = {}
    local colCoords = {}
    for i = 1, #coordinates, 2 do
        table.insert(rowCoords, coordinates[i])
        table.insert(colCoords, coordinates[i+1])
    end

    for i = 1, #rowCoords do
        local row = rowCoords[i]
        local col = colCoords[i]
        local encodedChar = bifidSquare[1]:sub((row - 1) * 5 + col, (row - 1) * 5 + col)
        table.insert(result, encodedChar)
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Bifid Cipher", uiElements)

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
    local encodedText = bifidCipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

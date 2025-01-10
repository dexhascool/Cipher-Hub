-- broken rn
if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local trifidSquare = {
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
    "abcdefghijklmnopqrstuvwxyz!#$%&'()*+,-./:;<=>?@[\\]^_`{|}~",
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

local function getPosition(char)
    for row = 1, #trifidSquare do
        local col = trifidSquare[row]:find(char)
        if col then
            return row, col
        end
    end
    return nil
end

local function trifidCipher(text)
    local result = {}
    local encodedText = {}

    text = text:upper():gsub("[^A-Z0-9!#$%&'()*+,-./:;<=>?@[\\]^_`{|}~]", "")

    for i = 1, #text, 3 do
        local group = {text:sub(i, i), text:sub(i+1, i+1), text:sub(i+2, i+2)}
        table.insert(encodedText, group)
    end

    for _, group in ipairs(encodedText) do
        local rows = {}
        local cols = {}

        for i = 1, 3 do
            local row, col = getPosition(group[i])
            if row and col then
                table.insert(rows, row)
                table.insert(cols, col)
            end
        end

        for i = 1, 3 do
            local row = rows[i]
            local col = cols[i]
            if row and col then
                table.insert(result, trifidSquare[row]:sub(col, col))
            end
        end
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Trifid Cipher", uiElements)

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
    local encodedText = trifidCipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

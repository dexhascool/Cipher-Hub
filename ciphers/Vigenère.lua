if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function vigenereCipher(text, keyword)
    local result = {}
    local keywordIndex = 1
    local keywordLength = #keyword

    for char in text:gmatch(".") do
        local shift = 0
        local base = nil

        if char:match("%a") then
            local keyChar = keyword:sub(keywordIndex, keywordIndex):lower()
            shift = string.byte(keyChar) - string.byte("a")
            base = char:lower() == char and string.byte("a") or string.byte("A")

            table.insert(result, string.char(((string.byte(char) - base + shift) % 26) + base))
            keywordIndex = (keywordIndex % keywordLength) + 1
        else
            table.insert(result, char)
        end
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Vigenère Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keywordBox = baseUi.addInputBox(frame, "Enter keyword", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastKeyword = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local keyword = keywordBox.Text

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if keyword == "" then
        log("Keyword is blank. Cannot perform encoding.")
        resultLabel.Text = "Keyword is blank"
        return
    end

    if inputText == lastInputText and keyword == lastKeyword then
        log("Input and keyword are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and keyword are the same as last time"
        return
    end

    lastInputText = inputText
    lastKeyword = keyword

    local encodedText = vigenereCipher(inputText, keyword)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

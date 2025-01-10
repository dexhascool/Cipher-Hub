if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function createKeywordAlphabet(keyword)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local keywordLetters = {}
    local used = {}

    for i = 1, #keyword do
        local char = keyword:sub(i, i):upper()
        if not used[char] then
            table.insert(keywordLetters, char)
            used[char] = true
        end
    end

    for i = 1, #alphabet do
        local char = alphabet:sub(i, i)
        if not used[char] then
            table.insert(keywordLetters, char)
        end
    end
    
    return table.concat(keywordLetters)
end

local function schlusselwortCipher(text, keyword)
    local keywordAlphabet = createKeywordAlphabet(keyword)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local result = {}
    
    for char in text:upper():gmatch(".") do
        local index = alphabet:find(char)
        if index then
            table.insert(result, keywordAlphabet:sub(index, index))
        else
            table.insert(result, char)
        end
    end
    
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Schlüsselwort Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter keyword", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastKeyText = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local keyText = keyBox.Text

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if keyText == "" then
        log("Keyword is blank. No encoding performed.")
        resultLabel.Text = "Keyword is blank"
        return
    end

    if inputText == lastInputText and keyText == lastKeyText then
        log("Input and key are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKeyText = keyText

    local encodedText = schlusselwortCipher(inputText, keyText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

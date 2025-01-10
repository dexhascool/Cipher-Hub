if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function generateSubstitutionAlphabet()
    local alphabet = {}
    for i = 0, 25 do
        alphabet[#alphabet + 1] = string.char(65 + i) -- 'A' to 'Z'
    end

    for i = #alphabet, 2, -1 do
        local j = math.random(1, i)
        alphabet[i], alphabet[j] = alphabet[j], alphabet[i]
    end

    return alphabet
end

local function createMapping(alphabet)
    local mapping = {}
    for i = 1, #alphabet do
        local originalChar = string.char(65 + i - 1) -- 'A' to 'Z'
        mapping[originalChar] = alphabet[i]
    end
    return mapping
end

local substitutionAlphabet = generateSubstitutionAlphabet()
local mapping = createMapping(substitutionAlphabet)

local function dionysianCipher(text)
    local result = {}
    for char in text:gmatch(".") do
        local upperChar = char:upper()
        if mapping[upperChar] then
            table.insert(result, char:match("%l") and mapping[upperChar]:lower() or mapping[upperChar])
        else
            table.insert(result, char)
        end
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Dionysian Cipher", uiElements)

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
    local encodedText = dionysianCipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

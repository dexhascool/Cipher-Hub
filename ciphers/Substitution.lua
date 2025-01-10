if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function substitutionCipher(text, substitutionAlphabet)
    local result = {}
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    text = text:upper()
    substitutionAlphabet = substitutionAlphabet:upper()

    if #substitutionAlphabet ~= 26 then
        return "Error: Substitution alphabet must be 26 letters."
    end

    local substitutionMap = {}
    for i = 1, 26 do
        local originalChar = alphabet:sub(i, i)
        local substitutionChar = substitutionAlphabet:sub(i, i)
        substitutionMap[originalChar] = substitutionChar
    end

    for i = 1, #text do
        local char = text:sub(i, i)
        if char:match("%A") then
            table.insert(result, char)
        else
            table.insert(result, substitutionMap[char])
        end
    end

    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Substitution Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local substitutionBox = baseUi.addInputBox(frame, "Enter 26-letter substitution alphabet", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastSubstitutionAlphabet = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local substitutionAlphabet = substitutionBox.Text

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if #substitutionAlphabet ~= 26 or substitutionAlphabet:match("[^A-Za-z]") then
        log("Invalid substitution alphabet provided.")
        resultLabel.Text = "Error: Substitution alphabet must have 26 letters."
        return
    end

    if inputText == lastInputText and substitutionAlphabet == lastSubstitutionAlphabet then
        log("Input and substitution alphabet are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and substitution alphabet are the same as last time"
        return
    end

    lastInputText = inputText
    lastSubstitutionAlphabet = substitutionAlphabet

    local encodedText = substitutionCipher(inputText, substitutionAlphabet)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

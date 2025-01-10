if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local baconCipherMap = {
    A = "AAAAA", B = "AAAAB", C = "AAABA", D = "AAABB", E = "AABAA", F = "AABAB", G = "AABBA", H = "AABBB",
    I = "ABAAA", J = "ABAAA", K = "ABAAB", L = "ABABA", M = "ABABB", N = "ABBAA", O = "ABBAB", P = "ABBBA",
    Q = "ABBBB", R = "BAAAA", S = "AAAAA", T = "AAABA", U = "AAAAB", V = "AAABB", W = "AABAB", X = "AABBA",
    Y = "AABBB", Z = "ABAAA"
}

local function baconCipher(text)
    text = text:upper()

    local result = {}
    for char in text:gmatch(".") do
        if baconCipherMap[char] then
            table.insert(result, baconCipherMap[char])
        else
            table.insert(result, char)
        end
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Bacon's Cipher", uiElements)

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
    local encodedText = baconCipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

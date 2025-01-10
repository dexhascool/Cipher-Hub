if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function polybiusCipher(text, square)
    local result = {}

    local defaultSquare = {
        ["A"] = "11", ["B"] = "12", ["C"] = "13", ["D"] = "14", ["E"] = "15",
        ["F"] = "21", ["G"] = "22", ["H"] = "23", ["I"] = "24", ["J"] = "24", ["K"] = "25",
        ["L"] = "31", ["M"] = "32", ["N"] = "33", ["O"] = "34", ["P"] = "35",
        ["Q"] = "41", ["R"] = "42", ["S"] = "43", ["T"] = "44", ["U"] = "45",
        ["V"] = "51", ["W"] = "52", ["X"] = "53", ["Y"] = "54", ["Z"] = "55"
    }

    square = square or defaultSquare

    for char in text:upper():gmatch(".") do
        if char:match("%a") then
            table.insert(result, square[char] or "?")
        else
            table.insert(result, char)
        end
    end

    return table.concat(result, " ")
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Polybius Cipher", uiElements)

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
    local encodedText = polybiusCipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

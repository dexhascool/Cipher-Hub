if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function nullCipher(text, interval)
    local result = {}
    for i = 1, #text, interval do
        table.insert(result, text:sub(i, i))
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Null Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local intervalBox = baseUi.addInputBox(frame, "Enter interval (e.g., 2)", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastInterval = 0

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local interval = tonumber(intervalBox.Text)

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if not interval or interval <= 0 then
        log("Invalid interval. Must be a positive number.")
        resultLabel.Text = "Invalid interval. Enter a positive number."
        return
    end

    if inputText == lastInputText and interval == lastInterval then
        log("Input and interval are identical to the last processed values. No encoding performed.")
        resultLabel.Text = "Input and interval are the same as last time"
        return
    end

    lastInputText = inputText
    lastInterval = interval
    local encodedText = nullCipher(inputText, interval)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded with interval " .. interval .. ": " .. encodedText)
    chatMessage(encodedText)
end)

if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local base32Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567"

local function base32Encode(input)
    local output = {}
    local buffer, bitsLeft = 0, 0
    local inputLength = #input

    for i = 1, inputLength do
        buffer = bit32.bor(bit32.lshift(buffer, 8), input:byte(i))
        bitsLeft = bitsLeft + 8

        while bitsLeft >= 5 do
            local index = bit32.band(bit32.rshift(buffer, bitsLeft - 5), 31) + 1
            table.insert(output, base32Chars:sub(index, index))
            bitsLeft = bitsLeft - 5
        end
    end

    if bitsLeft > 0 then
        local index = bit32.band(bit32.lshift(buffer, 5 - bitsLeft), 31) + 1
        table.insert(output, base32Chars:sub(index, index))
    end

    while #output % 8 ~= 0 do
        table.insert(output, "=")
    end

    return table.concat(output)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Base32 Cipher", uiElements)

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
    local encodedText = base32Encode(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

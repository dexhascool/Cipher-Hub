if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local leftRotor = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
local rightRotor = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

local function rotateRotor(rotor, index)
    return rotor:sub(index + 1) .. rotor:sub(1, index)
end

local function shiftRotors(leftIndex)
    leftRotor = rotateRotor(leftRotor, leftIndex - 1)
    rightRotor = rotateRotor(rightRotor, leftIndex - 1)
    
    leftRotor = leftRotor:sub(2, 2) .. leftRotor:sub(1, 1) .. leftRotor:sub(3)
    
    rightRotor = rightRotor:sub(1, 1) .. rightRotor:sub(-1, -1) .. rightRotor:sub(2, -2)
end

local function chaocipher(text)
    local result = {}
    for char in text:upper():gmatch(".") do
        if char:match("%a") then
            local leftIndex = leftRotor:find(char)
            if not leftIndex then
                table.insert(result, char)
                continue
            end

            local encodedChar = rightRotor:sub(leftIndex, leftIndex)
            table.insert(result, encodedChar)

            shiftRotors(leftIndex)
        else
            table.insert(result, char)
        end
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 3
local frame = baseUi.createUi("Chaocipher", uiElements)

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
    local encodedText = chaocipher(inputText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

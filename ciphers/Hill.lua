if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function letterToNum(letter)
    return string.byte(letter:upper()) - 65
end

local function numToLetter(num)
    return string.char(num + 65)
end

local function matrixMultiply(a, b)
    local result = {}
    for i = 1, #a do
        result[i] = {}
        for j = 1, #b[1] do
            result[i][j] = 0
            for k = 1, #b do
                result[i][j] = result[i][j] + a[i][k] * b[k][j]
            end
            result[i][j] = result[i][j] % 26
        end
    end
    return result
end

local function hillCipher(text, keyMatrix)
    local textNumbers = {}
    for i = 1, #text do
        table.insert(textNumbers, letterToNum(text:sub(i, i)))
    end

    while #textNumbers % #keyMatrix[1] ~= 0 do
        table.insert(textNumbers, 0)
    end

    local cipherText = {}
    for i = 1, #textNumbers, #keyMatrix[1] do
        local textVector = {}
        for j = 1, #keyMatrix[1] do
            table.insert(textVector, textNumbers[i + j - 1])
        end

        local encryptedVector = matrixMultiply(keyMatrix, {textVector})
        
        for j = 1, #encryptedVector[1] do
            table.insert(cipherText, numToLetter(encryptedVector[1][j]))
        end
    end
    return table.concat(cipherText)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()

local uiElements = 4
local frame = baseUi.createUi("Hill Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter key (4 numbers)", UDim2.new(0, 10, 0, 100))
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

    local keyMatrix = {}
    local keyNums = {}
    for num in keyText:gmatch("%d+") do
        table.insert(keyNums, tonumber(num))
    end

    if #keyNums ~= 4 then
        log("Invalid key. Enter exactly 4 numbers for a 2x2 matrix.")
        resultLabel.Text = "Invalid key"
        return
    end

    keyMatrix = {
        {keyNums[1], keyNums[2]},
        {keyNums[3], keyNums[4]}
    }

    if inputText == lastInputText and keyText == lastKeyText then
        log("Input and key are identical to the last processed. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKeyText = keyText
    local encodedText = hillCipher(inputText, keyMatrix)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

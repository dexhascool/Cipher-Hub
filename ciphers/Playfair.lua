if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function prepareText(text)
    text = text:gsub("[^%w]", ""):upper()
    text = text:gsub("J", "I")
    local result = {}
    local i = 1
    while i <= #text do
        local a = text:sub(i, i)
        local b = text:sub(i + 1, i + 1)
        if a == b or b == "" then
            table.insert(result, a .. "X")
            i = i + 1
        else
            table.insert(result, a .. b)
            i = i + 2
        end
    end
    return result
end

local function createPlayfairSquare(key)
    key = key:gsub("[^%w]", ""):upper():gsub("J", "I")
    local used = {}
    local square = {}
    for char in key:gmatch(".") do
        if not used[char] then
            table.insert(square, char)
            used[char] = true
        end
    end
    for i = 65, 90 do
        local char = string.char(i)
        if char ~= "J" and not used[char] then
            table.insert(square, char)
        end
    end
    return square
end

local function playfairCipher(text, key)
    local square = createPlayfairSquare(key)
    local preparedText = prepareText(text)
    local result = {}
    local function findPosition(char)
        for i, v in ipairs(square) do
            if v == char then
                return math.floor((i - 1) / 5), (i - 1) % 5
            end
        end
    end

    for _, pair in ipairs(preparedText) do
        local a, b = pair:sub(1, 1), pair:sub(2, 2)
        local ax, ay = findPosition(a)
        local bx, by = findPosition(b)
        if ax == bx then
            table.insert(result, square[ax * 5 + ((ay + 1) % 5) + 1] .. square[bx * 5 + ((by + 1) % 5) + 1])
        elseif ay == by then
            table.insert(result, square[((ax + 1) % 5) * 5 + ay + 1] .. square[((bx + 1) % 5) * 5 + by + 1])
        else
            table.insert(result, square[ax * 5 + by + 1] .. square[bx * 5 + ay + 1])
        end
    end
    return table.concat(result)
end

local baseUi = loadstring(game:HttpGet("https://pastebin.com/raw/XuC5DavN"))()

local uiElements = 4
local frame = baseUi.createUi("Playfair Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter key", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastKey = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local keyText = keyBox.Text

    if inputText == "" then
        log("Input is blank. No encoding performed.")
        resultLabel.Text = "Input is blank"
        return
    end

    if keyText == "" then
        log("Key is blank. Cannot perform encoding.")
        resultLabel.Text = "Key is blank"
        return
    end

    if inputText == lastInputText and keyText == lastKey then
        log("Input and key are identical to the last processed text. No encoding performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKey = keyText

    local encodedText = playfairCipher(inputText, keyText)
    resultLabel.Text = "<b>Encoded:</b> " .. encodedText

    log("Encoded: " .. encodedText)
    chatMessage(encodedText)
end)

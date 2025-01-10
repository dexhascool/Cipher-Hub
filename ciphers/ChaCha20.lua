-- broken rn
if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local function toUint32(value)
    return bit32.band(value, 0xFFFFFFFF)
end

local function rotateLeft(value, shift)
    return toUint32(bit32.lshift(value, shift) + bit32.rshift(value, 32 - shift))
end

local function quarterRound(state, a, b, c, d)
    state[a] = toUint32(state[a] + state[b])
    state[d] = rotateLeft(bit32.bxor(state[d], state[a]), 16)
    state[c] = toUint32(state[c] + state[d])
    state[b] = rotateLeft(bit32.bxor(state[b], state[c]), 12)
    state[a] = toUint32(state[a] + state[b])
    state[d] = rotateLeft(bit32.bxor(state[d], state[a]), 8)
    state[c] = toUint32(state[c] + state[d])
    state[b] = rotateLeft(bit32.bxor(state[b], state[c]), 7)
end

local function chachaBlock(key, counter, nonce)
    local constants = {0x61707865, 0x3320646E, 0x79622D32, 0x6B206574}
    local state = {
        constants[1], constants[2], constants[3], constants[4],
        key[1], key[2], key[3], key[4], key[5], key[6], key[7], key[8],
        key[9], key[10], key[11], key[12],
        counter, nonce[1], nonce[2], nonce[3]
    }

    local workingState = {table.unpack(state)}
    for _ = 1, 10 do
        quarterRound(workingState, 1, 5, 9, 13)
        quarterRound(workingState, 2, 6, 10, 14)
        quarterRound(workingState, 3, 7, 11, 15)
        quarterRound(workingState, 4, 8, 12, 16)
        quarterRound(workingState, 1, 6, 11, 16)
        quarterRound(workingState, 2, 7, 12, 13)
        quarterRound(workingState, 3, 8, 9, 14)
        quarterRound(workingState, 4, 5, 10, 15)
    end

    for i = 1, 16 do
        workingState[i] = toUint32(workingState[i] + state[i])
    end

    return workingState
end

local function chacha20Cipher(text, key, nonce)
    assert(#key == 32, "Key must be 32 bytes")
    assert(#nonce == 12, "Nonce must be 12 bytes")

    local keyWords = {}
    for i = 1, 32, 4 do
        table.insert(keyWords, toUint32(string.unpack("<I4", key, i)))
    end

    local nonceWords = {}
    for i = 1, 12, 4 do
        table.insert(nonceWords, toUint32(string.unpack("<I4", nonce, i)))
    end

    local counter = 0
    local ciphertext = {}
    for i = 1, #text, 64 do
        local block = chachaBlock(keyWords, counter, nonceWords)
        counter = toUint32(counter + 1)

        for j = 1, 64 do
            if i + j - 1 <= #text then
                local byte = string.byte(text, i + j - 1)
                local keystreamByte = bit32.band(bit32.rshift(block[1 + ((j - 1) // 4)], ((j - 1) % 4) * 8), 0xFF)
                table.insert(ciphertext, string.char(bit32.bxor(byte, keystreamByte)))
            end
        end
    end

    return table.concat(ciphertext)
end

local baseUi = loadstring(game:HttpGet("https://pastebin.com/raw/XuC5DavN"))()
local uiElements = 5
local frame = baseUi.createUi("ChaCha20 Cipher", uiElements)

local inputBox = baseUi.addInputBox(frame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(frame, "Enter 32-byte key", UDim2.new(0, 10, 0, 100))
local nonceBox = baseUi.addInputBox(frame, "Enter 12-byte nonce", UDim2.new(0, 10, 0, 150))
local encodeButton = baseUi.addEncodeButton(frame, UDim2.new(0, 20, 0, 200))
local resultLabel = baseUi.addResultLabel(frame, UDim2.new(0, 10, 0, 250))

local lastInputText = ""
local lastKey = ""
local lastNonce = ""

encodeButton.MouseButton1Click:Connect(function()
    local inputText = inputBox.Text
    local key = keyBox.Text
    local nonce = nonceBox.Text

    if inputText == "" or #key ~= 32 or #nonce ~= 12 then
        log("Invalid input: Ensure text, 32-byte key, and 12-byte nonce are provided.")
        resultLabel.Text = "Invalid input: Ensure text, 32-byte key, and 12-byte nonce are provided."
        return
    end

    if inputText == lastInputText and key == lastKey and nonce == lastNonce then
        log("Input, key, and nonce are identical to the last processed values. No encryption performed.")
        resultLabel.Text = "Input, key, and nonce are the same as last time"
        return
    end

    lastInputText = inputText
    lastKey = key
    lastNonce = nonce

    local encryptedText = chacha20Cipher(inputText, key, nonce)
    resultLabel.Text = "<b>Encrypted:</b> " .. encryptedText

    log("Encrypted: " .. encryptedText)
    chatMessage(encryptedText)
end)

if not _G.CipherUtils then
    warn("CipherUtils not found! Load the loader script first.")
    return
end

local CipherUtils = _G.CipherUtils
local log = CipherUtils.log
local chatMessage = CipherUtils.chatMessage

local MAGMA_SBOX = {
    {12,4,6,2,10,5,11,9,14,8,13,7,0,3,15,1},
    {6,8,2,3,9,10,5,12,1,14,4,7,11,13,0,15},
    {11,3,5,8,2,15,10,13,14,1,7,4,12,9,6,0},
    {12,8,2,1,13,4,10,7,0,6,9,15,14,3,5,11},
    {7,15,5,10,8,1,6,13,0,9,3,14,11,4,2,12},
    {5,13,15,6,9,2,12,10,11,7,8,1,4,3,0,14},
    {8,14,2,5,6,9,1,12,15,4,11,0,13,10,3,7},
    {1,7,14,13,0,5,8,3,4,10,15,6,9,12,11,2}
}

local function rotateLeft(x, n)
    return bit32.lrotate(x, n)
end

local function toBytes32(n)
    local bytes = {}
    for i = 1, 4 do
        local shift = 8 * (4 - i)
        bytes[i] = string.char(bit32.band(bit32.rshift(n, shift), 0xFF))
    end
    return table.concat(bytes)
end

local function pad(plaintext)
    local padLen = 8 - (#plaintext % 8)
    if padLen == 0 then padLen = 8 end
    return plaintext .. string.rep(string.char(padLen), padLen)
end

local function unpad(plaintext)
    local padLen = string.byte(plaintext, #plaintext)
    return string.sub(plaintext, 1, #plaintext - padLen)
end

local function toHex(str)
    return (str:gsub('.', function(c)
        return string.format('%02x', string.byte(c))
    end))
end

local function generateMagmaSubkeys(key)
    local keyBytes = {}
    for i = 1, #key do
        keyBytes[i] = string.byte(key, i)
    end
    local keyWords = {}
    local keyLen = #keyBytes
    for i = 1, 8 do
        local word = 0
        for j = 1, 4 do
            local index = ((i - 1) * 4 + j)
            if index > keyLen then
                index = ((index - 1) % keyLen) + 1
            end
            word = bit32.lshift(word, 8) + keyBytes[index]
        end
        keyWords[i] = word
    end
    local subkeys = {}
    for i = 1, 32 do
        if i <= 24 then
            subkeys[i] = keyWords[((i - 1) % 8) + 1]
        else
            subkeys[i] = keyWords[8 - (((i - 25) % 8))]
        end
    end
    return subkeys
end

local function magmaSubstitution(x)
    local output = 0
    for i = 1, 8 do
        local shift = 32 - 4 * i
        local nibble = bit32.band(bit32.rshift(x, shift), 0xF)
        local subNibble = MAGMA_SBOX[i][nibble + 1]
        output = output + bit32.lshift(subNibble, shift)
    end
    return output
end

local Magma = {}
Magma.__index = Magma

function Magma.new(key)
    local self = setmetatable({}, Magma)
    self.subkeys = generateMagmaSubkeys(key)
    return self
end

local function magmaEncryptBlock(block, subkeys)
    local L, R = 0, 0
    for i = 1, 4 do
        L = bit32.lshift(L, 8) + string.byte(block, i)
    end
    for i = 5, 8 do
        R = bit32.lshift(R, 8) + string.byte(block, i)
    end

    for i = 1, 32 do
        local temp = (L + subkeys[i]) % 0x100000000  -- mod 2^32
        temp = magmaSubstitution(temp)
        temp = rotateLeft(temp, 11)
        local newL = bit32.bxor(R, temp)
        R = L
        L = newL
    end
    return L, R
end

local function magmaDecryptBlock(block, subkeys)
    local L, R = 0, 0
    for i = 1, 4 do
        L = bit32.lshift(L, 8) + string.byte(block, i)
    end
    for i = 5, 8 do
        R = bit32.lshift(R, 8) + string.byte(block, i)
    end

    for i = 32, 1, -1 do
        local temp = (L + subkeys[i]) % 0x100000000
        temp = magmaSubstitution(temp)
        temp = rotateLeft(temp, 11)
        local newL = bit32.bxor(R, temp)
        R = L
        L = newL
    end
    return L, R
end

function Magma:EncryptString(plaintext)
    plaintext = pad(plaintext)
    local ciphertext = {}
    for i = 1, #plaintext, 8 do
        local block = string.sub(plaintext, i, i + 7)
        local L, R = magmaEncryptBlock(block, self.subkeys)
        table.insert(ciphertext, toBytes32(L) .. toBytes32(R))
    end
    return table.concat(ciphertext)
end

function Magma:DecryptString(ciphertext)
    local plaintext = {}
    for i = 1, #ciphertext, 8 do
        local block = string.sub(ciphertext, i, i + 7)
        local L, R = magmaDecryptBlock(block, self.subkeys)
        table.insert(plaintext, toBytes32(L) .. toBytes32(R))
    end
    plaintext = table.concat(plaintext)
    return unpad(plaintext)
end

local baseUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/extras/UILib.lua"))()
local uiElements = 4
local uiFrame = baseUi.createUi("Magma Cipher", uiElements)

local inputBox = baseUi.addInputBox(uiFrame, "Enter text", UDim2.new(0, 10, 0, 50))
local keyBox = baseUi.addInputBox(uiFrame, "Enter 32-byte key", UDim2.new(0, 10, 0, 100))
local encodeButton = baseUi.addEncodeButton(uiFrame, UDim2.new(0, 20, 0, 150))
local resultLabel = baseUi.addResultLabel(uiFrame, UDim2.new(0, 10, 0, 200))

local lastInputText = ""
local lastKey = ""

encodeButton.MouseButton1Click:Connect(function()
    local key = keyBox.Text
    local inputText = inputBox.Text

    if key == "" then
        log("Key is blank. No encryption performed.")
        resultLabel.Text = "Key is blank"
        return
    end
    if #key < 32 then
        log("Key is too short. Must be at least 32 bytes.")
        resultLabel.Text = "Key is too short"
        return
    end
    if inputText == "" then
        log("Input is blank. No encryption performed.")
        resultLabel.Text = "Input is blank"
        return
    end
    if inputText == lastInputText and key == lastKey then
        log("Input and key are identical to last processed values. No encryption performed.")
        resultLabel.Text = "Input and key are the same as last time"
        return
    end

    lastInputText = inputText
    lastKey = key

    local magmaCipher = Magma.new(key)
    local ciphertext = magmaCipher:EncryptString(inputText)
    local hexText = toHex(ciphertext)
    resultLabel.Text = "<b>Encoded:</b> " .. hexText
    log("Encoded: " .. hexText)
    chatMessage(hexText)
end)

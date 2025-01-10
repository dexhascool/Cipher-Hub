_G.ciphers = {
    Atbash = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Atbash.lua", description = "Reverses the alphabet" },
    Caesar = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Caesar.lua", description = "Shifts letters by a user-defined number" },
    ROT13 = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/ROT13.lua", description = "Shifts letters by 13 positions" },
    Vigenere = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Vigenère.lua", description = "Uses a repeating keyword for encryption" },
    Beaufort = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Beaufort.lua", description = "Reversed Vigenère cipher" },
    XOR = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/XOR.lua", description = "Encrypts text using XOR with a key" },
    Autokey = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Autokey.lua", description = "Extends the key with the plaintext" },
    Substitution = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Substitution.lua", description = "Substitutes each letter with a mapped one" },
    Enigma = { url = "", description = "Simulates the famous WW2 Enigma machine (broken)" },
    Base64 = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Base64.lua", description = "Encodes text into Base64 format" },
    Base32 = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Base32.lua", description = "Encodes text into Base32 format" },
    ROT47 = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/ROT47.lua", description = "Shifts printable ASCII characters by 47 positions" },
    Columnar = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Columnar%20Transposition.lua", description = "Rearranges text into columns based on a key" },
    Affine = { url = "", description = "Applies modular arithmetic with a key pair (broken)" },
    Polybius = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Polybius%20Square.lua", description = "Encodes text using a 5x5 grid" },
    Playfair = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Playfair.lua", description = "Encrypts text using letter pairs" },
    Morse = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Morse%20Code.lua", description = "Encodes text into Morse code" },
    Null = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Null.lua", description = "Extracts every Nth character from the text" },
    Bacons = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Bacon's.lua", description = "Encodes text using Bacon's Cipher" },
    Gronsfeld = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Gronsfeld.lua", description = "Encrypts text using a numeric key for substitution" },
    Hill = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Hill.lua", description = "Uses matrix multiplication with a key matrix" },
    Schlusselwort = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Schl%C3%BCsselwort.lua", description = "Uses a keyword to substitute letters" },
    ChaCha20 = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/ChaCha20.lua", description = "Encrypts text using the ChaCha20 stream cipher" },
    Dionysian = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Dionysian.lua", description = "Randomized letter substitution cipher" },
    Chaocipher = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Chaocipher.lua", description = "Uses shifting rotors for encryption" },
    ADFGVX = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/ADFGVX.lua", description = "Encodes text using a 6x6 square and the letters ADFGVX" },
    Trifid = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Trifid.lua", description = "Encodes text by using a 3D grid" },
    Bifid = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Bifid.lua", description = "Uses a combination of substitution and transposition" },
    Trithemius = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Trithemius.lua", description = "Shifts each letter by a progressively increasing amount"},
    Gilbert = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Gilbert.lua", description = "Uses a key to shift letters in the plaintext"},
    Vernam = { url = "https://raw.githubusercontent.com/thelonious-jaha/Cipher-Hub/refs/heads/main/ciphers/Vernam.lua", description = "Encrypts text using a key of the same length with XOR"}
}

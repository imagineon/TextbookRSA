import TextbookRSA

// Helper methods:

func success(_ value: Bool) -> String {
    return value ? "successful" : "failed"
}

func assertPublic<T>(_ value: T) {
    // NOP
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Keys:
// Generate, access public members, print, encode as json and decode from json.

let keys = UIntRSA.Keys()
assertPublic(keys.primes.p.value)
assertPublic(keys.primes.q.value)
assertPublic(keys.public.value)

print("Keys: \(keys)")

let encodedKeys = try JSONEncoder().encode(keys)
let encodedKeysString = String(data: encodedKeys, encoding: .utf8)

print("Keys as json: \(encodedKeysString ?? "nil")")

let decodedKeys = try JSONDecoder().decode(UIntRSA.Keys.self, from: encodedKeys)

print("Encoding + decoding keys: \(success(decodedKeys == keys))")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// Encryption parameters:
// Generate from keys, access public members, print, encode as json and decode from json.

let encryptionParms = keys.generateEncryptionParameters()
assertPublic(encryptionParms.modulo)
assertPublic(encryptionParms.exponent)

print("Encryption parameters: \(encryptionParms)")

let encodedEncryptionParms = try JSONEncoder().encode(encryptionParms)
let encodedEncryptionParmsString = String(data: encodedEncryptionParms, encoding: .utf8)

print("Encryption parameters as json: \(encodedEncryptionParmsString ?? "nil")")

let decodedEncryptionParms = try JSONDecoder().decode(UIntRSA.TransformationParameters.self, from: encodedEncryptionParms)

print("Encoding + decoding encryption parameters: \(success(decodedEncryptionParms == encryptionParms))")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// Encrypter:
// Encrypt data.
//
// ECBEncryptedData:
// Access public members, print, encode as json and decode from json.

let dataMessage = Data(bytes: (0 ..< 10).map { _ in UInt8(arc4random_uniform(UInt32(UInt8.max) + 1)) })

print("Data message (bytes): \(dataMessage.map { $0 })")

let encryptedDataMessage = Encrypter.encrypt(dataMessage, parameters: encryptionParms)
assertPublic(encryptedDataMessage.blocks)
assertPublic(encryptedDataMessage.encryptionExponent)

print("Data message, encrypted: \(encryptedDataMessage)")

let encodedEncryptedDataMessage = try JSONEncoder().encode(encryptedDataMessage)
let encodedEncryptedDataMessageString = String(data: encodedEncryptedDataMessage, encoding: .utf8)

print("Data message, encrypted, as json: \(encodedEncryptedDataMessageString ?? "nil")")

let decodedEncryptedDataMessage = try JSONDecoder().decode(Encrypter.EncryptedData.self, from: encodedEncryptedDataMessage)

print("Encoding + decoding encrypted data message: \(success(decodedEncryptedDataMessage == encryptedDataMessage))")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// Decrypter:
// Initialize with keys, access public members and decrypt to data.

let decrypter = Decrypter(keys: keys)
assertPublic(decrypter.keys)

let decryptedDataMessage = decrypter.decrypt(encryptedDataMessage)

print("Encrypting + decrypting data message: \(success(dataMessage == decryptedDataMessage))")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// Encrypter:
// Encrypt text.

let textMessage = "The quick brown 🦊 jumps over the lazy dog."

print("Text message: \"\(textMessage)\"")

let encryptedTextMessage = Encrypter.encrypt(textMessage, parameters: encryptionParms)

print("Text message, encrypted: \(encryptedTextMessage)")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// Decrypter:
// Decrypt to text.

let decryptedTextMessage = decrypter.decryptText(encryptedTextMessage)

print("Encrypting + decrypting text message: \(success(textMessage == decryptedTextMessage))")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// Keys:
// Generate small.

let smallKeys = UIntRSA.Keys.small(maxPrime: 100)

print("Small keys: \(smallKeys)")

print()

///////////////////////////////////////////////////////////////////////////////////////////////////
// PeriodDecrypter:
// Initialize with public key, decrypt to data and decrypt to text.

let smallEncryptionParameters = smallKeys.generateEncryptionParameters()

print("Small encryption parameters: \(smallEncryptionParameters)")

let smallEncryptedDataMessage = Encrypter.encrypt(dataMessage, parameters: smallEncryptionParameters)

print("Data message, encrypted with small parameters: \(smallEncryptedDataMessage)")

let periodDecrypter = PeriodDecrypter(publicKey: smallKeys.public)

let smallPeriodDecryptedDataMessage = periodDecrypter.decrypt(smallEncryptedDataMessage)

print("Decrypting data message with PeriodDecrypter: \(success(dataMessage == smallPeriodDecryptedDataMessage))")

let smallEncryptedTextMessage = Encrypter.encrypt(textMessage, parameters: smallEncryptionParameters)

print("Text message, encrypted with small parameters: \(smallEncryptedTextMessage)")

let smallPeriodDecryptedTextMessage = periodDecrypter.decryptText(smallEncryptedTextMessage)

print("Decrypting text message with PeriodDecrypter: \(success(textMessage == smallPeriodDecryptedTextMessage))")

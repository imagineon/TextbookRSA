import TextbookRSA

let keys = RSA.Keys()

print(keys.private.p.value)
print(keys.private.q.value)
print(keys.public.value)

let encodedKeys = try JSONEncoder().encode(keys)
let encodedKeysString = String(data: encodedKeys, encoding: .utf8)
print(String(describing: encodedKeysString))
let decodedKeys = try JSONDecoder().decode(RSA.Keys.self, from: encodedKeys)
print(decodedKeys.private.p.value == keys.private.p.value && decodedKeys.private.p.value == keys.private.p.value)

let decrypter = Decrypter(keys: keys)

print(decrypter.keys)

let encryptionParms = keys.generateEncryptionParameters()

print(encryptionParms.modulo)
print(encryptionParms.exponent)

let encodedEncryptionParms = try JSONEncoder().encode(encryptionParms)
let encodedEncryptionParmsString = String(data: encodedEncryptionParms, encoding: .utf8)
print(String(describing: encodedEncryptionParmsString))
let decodedEncryptinParms = try JSONDecoder().decode(RSA.TransformationParameters.self, from: encodedEncryptionParms)
print(decodedEncryptinParms.modulo.value == encryptionParms.modulo.value && decodedEncryptinParms.exponent == encryptionParms.exponent)

let dataMessage = Data(bytes: (0 ..< 10).map { _ in UInt8(arc4random_uniform(UInt32(UInt8.max) + 1)) })
let encryptedDataMessage = Encrypter.encrypt(dataMessage, parameters: encryptionParms)

print(encryptedDataMessage.blocks)
print(encryptedDataMessage.usedEncryptionExponent)

let encodedEncryptedDataMessage = try JSONEncoder().encode(encryptedDataMessage)
let encodedEncryptedDataMessageString = String(data: encodedEncryptedDataMessage, encoding: .utf8)
print(String(describing: encodedEncryptedDataMessageString))
let decodedEncryptedDataMessage = try JSONDecoder().decode(Encrypter.EncryptedData.self, from: encodedEncryptedDataMessage)
print(decodedEncryptedDataMessage.blocks == encryptedDataMessage.blocks && decodedEncryptedDataMessage.usedEncryptionExponent == encryptedDataMessage.usedEncryptionExponent)

let decryptedDataMessage = decrypter.decrypt(encryptedDataMessage)
print(dataMessage == decryptedDataMessage)

let textMessage = "The quick brown 🦊 jumps over the lazy dog"
let encryptedTextMessage = Encrypter.encrypt(textMessage, parameters: encryptionParms)

print(encryptedTextMessage.blocks)
print(encryptedTextMessage.usedEncryptionExponent)

let decryptedTextMessage = decrypter.decryptText(encryptedTextMessage)
print(textMessage == decryptedTextMessage)

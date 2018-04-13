//
//  EncrypterAndDecrypterTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class EncrypterAndDecrypterTests: XCTestCase {
    func testEncryptAndDecryptData() {
        for iteration in 0 ..< 100 {
            let decrypter = Decrypter(keys: RSA.Keys())
            let message = (iteration < 10) ? Data(bytes: []) :
                Data(bytes: (0 ..< 10).map { _ in UInt8(arc4random_uniform(UInt32(UInt8.max) + 1)) })
            let encryptedMessage = Encrypter.encrypt(message, parameters: decrypter.generateEncryptionParameters())
            let decryptedMessage = decrypter.decrypt(encryptedMessage)
            
            XCTAssertEqual(message, decryptedMessage, "decrypter: \(decrypter) -- message: \(message.map { $0 }) -- encryptedMessage: \(encryptedMessage) -- decryptedMessage: \(String(describing: decryptedMessage?.map { $0 }))")
        }
    }
    
    func testEncryptAndDecryptText() {
        for iteration in 0 ..< 100 {
            let decrypter = Decrypter(keys: RSA.Keys())
            let message: String = {
                switch iteration {
                case 0 ..< 10:
                    return ""
                case 10 ..< 20:
                    return "😎✌️🦊"
                default:
                    return "The quick brown fox jumps over the lazy dog"
                }
            }()
            
            let encryptedMessage = Encrypter.encrypt(message, parameters: decrypter.generateEncryptionParameters())
            let decryptedMessage = decrypter.decryptText(encryptedMessage)
            
            XCTAssertEqual(message, decryptedMessage, "decrypter: \(decrypter) -- message: \(message) -- encryptedMessage: \(encryptedMessage) -- decryptedMessage: \(String(describing: decryptedMessage))")
        }
    }
}

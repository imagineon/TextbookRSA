//
//  EncrypterProtocol+DecrypterProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public protocol EncrypterProtocol {
    associatedtype RSA: RSAProtocol
    associatedtype ECB: ECBProtocol where ECB.Block == RSA.UInteger
    
    static func encrypt(_ data: Data, parameters: RSA.TransformationParameters) -> (blocks: [ECB.Block], usedEncryptionExponent: RSA.UInteger)
}

extension EncrypterProtocol {
    static func encrypt(_ text: String, parameters: RSA.TransformationParameters) -> (blocks: [ECB.Block], usedEncryptionExponent: RSA.UInteger) {
        let data = text.data(using: .utf16)!
        return encrypt(data, parameters: parameters)
    }
}

public protocol DecrypterProtocol {
    associatedtype RSA: RSAProtocol
    associatedtype ECB: ECBProtocol where ECB.Block == RSA.UInteger
    
    var keys: RSA.Keys { get }
    func decrypt(_ blocks: [ECB.Block], encryptedWith exponent: RSA.UInteger) -> Data?
}

extension DecrypterProtocol {
    func generateEncryptionParameters() -> RSA.TransformationParameters {
        return keys.generateEncryptionParameters()
    }
    
    func decryptText(_ blocks: [ECB.Block], encryptedWith exponent: RSA.UInteger) -> String? {
        return decrypt(blocks, encryptedWith: exponent).map { String(data: $0, encoding: .utf16) }.flatMap { $0 }
    }
}

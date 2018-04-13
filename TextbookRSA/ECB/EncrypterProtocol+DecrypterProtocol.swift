//
//  EncrypterProtocol+DecrypterProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct EncryptedData<ECB: ECBProtocol, RSA: RSAProtocol> {
    let blocks: [ECB.Block]
    let usedEncryptionExponent: RSA.UInteger
}

public protocol EncrypterProtocol {
    associatedtype RSA: RSAProtocol
    associatedtype ECB: ECBProtocol where ECB.Block == RSA.UInteger
    
    typealias EncryptedData = TextbookRSA.EncryptedData<ECB, RSA>
    
    static func encrypt(_ data: Data, parameters: RSA.TransformationParameters) -> EncryptedData
}

extension EncrypterProtocol {
    static func encrypt(_ text: String, parameters: RSA.TransformationParameters) -> EncryptedData {
        let data = text.data(using: .utf16)!
        return encrypt(data, parameters: parameters)
    }
}

public protocol DecrypterProtocol {
    associatedtype RSA: RSAProtocol
    associatedtype ECB: ECBProtocol where ECB.Block == RSA.UInteger
    
    typealias EncryptedData = TextbookRSA.EncryptedData<ECB, RSA>
    
    var keys: RSA.Keys { get }
    func decrypt(_ encryptedData: EncryptedData) -> Data?
}

extension DecrypterProtocol {
    func generateEncryptionParameters() -> RSA.TransformationParameters {
        return keys.generateEncryptionParameters()
    }
    
    func decryptText(_ encryptedData: EncryptedData) -> String? {
        return decrypt(encryptedData).map { String(data: $0, encoding: .utf16) }.flatMap { $0 }
    }
}

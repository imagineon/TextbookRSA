//
//  EncrypterProtocol+DecrypterProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct ECBEncryptedData<Block: Equatable & Codable, UInteger: UnsignedInteger & Codable>: Codable, Equatable {
    public let blocks: [Block]
    public let encryptionExponent: UInteger
}

extension ECBEncryptedData {
    public static func ==(lhs: ECBEncryptedData, rhs: ECBEncryptedData) -> Bool {
        return (lhs.blocks == rhs.blocks && lhs.encryptionExponent == rhs.encryptionExponent)
    }
}

public protocol EncrypterProtocol {
    associatedtype RSA: RSAProtocol
    
    typealias EncryptedData = ECBEncryptedData<RSA.UInteger, RSA.UInteger>
    
    static func encrypt(_ data: Data, parameters: RSA.TransformationParameters) -> EncryptedData
}

public extension EncrypterProtocol {
    static func encrypt(_ text: String, parameters: RSA.TransformationParameters) -> EncryptedData {
        let data = text.data(using: .utf16)!
        return encrypt(data, parameters: parameters)
    }
}

public protocol DecrypterProtocol {
    associatedtype RSA: RSAProtocol
    
    typealias EncryptedData = ECBEncryptedData<RSA.UInteger, RSA.UInteger>

    func decrypt(_ encryptedData: EncryptedData) -> Data?
}

public extension DecrypterProtocol {
    func decryptText(_ encryptedData: EncryptedData) -> String? {
        return decrypt(encryptedData).map { String(data: $0, encoding: .utf16) }.flatMap { $0 }
    }
}

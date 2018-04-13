//
//  Encrypter+Decrypter.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public enum Encrypter {}

extension Encrypter: EncrypterProtocol {
    public typealias RSA = TextbookRSA.RSA
    public typealias ECB = TextbookRSA.ECB
    
    public static func encrypt(_ data: Data, parameters: RSA.TransformationParameters) -> Encrypter.EncryptedData {
        let ecb = ECB(blockSize: try! Math.Positive(parameters.modulo.usedBitWidth().value - 1))
        return encrypt(data, parameters: parameters, ecb: ecb)
    }
}

public struct Decrypter: DecrypterProtocol {
    public typealias RSA = TextbookRSA.RSA
    public typealias ECB = TextbookRSA.ECB
    
    public let keys: RSA.Keys

    public func decrypt(_ encryptedData: Decrypter.EncryptedData) -> Data? {
        let ecb = ECB(blockSize: try! Math.Positive(keys.public.usedBitWidth().value - 1))
        return decrypt(encryptedData, ecb: ecb)
    }
}

fileprivate extension EncrypterProtocol {
    static func encrypt(_ data: Data, parameters: RSA.TransformationParameters, ecb: ECB) -> EncryptedData {
        let blocksToEncrypt = ecb.chop(data)
        let encryptedBlocks = blocksToEncrypt.map { RSA.transform($0, with: parameters) }
        
        return EncryptedData(blocks: encryptedBlocks, usedEncryptionExponent: parameters.exponent)
    }
}

fileprivate extension DecrypterProtocol {
    func decrypt(_ encryptedData: EncryptedData, ecb: ECB) -> Data? {
        guard let decryptionParameters = keys.generateDecryptionParameters(forEncryptionExponent: encryptedData.usedEncryptionExponent) else { return nil }
        let decryptedBlocks = encryptedData.blocks.map { RSA.transform($0, with: decryptionParameters) }
        
        return ecb.reconstruct(decryptedBlocks)
    }
}










































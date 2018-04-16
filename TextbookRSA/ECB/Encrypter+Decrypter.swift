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
    
    public static func encrypt(_ data: Data, parameters: RSA.TransformationParameters) -> Encrypter.EncryptedData {
        let ecb = ECB(blockSize: parameters.modulo.usedBitWidth().predecessor)
        return encrypt(data, parameters: parameters, ecb: ecb)
    }
    
    private static func encrypt(_ data: Data, parameters: RSA.TransformationParameters, ecb: ECB) -> Encrypter.EncryptedData {
        let blocksToEncrypt = ecb.chop(data)
        let encryptedBlocks = blocksToEncrypt.map { RSA.transform($0, with: parameters) }
        
        return EncryptedData(blocks: encryptedBlocks, usedEncryptionExponent: parameters.exponent)
    }
}

public struct Decrypter: DecrypterProtocol {
    public typealias RSA = TextbookRSA.RSA
    
    public let keys: RSA.Keys
    
    public init(keys: RSA.Keys) {
        self.keys = keys
    }

    public func decrypt(_ encryptedData: Decrypter.EncryptedData) -> Data? {
        let ecb = ECB(blockSize: keys.public.usedBitWidth().predecessor)
        return Decrypter.decrypt(encryptedData, ecb: ecb, keys: keys)
    }
    
    private static func decrypt(_ encryptedData: Decrypter.EncryptedData, ecb: ECB, keys: RSA.Keys) -> Data? {
        guard let decryptionParameters = keys.generateDecryptionParameters(forEncryptionExponent: encryptedData.usedEncryptionExponent) else {
            return nil
        }
        
        let decryptedBlocks = encryptedData.blocks.map { RSA.transform($0, with: decryptionParameters) }
        return ecb.reconstruct(decryptedBlocks)
    }
}

//
//  PeriodDecrypter.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct PeriodDecrypter: DecrypterProtocol {
    public typealias RSA = TextbookRSA.RSA
    public typealias ECB = TextbookRSA.ECB
    
    let publicKey: RSA.GreaterThanOne
    
    public func decrypt(_ encryptedData: PeriodDecrypter.EncryptedData) -> Data? {
        var decryptedValue = [ECB.Block: ECB.Block]()
        let reducedBlocks = encryptedData.blocks.map { $0 % publicKey.value }
        
        for block in reducedBlocks {
            guard decryptedValue[block] == nil else {
                continue
            }
            
            guard let decryptBlockResult = decrypt(block: block, usedEncryptionExponent: encryptedData.usedEncryptionExponent) else {
                return nil
            }
            
            switch decryptBlockResult {
            case .block(let decryptedBlock):
                decryptedValue[block] = decryptedBlock
            case .keys(let keys):
                let decrypter = Decrypter(keys: keys)
                return decrypter.decrypt(encryptedData)
            }
        }
        
        // If we get to this point, we know the dictionary has an entry for every block in `encrypterdData`.
        let decryptedBlocks = reducedBlocks.map { decryptedValue[$0]! }
        let ecb = ECB(blockSize: publicKey.usedBitWidth().predecessor)
        
        return ecb.reconstruct(decryptedBlocks)
    }
    
    private enum DecryptBlockResult {
        case block(ECB.Block)
        case keys(RSA.Keys)
    }
    
    private func decrypt(block: ECB.Block, usedEncryptionExponent: RSA.UInteger) -> DecryptBlockResult? {
        guard block != 0 else {
            return .block(0)
        }
        
        if let keys = tryToExtractKeys(from: block) {
            return .keys(keys)
        } else if let period = PeriodOracle.period(of: block, modulo: publicKey.positive) {
            return decrypt(block: block, usedEncryptionExponent: usedEncryptionExponent, period: period).map {
                .block($0)
            }
        } else {
            return nil
        }
    }
    
    private func tryToExtractKeys(from block: ECB.Block) -> RSA.Keys? {
        guard
            let gcd = Math.gcd(block, publicKey.value),
            let privateP = try? RSA.GreaterThanOne(gcd),
            let privateQ = try? RSA.GreaterThanOne(publicKey.value / gcd)
        else { return nil }
        
        return try? RSA.Keys(privateP: privateP, privateQ: privateQ)
    }
    
    private func decrypt(block: ECB.Block, usedEncryptionExponent: RSA.UInteger, period: RSA.Positive) -> ECB.Block? {
        guard let decryptionExponent = usedEncryptionExponent.inverse(modulo: period) else { return nil }
        let decryptionParameters = RSA.TransformationParameters(modulo: publicKey, exponent: decryptionExponent)
        return RSA.transform(block, with: decryptionParameters)
    }
}

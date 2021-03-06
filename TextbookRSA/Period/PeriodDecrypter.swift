//
//  PeriodDecrypter.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct PeriodDecrypter: DecrypterProtocol {
    public typealias RSA = UIntRSA
    typealias ECB = UIntECB
    
    public let publicKey: RSA.GreaterThanOne
    
    public init(publicKey: RSA.GreaterThanOne) {
        self.publicKey = publicKey
    }
    
    public func decrypt(_ encryptedData: PeriodDecrypter.EncryptedData) -> Data? {
        var decryptedValue = [ECB.Block: ECB.Block]()
        let reducedBlocks = encryptedData.blocks.map { $0 % publicKey.value }
        
        for block in reducedBlocks {
            guard decryptedValue[block] == nil else {
                continue
            }
            
            guard let decryptBlockResult = decrypt(block: block, encryptionExponent: encryptedData.encryptionExponent) else {
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
    
    enum DecryptBlockResult {
        case block(ECB.Block)
        case keys(RSA.Keys)
    }
    
    func decrypt(block: ECB.Block, encryptionExponent: RSA.UInteger) -> DecryptBlockResult? {
        guard block != 0 else {
            return .block(0)
        }
        
        if let keys = tryToExtractKeys(from: block) {
            return .keys(keys)
        } else if let period = PeriodOracle.period(of: block, modulo: publicKey.positive) {
            return decrypt(block: block, encryptionExponent: encryptionExponent, period: period).map {
                .block($0)
            }
        } else {
            return nil
        }
    }
    
    func tryToExtractKeys(from block: ECB.Block) -> RSA.Keys? {
        guard
            let gcd = Math.gcd(block, publicKey.value),
            let privateP = try? RSA.GreaterThanOne(gcd),
            let privateQ = try? RSA.GreaterThanOne(publicKey.value / gcd)
        else { return nil }
        
        return try? RSA.Keys(privateP: privateP, privateQ: privateQ)
    }
    
    func decrypt(block: ECB.Block, encryptionExponent: RSA.UInteger, period: RSA.Positive) -> ECB.Block? {
        guard let decryptionExponent = encryptionExponent.inverse(modulo: period) else { return nil }
        let decryptionParameters = RSA.TransformationParameters(modulo: publicKey, exponent: decryptionExponent)
        return RSA.transform(block, with: decryptionParameters)
    }
}

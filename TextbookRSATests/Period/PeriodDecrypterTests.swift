//
//  PeriodDecrypterTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 16.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class PeriodDecrypterTests: XCTestCase {
    private static func block(coprimeTo publicKey: Math.Positive<UInt32>) -> RSA.UInteger {
        var result: RSA.UInteger
        
        repeat {
            result = RSA.UInteger.randomInRange(min: 0, count: publicKey)
        } while !Math.areCoprime(result, UInt(publicKey.value))
        
        return result
    }
    
    func testTryToExtractKeys() {
        for _ in 0 ..< 100 {
            let keys = RSA.Keys()
            let decrypter = PeriodDecrypter(publicKey: keys.public)
        
            let coprimeBlock = PeriodDecrypterTests.block(coprimeTo: try! .init(UInt32(keys.public.value)))
            XCTAssertNil(decrypter.tryToExtractKeys(from: coprimeBlock), "keys: \(keys) -- coprimeBlock: \(coprimeBlock)")
        
            let revealingBlock = keys.private.p.value * (keys.private.q.value / 2)
        
            guard let revealedKeys = decrypter.tryToExtractKeys(from: revealingBlock) else {
                XCTFail("Could not extract keys even though the block was not coprime with the public key. - keys: \(keys) -- revealingBlock: \(revealingBlock)")
                continue
            }

            let keysMatch =
                (revealedKeys.private.p.value == keys.private.p.value && revealedKeys.private.q.value == keys.private.q.value)
                || (revealedKeys.private.p.value == keys.private.q.value && revealedKeys.private.q.value == keys.private.p.value)
            XCTAssertTrue(keysMatch, "keys: \(keys) -- revealingBlock: \(revealingBlock) -- revealedKeys: \(revealedKeys)")
        }
    }
    
    private static func smallKeys() -> RSA.Keys {
        var result: RSA.Keys?

        repeat {
            let min = UInt(2)
            let max = UInt(100)
            
            let privateP = UInt.randomPrimeInRange(min: min, count: try! Math.Positive(UInt32(max - min)))
            let privateQ = UInt.randomPrimeInRange(min: min, count: try! Math.Positive(UInt32(max - min)))
            
            result = try? RSA.Keys(privateP: privateP, privateQ: privateQ)
        } while result == nil
        
        return result!
    }
    
    func testDecryptBlockWithPeriod() {
        for _ in 0 ..< 100 {
            let keys = PeriodDecrypterTests.smallKeys() // We cannot run tests with ordinary keys because period finding is very very hard!
            let decrypter = PeriodDecrypter(publicKey: keys.public)
            
            let block = PeriodDecrypterTests.block(coprimeTo: try! .init(UInt32(keys.public.value)))
            
            guard let period = PeriodOracle.period(of: block, modulo: decrypter.publicKey.positive) else {
                XCTFail("Could not get period even though the block was coprime with the public key. - keys: \(keys) -- block: \(block)")
                continue
            }
            
            let encryptionParms = keys.generateEncryptionParameters()
            let encryptedBlock = RSA.transform(block, with: encryptionParms)
            let decryptedBlock = decrypter.decrypt(block: encryptedBlock, usedEncryptionExponent: encryptionParms.exponent, period: period)
            
            XCTAssertEqual(decryptedBlock, block, "keys: \(keys) -- block: \(block) -- period: \(period) -- encryptionParms: \(encryptionParms) -- encryptedBlock: \(encryptedBlock) -- decryptedBlock: \(String(describing: decryptedBlock))")
        }
    }
}

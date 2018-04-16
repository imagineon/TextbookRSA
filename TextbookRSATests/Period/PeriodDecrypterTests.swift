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
    private static func block(coprimeTo publicKey: Math.Positive<UInt32>) -> UIntRSA.UInteger {
        var result: UIntRSA.UInteger
        
        repeat {
            result = UIntRSA.UInteger.randomInRange(min: 0, count: publicKey)
        } while !Math.areCoprime(result, UInt(publicKey.value))
        
        return result
    }
    
    func testTryToExtractKeys() {
        for _ in 0 ..< 100 {
            let keys = UIntRSA.Keys()
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
    
    private static func smallKeys() -> UIntRSA.Keys {
        var result: UIntRSA.Keys?

        repeat {
            let min = UInt(2)
            let max = UInt(100)
            
            let privateP = UInt.randomPrimeInRange(min: min, count: try! Math.Positive(UInt32(max - min)))
            let privateQ = UInt.randomPrimeInRange(min: min, count: try! Math.Positive(UInt32(max - min)))
            
            result = try? UIntRSA.Keys(privateP: privateP, privateQ: privateQ)
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
            let encryptedBlock = UIntRSA.transform(block, with: encryptionParms)
            let decryptedBlock = decrypter.decrypt(block: encryptedBlock, encryptionExponent: encryptionParms.exponent, period: period)
            
            XCTAssertEqual(decryptedBlock, block, "keys: \(keys) -- block: \(block) -- period: \(period) -- encryptionParms: \(encryptionParms) -- encryptedBlock: \(encryptedBlock) -- decryptedBlock: \(String(describing: decryptedBlock))")
        }
    }
    
    func testDecryptBlock() {
        for _ in 0 ..< 100 {
            let keys = PeriodDecrypterTests.smallKeys() // We cannot run tests with ordinary keys because period finding is very very hard!
            let encryptionParms = keys.generateEncryptionParameters()
            let decrypter = PeriodDecrypter(publicKey: keys.public)
            
            let coprimeBlock = PeriodDecrypterTests.block(coprimeTo: try! .init(UInt32(keys.public.value)))
            let encryptedCoprimeBlock = UIntRSA.transform(coprimeBlock, with: encryptionParms)
            let decryptedCoprimeBlock = decrypter.decrypt(block: encryptedCoprimeBlock, encryptionExponent: encryptionParms.exponent)
            let successOnCoprimeBlock: Bool = {
                if let decryptedCoprimeBlock = decryptedCoprimeBlock, case .block = decryptedCoprimeBlock {
                    return true
                } else {
                    return false
                }
            }()
            
            XCTAssertTrue(successOnCoprimeBlock, "Could not decrypt even though the block was coprime with the public key. - keys: \(keys) -- encryptionParms: \(encryptionParms) -- coprimeBlock: \(coprimeBlock) -- encryptedCoprimeBlock: \(encryptedCoprimeBlock) -- decryptedCoprimeBlock: \(String(describing: decryptedCoprimeBlock))")
            
            let revealingBlock = keys.private.p.value * (keys.private.q.value / 2)
            let encryptedRevealingBlock = UIntRSA.transform(revealingBlock, with: encryptionParms)
            let decryptedRevealingBlock = decrypter.decrypt(block: encryptedRevealingBlock, encryptionExponent: encryptionParms.exponent)
            let successOnRevealingBlock: Bool = {
                if let decryptedRevealingBlock = decryptedRevealingBlock, case .keys = decryptedRevealingBlock {
                    return true
                } else {
                    return false
                }
            }()
            
            XCTAssertTrue(successOnRevealingBlock, "Could not obtain keys even though the block was not coprime with the public key. - keys: \(keys) -- encryptionParms: \(encryptionParms) -- revealingBlock: \(revealingBlock) -- encryptedRevealingBlock: \(encryptedRevealingBlock) -- decryptedRevealingBlock: \(String(describing: decryptedRevealingBlock))")
            
            let zeroBlock = UIntRSA.UInteger(0)
            let decryptedZeroBlock = decrypter.decrypt(block: zeroBlock, encryptionExponent: encryptionParms.exponent)
            let successOnZeroBlock: Bool = {
                if let decryptedZeroBlock = decryptedZeroBlock, case .block(0) = decryptedZeroBlock {
                    return true
                } else {
                    return false
                }
            }()
            
            XCTAssertTrue(successOnZeroBlock, "Did not handle case `block == 0` correctly. - keys: \(keys) -- encryptionParms: \(encryptionParms) -- decryptedZeroBlock: \(String(describing: decryptedZeroBlock))")
        }
    }
    
    func testEncryptAndDecryptData() {
        for iteration in 0 ..< 100 {
            let keys = PeriodDecrypterTests.smallKeys() // We cannot run tests with ordinary keys because period finding is very very hard!
            let decrypter = PeriodDecrypter(publicKey: keys.public)
            let message = (iteration < 10) ? Data(bytes: []) :
                Data(bytes: (0 ..< 10).map { _ in UInt8(arc4random_uniform(UInt32(UInt8.max) + 1)) })
            let encryptedMessage = Encrypter.encrypt(message, parameters: keys.generateEncryptionParameters())
            let decryptedMessage = decrypter.decrypt(encryptedMessage)
            
            XCTAssertEqual(message, decryptedMessage, "decrypter: \(decrypter) -- message: \(message.map { $0 }) -- encryptedMessage: \(encryptedMessage) -- decryptedMessage: \(String(describing: decryptedMessage?.map { $0 }))")
        }
    }
    
    func testEncryptAndDecryptText() {
        for iteration in 0 ..< 100 {
            let keys = PeriodDecrypterTests.smallKeys() // We cannot run tests with ordinary keys because period finding is very very hard!
            let decrypter = PeriodDecrypter(publicKey: keys.public)
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
            
            let encryptedMessage = Encrypter.encrypt(message, parameters: keys.generateEncryptionParameters())
            let decryptedMessage = decrypter.decryptText(encryptedMessage)
            
            XCTAssertEqual(message, decryptedMessage, "decrypter: \(decrypter) -- message: \(message) -- encryptedMessage: \(encryptedMessage) -- decryptedMessage: \(String(describing: decryptedMessage))")
        }
    }
}

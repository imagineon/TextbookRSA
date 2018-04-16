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
    func testTryToExtractKeys() {
        for _ in 0 ..< 100 {
            let keys = RSA.Keys()
            let decrypter = PeriodDecrypter(publicKey: keys.public)
        
            let coprimeBlock: RSA.UInteger = {
                var result: RSA.UInteger
                
                repeat {
                    result = RSA.UInteger.randomInRange(min: 0, count: try! .init(UInt32(keys.public.value)))
                } while !Math.areCoprime(result, keys.public.value)
                
                return result
            }()
        
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
}

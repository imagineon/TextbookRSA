//
//  RSAKeysTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 12.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class RSAKeysTests: XCTestCase {
    func testEulerTotient() {
        let keys_2_3 = try! RSAKeys(privateP: try! .init(2), privateQ: try! .init(3))
        XCTAssertEqual(keys_2_3.eulerTotient.value, 1 * 2)
        let keys_5_7 = try! RSAKeys(privateP: try! .init(5), privateQ: try! .init(7))
        XCTAssertEqual(keys_5_7.eulerTotient.value, 4 * 6)
    }
    
    func testPublicKeyUpperBound() {
        /*
         Here, we want to make sure that the `UInt.power` operations do not overflow. For this, we require that
         the public key be at most the square root of `UInt.max`. On the other hand, we want to use primes as large
         as possible, so we want our upper bound to be as close as possible to this square root.
         */
        let bound = RSAKeys.publicKeyUpperBound
        XCTAssertLessThanOrEqual(bound, UInt(UInt32.max))
        XCTAssertFalse(bound.multipliedReportingOverflow(by: bound).overflow)
        
        let tooMuch = bound + 1
        XCTAssertTrue(tooMuch.multipliedReportingOverflow(by: tooMuch).overflow)
    }
    
    func testSmallestPrimeFactorUpperBound() {
        let primeFactorBound = RSAKeys.smallestPrimeFactorUpperBound
        let publicKeyBound = RSAKeys.publicKeyUpperBound
        
        let (square, overflow) = primeFactorBound.multipliedReportingOverflow(by: primeFactorBound)
        XCTAssertFalse(overflow)
        XCTAssertLessThanOrEqual(square, publicKeyBound)
        
        let tooMuch = primeFactorBound + 1
        let (tooMuchSquare, tooMuchOverflow) = tooMuch.multipliedReportingOverflow(by: tooMuch)
        XCTAssertFalse(tooMuchOverflow)
        XCTAssertGreaterThan(tooMuchSquare, publicKeyBound)
    }
    
    func testKeyGenerationTime() {
        let (keys, totalKeyGenTime) = Timing.evaluate {
            return (0 ..< 1_000).map { _ in return RSA.Keys() }
        }
        
        guard let averageKeyGenTime = totalKeyGenTime.map({ $0 / TimeInterval(keys.count) }) else {
            XCTFail("Could not measure time of random key generation.")
            return
        }
        
        XCTAssertLessThan(averageKeyGenTime, 0.001)
    }
    
    func testEncryptionParametersGenerationTime() {
        let keys = (0 ..< 1_000).map { _ in return RSA.Keys() }
        
        let (parms, totalParmsGenTime) = Timing.evaluate {
            return keys.map { $0.generateEncryptionParameters() }
        }
        
        guard let averageParmsGenTime = totalParmsGenTime.map({ $0 / TimeInterval(parms.count) }) else {
            XCTFail("Could not measure time of random encryption parameters generation.")
            return
        }

        XCTAssertLessThan(averageParmsGenTime, 0.001)
    }
}

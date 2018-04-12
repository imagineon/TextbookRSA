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
}

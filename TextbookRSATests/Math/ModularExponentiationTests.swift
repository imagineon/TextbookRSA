//
//  ModularExponentiationTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class ModularExponentiationTests: XCTestCase {
    func testPower() {
        // Powers of 0
        XCTAssertEqual(UInt(0).power(0, modulo: try! Math.Positive<UInt>(1)), 0)
        XCTAssertEqual(UInt(0).power(0, modulo: try! Math.Positive<UInt>(13)), 1) // This test documents our convention that `0^0 = 1`.
        XCTAssertEqual(UInt(0).power(1, modulo: try! Math.Positive<UInt>(13)), 0)
        XCTAssertEqual(UInt(0).power(2, modulo: try! Math.Positive<UInt>(13)), 0)
        // Powers of 1
        XCTAssertEqual(UInt(1).power(0, modulo: try! Math.Positive<UInt>(13)), 1)
        XCTAssertEqual(UInt(1).power(1, modulo: try! Math.Positive<UInt>(13)), 1)
        XCTAssertEqual(UInt(1).power(2, modulo: try! Math.Positive<UInt>(13)), 1)
        // Powers of 6
        XCTAssertEqual(UInt(6).power(0, modulo: try! Math.Positive<UInt>(1)), 0)
        XCTAssertEqual(UInt(6).power(0, modulo: try! Math.Positive<UInt>(13)), 1)
        XCTAssertEqual(UInt(6).power(1, modulo: try! Math.Positive<UInt>(13)), 6)
        XCTAssertEqual(UInt(6).power(2, modulo: try! Math.Positive<UInt>(13)), 36 % 13)
        XCTAssertEqual(UInt(6).power(3, modulo: try! Math.Positive<UInt>(13)), 216 % 13)
        XCTAssertEqual(UInt(6).power(4, modulo: try! Math.Positive<UInt>(13)), 1296 % 13)
        XCTAssertEqual(UInt(6).power(5, modulo: try! Math.Positive<UInt>(13)), 7776 % 13)
        XCTAssertEqual(UInt(6 + (2 * 13)).power(5, modulo: try! Math.Positive<UInt>(13)), 7776 % 13)
    }
}

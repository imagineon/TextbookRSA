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
    func testPowerOracle() {
        typealias Oracle = Math.PowerOracle<UInt>

        // Powers of 0
        let oracle_0_1 = Oracle(base: 0, modulo: try! .init(1))
        XCTAssertEqual(oracle_0_1.power(exponent: 0), 0)
        let oracle_0_13 = Oracle(base: 0, modulo: try! .init(13))
        XCTAssertEqual(oracle_0_13.power(exponent: 0), 1) // This test documents our convention that `0^0 = 1`.
        XCTAssertEqual(oracle_0_13.power(exponent: 1), 0)
        XCTAssertEqual(oracle_0_13.power(exponent: 2), 0)
        // Powers of 1
        let oracle_1_13 = Oracle(base: 1, modulo: try! .init(13))
        XCTAssertEqual(oracle_1_13.power(exponent: 0), 1)
        XCTAssertEqual(oracle_1_13.power(exponent: 1), 1)
        XCTAssertEqual(oracle_1_13.power(exponent: 2), 1)
        // Powers of 6
        let oracle_6_1 = Oracle(base: 6, modulo: try! .init(1))
        XCTAssertEqual(oracle_6_1.power(exponent: 0), 0)
        let oracle_6_13 = Oracle(base: 6, modulo: try! .init(13))
        XCTAssertEqual(oracle_6_13.power(exponent: 0), 1)
        XCTAssertEqual(oracle_6_13.power(exponent: 1), 6)
        XCTAssertEqual(oracle_6_13.power(exponent: 2), 36 % 13)
        XCTAssertEqual(oracle_6_13.power(exponent: 3), 216 % 13)
        XCTAssertEqual(oracle_6_13.power(exponent: 4), 1296 % 13)
        XCTAssertEqual(oracle_6_13.power(exponent: 5), 7776 % 13)
        let oracle_cong_6_13 = Oracle(base: 6 + (2 * 13), modulo: try! .init(13))
        XCTAssertEqual(oracle_cong_6_13.power(exponent: 5), 7776 % 13)
    }
    
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

//
//  GCDTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 12.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class GCDTests: XCTestCase {
    func testGcd() {
        XCTAssertNil(Math.gcd(UInt(0), UInt(0)))
        XCTAssertEqual(Math.gcd(UInt(0), UInt(1)), 1)
        XCTAssertEqual(Math.gcd(UInt(1), UInt(0)), 1)
        XCTAssertEqual(Math.gcd(UInt(1), UInt(1)), 1)
        XCTAssertEqual(Math.gcd(UInt(0), UInt(42)), 42)
        XCTAssertEqual(Math.gcd(UInt(42), UInt(0)), 42)
        XCTAssertEqual(Math.gcd(UInt(2), UInt(3)), 1)
        XCTAssertEqual(Math.gcd(UInt(2), UInt(4)), 2)
        XCTAssertEqual(Math.gcd(UInt(15), UInt(20)), 5)
    }
    
    func testAreCoprime() {
        XCTAssertTrue(Math.areCoprime(UInt(15), UInt(22)))
        XCTAssertFalse(Math.areCoprime(UInt(15), UInt(18)))
        XCTAssertFalse(Math.areCoprime(UInt(0), UInt(7)))
        XCTAssertTrue(Math.areCoprime(UInt(1), UInt(0)))
        XCTAssertFalse(Math.areCoprime(UInt(0), UInt(0)))
    }
}

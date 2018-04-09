//
//  PrimeTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class PrimeTests: XCTestCase {
    func testIsPrime() {
        XCTAssertFalse(Math.isPrime(UInt(0)))
        XCTAssertFalse(Math.isPrime(UInt(1)))
        XCTAssertTrue(Math.isPrime(UInt(2)))
        XCTAssertTrue(Math.isPrime(UInt(3)))
        XCTAssertFalse(Math.isPrime(UInt(4)))
        XCTAssertTrue(Math.isPrime(UInt(5)))
        XCTAssertFalse(Math.isPrime(UInt(6)))
        XCTAssertTrue(Math.isPrime(UInt(7)))
        XCTAssertFalse(Math.isPrime(UInt(8)))
        XCTAssertFalse(Math.isPrime(UInt(9)))
        XCTAssertFalse(Math.isPrime(UInt(10)))
        XCTAssertTrue(Math.isPrime(UInt(11)))
        XCTAssertFalse(Math.isPrime(UInt(12)))
        XCTAssertTrue(Math.isPrime(UInt(13)))
        XCTAssertFalse(Math.isPrime(UInt(14)))
        XCTAssertFalse(Math.isPrime(UInt(15)))
        XCTAssertFalse(Math.isPrime(UInt(16)))
        XCTAssertTrue(Math.isPrime(UInt(17)))
        XCTAssertFalse(Math.isPrime(UInt(18)))
        XCTAssertTrue(Math.isPrime(UInt(19)))
        XCTAssertFalse(Math.isPrime(UInt(20)))
        XCTAssertFalse(Math.isPrime(UInt(21)))
        XCTAssertFalse(Math.isPrime(UInt(22)))
        XCTAssertTrue(Math.isPrime(UInt(23)))
        XCTAssertFalse(Math.isPrime(UInt(24)))
        XCTAssertFalse(Math.isPrime(UInt(25)))
    }
}

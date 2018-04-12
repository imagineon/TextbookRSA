//
//  BitTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class BitTests: XCTestCase {
    func testUIntToBase2LittleEndian() {
        XCTAssertEqual(UInt(0).base2(byteOrder: .littleEndian), [])
        XCTAssertEqual(UInt(1).base2(byteOrder: .littleEndian), [.one])
        XCTAssertEqual(UInt(2).base2(byteOrder: .littleEndian), [.zero, .one])
        XCTAssertEqual(UInt(3).base2(byteOrder: .littleEndian), [.one, .one])
        XCTAssertEqual(UInt(42).base2(byteOrder: .littleEndian), [.zero, .one, .zero, .one, .zero, .one])
    }
    
    func testUIntToBase2BigEndian() {
        XCTAssertEqual(UInt(0).base2(byteOrder: .bigEndian), [])
        XCTAssertEqual(UInt(1).base2(byteOrder: .bigEndian), [.one])
        XCTAssertEqual(UInt(2).base2(byteOrder: .bigEndian), [.one, .zero])
        XCTAssertEqual(UInt(3).base2(byteOrder: .bigEndian), [.one, .one])
        XCTAssertEqual(UInt(42).base2(byteOrder: .bigEndian), [.one, .zero, .one, .zero, .one, .zero])
    }
    
    func testBase2ToUIntLittleEndian() {
        XCTAssertEqual(UInt(fromBase2: [], byteOrder: .littleEndian), 0)
        XCTAssertEqual(UInt(fromBase2: [.one], byteOrder: .littleEndian), 1)
        XCTAssertEqual(UInt(fromBase2: [.zero, .one], byteOrder: .littleEndian), 2)
        XCTAssertEqual(UInt(fromBase2: [.one, .one], byteOrder: .littleEndian), 3)
        XCTAssertEqual(UInt(fromBase2: [.zero, .one, .zero, .one, .zero, .one], byteOrder: .littleEndian), 42)
        XCTAssertEqual(UInt(fromBase2: .init(repeating: .one, count: UInt.bitWidth), byteOrder: .littleEndian), UInt.max)
    }
    
    func testBase2ToUIntBigEndian() {
        XCTAssertEqual(UInt(fromBase2: [], byteOrder: .bigEndian), 0)
        XCTAssertEqual(UInt(fromBase2: [.one], byteOrder: .bigEndian), 1)
        XCTAssertEqual(UInt(fromBase2: [.one, .zero], byteOrder: .bigEndian), 2)
        XCTAssertEqual(UInt(fromBase2: [.one, .one], byteOrder: .bigEndian), 3)
        XCTAssertEqual(UInt(fromBase2: [.one, .zero, .one, .zero, .one, .zero], byteOrder: .bigEndian), 42)
        XCTAssertEqual(UInt(fromBase2: .init(repeating: .one, count: UInt.bitWidth), byteOrder: .bigEndian), UInt.max)
    }
}

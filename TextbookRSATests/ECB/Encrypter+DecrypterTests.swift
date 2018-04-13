//
//  Encrypter+DecrypterTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class EncrypterPlusDecrypterTests: XCTestCase {
    func testUsedBitWidth() {
        XCTAssertEqual(UInt(0).usedBitWidth(), 0)
        XCTAssertEqual(UInt(1).usedBitWidth(), 1)
        XCTAssertEqual(UInt(2).usedBitWidth(), 2)
        XCTAssertEqual(UInt(3).usedBitWidth(), 2)
        XCTAssertEqual(UInt(4).usedBitWidth(), 3)
        XCTAssertEqual(UInt(31).usedBitWidth(), 5)
        XCTAssertEqual(UInt(32).usedBitWidth(), 6)
        XCTAssertEqual(UInt(42).usedBitWidth(), 6)
    }
}

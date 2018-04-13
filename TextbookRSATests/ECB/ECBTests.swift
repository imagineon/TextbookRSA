//
//  ECBTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class ECBTests: XCTestCase {
    func testChop() {
        let emptyData = Data(bytes: [])
        let oneByte42 = Data(bytes: [42])
        let oneByteMax = Data(bytes: [UInt8.max])
        let sixBytes = Data(bytes: [0b10010010, 0b11010011, 0b00000110, 0b11110010, 0b10011010, 0b10000010])
        
        let ecb7 = ECB(blockSize: try! Math.Positive(7))
        XCTAssertEqual(ecb7.chop(emptyData), [1])
        XCTAssertEqual(ecb7.chop(oneByte42), [42, 2])
        XCTAssertEqual(ecb7.chop(oneByteMax), [(1 << 7) - 1, 3])
        XCTAssertEqual(ecb7.chop(sixBytes), [0b0010010, 0b0100111, 0b0011011, 0b0010000, 0b0101111, 0b1010011, 0b1100000])
        
        let ecb4 = ECB(blockSize: try! Math.Positive(4))
        XCTAssertEqual(ecb4.chop(emptyData), [1])
        XCTAssertEqual(ecb4.chop(oneByte42), [10, 2, 1])
        XCTAssertEqual(ecb4.chop(oneByteMax), [(1 << 4) - 1, (1 << 4) - 1, 1])
        XCTAssertEqual(ecb4.chop(sixBytes), [0b0010, 0b1001, 0b0011, 0b1101, 0b0110, 0b0000, 0b0010, 0b1111, 0b1010, 0b1001, 0b0010, 0b1000, 1])
        
        let ecb1 = ECB(blockSize: try! Math.Positive(1))
        XCTAssertEqual(ecb1.chop(emptyData), [1])
        XCTAssertEqual(ecb1.chop(oneByte42), [0, 1, 0, 1, 0, 1, 0, 0, 1])
        XCTAssertEqual(ecb1.chop(oneByteMax), [1, 1, 1, 1, 1, 1, 1, 1, 1])
        XCTAssertEqual(ecb1.chop(sixBytes), [
            0, 1, 0, 0, 1, 0, 0, 1,
            1, 1, 0, 0, 1, 0, 1, 1,
            0, 1, 1, 0, 0, 0, 0, 0,
            0, 1, 0, 0, 1, 1, 1, 1,
            0, 1, 0, 1, 1, 0, 0, 1,
            0, 1, 0, 0, 0, 0, 0, 1,
            1
        ])
    }
}

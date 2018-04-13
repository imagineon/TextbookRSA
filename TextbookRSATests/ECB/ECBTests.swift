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
    
    func testArraySlice() {
        typealias Bit = TextbookRSA.Bit
        
        func slicesAreEqual(left: [[Bit]], right: [[Bit]]) -> Bool {
            guard left.count == right.count else { return false }
            
            for index in left.indices where left[index] != right[index] {
                return false
            }
            
            return true
        }
        
        XCTAssertTrue(slicesAreEqual(left: [Bit]().slice(chunkSize: 5), right: []))
        XCTAssertTrue(slicesAreEqual(left: [Bit.one, .one, .zero, .zero, .one].slice(chunkSize: 5), right: [[.one, .one, .zero, .zero, .one]]))
        XCTAssertTrue(slicesAreEqual(
            left: [Bit.zero, .zero, .zero, .zero, .zero, .one, .one, .one, .one, .one].slice(chunkSize: 5),
            right: [[.zero, .zero, .zero, .zero, .zero], [.one, .one, .one, .one, .one]]))
    }
    
    func testArrayIndexOfLast() {
        typealias Bit = TextbookRSA.Bit
        
        XCTAssertEqual([Bit]().index(ofLast: .one), nil)
        XCTAssertEqual([Bit.zero, .zero, .zero].index(ofLast: .one), nil)
        XCTAssertEqual([Bit.zero, .one, .zero, .one, .one, .zero, .zero].index(ofLast: .one), 4)
    }
    
    func testReconstruct() {
        /*
         Test unsuccessful cases.
         */
        
        let ecb7 = ECB(blockSize: try! Math.Positive(7))
        
        XCTAssertNil(ecb7.reconstruct([])) // No 1s
        XCTAssertNil(ecb7.reconstruct([0, 0, 0])) // No 1s
        XCTAssertNil(ecb7.reconstruct([0, 0b1000000, 0])) // Last 1 is followed by too many 0s.
        XCTAssertNil(ecb7.reconstruct([0, 0, 1])) // Padding is correct, but after removing it we have 14 bits (not divisible by 8).
        XCTAssertNil(ecb7.reconstruct([0b10000000, 0, 4])) // Padding is correct, but one block is too large.
        
        let ecb4 = ECB(blockSize: try! Math.Positive(4))
        
        XCTAssertNil(ecb4.reconstruct([])) // No 1s
        XCTAssertNil(ecb4.reconstruct([0, 0, 0])) // No 1s
        XCTAssertNil(ecb4.reconstruct([0, 0b1000, 0])) // Last 1 is followed by too many 0s.
        XCTAssertNil(ecb4.reconstruct([0, 0, 0b0010])) // Padding is correct, but after removing it we have 9 bits (not divisible by 8).
        XCTAssertNil(ecb4.reconstruct([0b10000, 0, 1])) // Padding is correct, but one block is too large.
        
        let ecb1 = ECB(blockSize: try! Math.Positive(1))
        
        XCTAssertNil(ecb1.reconstruct([])) // No 1s
        XCTAssertNil(ecb1.reconstruct([0, 0, 0])) // No 1s
        XCTAssertNil(ecb1.reconstruct([0, 1, 0])) // Last 1 is followed by too many 0s.
        XCTAssertNil(ecb1.reconstruct([0, 0, 1])) // Padding is correct, but after removing it we have 2 bits (not divisible by 8).
        XCTAssertNil(ecb1.reconstruct([0, 0, 0, 0, 0, 2, 0, 0, 1])) // Padding is correct, but one block is too large.
        
        /*
         Test successful cases by using `ECB.chop` first.
         */
        
        let emptyData = Data(bytes: [])
        let oneByte42 = Data(bytes: [42])
        let oneByteMax = Data(bytes: [UInt8.max])
        let sixBytes = Data(bytes: [0b10010010, 0b11010011, 0b00000110, 0b11110010, 0b10011010, 0b10000010])
        
        XCTAssertEqual(ecb7.reconstruct(ecb7.chop(emptyData)), emptyData)
        XCTAssertEqual(ecb7.reconstruct(ecb7.chop(oneByte42)), oneByte42)
        XCTAssertEqual(ecb7.reconstruct(ecb7.chop(oneByteMax)), oneByteMax)
        XCTAssertEqual(ecb7.reconstruct(ecb7.chop(sixBytes)), sixBytes)
        
        XCTAssertEqual(ecb4.reconstruct(ecb4.chop(emptyData)), emptyData)
        XCTAssertEqual(ecb4.reconstruct(ecb4.chop(oneByte42)), oneByte42)
        XCTAssertEqual(ecb4.reconstruct(ecb4.chop(oneByteMax)), oneByteMax)
        XCTAssertEqual(ecb4.reconstruct(ecb4.chop(sixBytes)), sixBytes)
        
        XCTAssertEqual(ecb1.reconstruct(ecb1.chop(emptyData)), emptyData)
        XCTAssertEqual(ecb1.reconstruct(ecb1.chop(oneByte42)), oneByte42)
        XCTAssertEqual(ecb1.reconstruct(ecb1.chop(oneByteMax)), oneByteMax)
        XCTAssertEqual(ecb1.reconstruct(ecb1.chop(sixBytes)), sixBytes)
    }
}

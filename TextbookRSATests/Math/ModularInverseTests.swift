//
//  ModularInverseTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class ModularInverseTests: XCTestCase {
    func testInverse() {
        XCTAssertEqual(UInt(0).inverse(modulo: try! Math.Positive<UInt>(1)), 0)
        
        XCTAssertEqual(UInt(0).inverse(modulo: try! Math.Positive<UInt>(4)), nil)
        XCTAssertEqual(UInt(1).inverse(modulo: try! Math.Positive<UInt>(4)), 1)
        XCTAssertEqual(UInt(2).inverse(modulo: try! Math.Positive<UInt>(4)), nil)
        XCTAssertEqual(UInt(3).inverse(modulo: try! Math.Positive<UInt>(4)), 3)
        
        XCTAssertEqual(UInt(11).inverse(modulo: try! Math.Positive<UInt>(42)).map { ($0 * 11) % 42 }, 1)
    }
}

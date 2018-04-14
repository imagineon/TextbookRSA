//
//  PeriodOracleTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class PeriodOracleTests: XCTestCase {
    func testPeriod() {
        // Modulo 1, everything is equal to 0, so the period is always 1:
        XCTAssertEqual(PeriodOracle.period(of: 0, modulo: try! .init(1)), 1)
        XCTAssertEqual(PeriodOracle.period(of: 1, modulo: try! .init(1)), 1)
        XCTAssertEqual(PeriodOracle.period(of: 6, modulo: try! .init(1)), 1)
        
        // Modulo > 1, cases with no period:
        XCTAssertNil(PeriodOracle.period(of: 0, modulo: try! .init(6)))
        XCTAssertNil(PeriodOracle.period(of: 2, modulo: try! .init(6)))
        
        // Modulo > 1, cases with a period:
        XCTAssertEqual(PeriodOracle.period(of: 1, modulo: try! .init(6)), 1)
        XCTAssertEqual(PeriodOracle.period(of: 5, modulo: try! .init(6)), 2)
        XCTAssertEqual(PeriodOracle.period(of: 2, modulo: try! .init(5)), 4)
    }
}

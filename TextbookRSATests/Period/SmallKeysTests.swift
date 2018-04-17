//
//  SmallKeysTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 17.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class SmallKeysTests: XCTestCase {
    func testSmallKeys() {
        let keys_2_3 = try! UIntRSAKeys(privateP: try! .init(2), privateQ: try! .init(3))
        
        let small_keys_0 = UIntRSAKeys.small(maxPrime: 0)
        XCTAssertEqual(small_keys_0, keys_2_3)
        
        let small_keys_1 = UIntRSAKeys.small(maxPrime: 1)
        XCTAssertEqual(small_keys_1, keys_2_3)
        
        let small_keys_2 = UIntRSAKeys.small(maxPrime: 2)
        XCTAssertEqual(small_keys_2, keys_2_3)
        
        let small_keys_3 = UIntRSAKeys.small(maxPrime: 3)
        XCTAssertEqual(small_keys_3, keys_2_3)
        
        for _ in 0 ..< 100 {
            let keys = UIntRSAKeys.small(maxPrime: 100)
            XCTAssertLessThanOrEqual(keys.primes.p.value, 100, "keys: \(keys)")
            XCTAssertLessThanOrEqual(keys.primes.q.value, 100, "keys: \(keys)")
        }
    }
}

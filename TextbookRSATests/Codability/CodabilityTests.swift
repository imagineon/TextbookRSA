//
//  CodabilityTests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class CodabilityTests: XCTestCase {
    func testDecodingTransformationParameters() {
        let validJsonString = """
            {
                "modulo": 5,
                "exponent": 7
            }
        """
        
        let validJsonData = validJsonString.data(using: .utf8)!
        let validParms = try? JSONDecoder().decode(RSA.TransformationParameters.self, from: validJsonData)
        XCTAssertNotNil(validParms)
        XCTAssertEqual(validParms?.modulo.value, 5)
        XCTAssertEqual(validParms?.exponent, 7)
        
        let jsonStringNoExponent = """
            {
                "modulo": 5
            }
        """
        
        let jsonDataNoExponent = jsonStringNoExponent.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.TransformationParameters.self, from: jsonDataNoExponent))
        
        let jsonStringSmallModulo = """
            {
                "modulo": 1,
                "exponent": 7
            }
        """
        
        let jsonDataSmallModulo = jsonStringSmallModulo.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.TransformationParameters.self, from: jsonDataSmallModulo))
    }
    
    func testEncodingTransformationParameters() {
        let parms = RSA.TransformationParameters(modulo: try! .init(5), exponent: 7)
        let encoded = try? JSONEncoder().encode(parms)
        XCTAssertNotNil(encoded)
        
        let decoded = encoded.map { try? JSONDecoder().decode(RSA.TransformationParameters.self, from: $0) }.flatMap { $0 }
        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded?.modulo.value, parms.modulo.value)
        XCTAssertEqual(decoded?.exponent, parms.exponent)
    }
}

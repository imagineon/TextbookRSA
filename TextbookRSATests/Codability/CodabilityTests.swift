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
        
        let jsonStringNoModulo = """
            {
                "exponent": 7
            }
        """
        
        let jsonDataNoModulo = jsonStringNoModulo.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.TransformationParameters.self, from: jsonDataNoModulo))
        
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
    
    func testDecodingKeys() {
        let validJsonString = """
            {
                "prime_p": 5,
                "prime_q": 7
            }
        """
        
        let validJsonData = validJsonString.data(using: .utf8)!
        let validKeys = try? JSONDecoder().decode(RSA.Keys.self, from: validJsonData)
        XCTAssertNotNil(validKeys)
        XCTAssertEqual(validKeys?.private.p.value, 5)
        XCTAssertEqual(validKeys?.private.q.value, 7)
        
        let jsonStringNoQ = """
            {
                "prime_p": 5
            }
        """
        
        let jsonDataNoQ = jsonStringNoQ.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.Keys.self, from: jsonDataNoQ))
        
        let jsonStringNoP = """
            {
                "prime_q": 7
            }
        """
        
        let jsonDataNoP = jsonStringNoP.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.Keys.self, from: jsonDataNoP))
        
        let jsonStringSmallP = """
            {
                "prime_p": 1,
                "prime_q": 7
            }
        """
        
        let jsonDataSmallP = jsonStringSmallP.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.Keys.self, from: jsonDataSmallP))
        
        let jsonStringSmallQ = """
            {
                "prime_p": 5,
                "prime_q": 1
            }
        """
        
        let jsonDataSmallQ = jsonStringSmallQ.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.Keys.self, from: jsonDataSmallQ))
        
        let jsonStringLargeFactors = """
            {
                "prime_p": \(RSAKeys.smallestPrimeFactorUpperBound + 1),
                "prime_q": \(RSAKeys.smallestPrimeFactorUpperBound + 2)
            }
        """
        
        let jsonDataLargeFactors = jsonStringLargeFactors.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.Keys.self, from: jsonDataLargeFactors))
        
        let jsonStringEqualFactors = """
            {
                "prime_p": 5,
                "prime_q": 5
            }
        """
        
        let jsonDataEqualFactors = jsonStringEqualFactors.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(RSA.Keys.self, from: jsonDataEqualFactors))
    }
    
    func testEncodingKeys() {
        let keys = try! RSA.Keys(privateP: try! .init(5), privateQ: try! .init(7))
        let encoded = try? JSONEncoder().encode(keys)
        XCTAssertNotNil(encoded)
        
        let decoded = encoded.map { try? JSONDecoder().decode(RSA.Keys.self, from: $0) }.flatMap { $0 }
        XCTAssertNotNil(decoded)
        XCTAssertEqual(decoded?.private.p.value, keys.private.p.value)
        XCTAssertEqual(decoded?.private.q.value, keys.private.q.value)
    }
    
    func testDecodingEncryptedData() {
        // TODO
    }
    
    func testEncodingEncryptedData() {
        // TODO
    }
}

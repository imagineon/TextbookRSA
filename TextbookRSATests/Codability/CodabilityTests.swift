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
        if let validParms = validParms {
            XCTAssertEqual(validParms.modulo.value, 5)
            XCTAssertEqual(validParms.exponent, 7)
        }
        
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
        
        if let encoded = encoded {
            let decoded = try? JSONDecoder().decode(RSA.TransformationParameters.self, from: encoded)
            XCTAssertNotNil(decoded)
            if let decoded = decoded {
                XCTAssertEqual(decoded.modulo.value, parms.modulo.value)
                XCTAssertEqual(decoded.exponent, parms.exponent)
            }
        }
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
        if let validKeys = validKeys {
            XCTAssertEqual(validKeys.private.p.value, 5)
            XCTAssertEqual(validKeys.private.q.value, 7)
        }
        
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
        
        if let encoded = encoded {
            let decoded = try? JSONDecoder().decode(RSA.Keys.self, from: encoded)
            XCTAssertNotNil(decoded)
            if let decoded = decoded {
                XCTAssertEqual(decoded.private.p.value, keys.private.p.value)
                XCTAssertEqual(decoded.private.q.value, keys.private.q.value)
            }
        }
    }
    
    func testDecodingEncryptedData() {
        let validJsonString = """
            {
                "blocks": [
                    1,
                    2,
                    3
                ],
                "exponent": 7
            }
        """
        
        let validJsonData = validJsonString.data(using: .utf8)!
        let valid = try? JSONDecoder().decode(Encrypter.EncryptedData.self, from: validJsonData)
        XCTAssertNotNil(valid)
        if let valid = valid {
            XCTAssertEqual(valid.blocks, [1, 2, 3])
            XCTAssertEqual(valid.usedEncryptionExponent, 7)
        }
        
        let validJsonStringEmptyBlocks = """
            {
                "blocks": [
                ],
                "exponent": 7
            }
        """
        
        let validJsonDataEmptyBlocks = validJsonStringEmptyBlocks.data(using: .utf8)!
        let validEmptyBlocks = try? JSONDecoder().decode(Encrypter.EncryptedData.self, from: validJsonDataEmptyBlocks)
        XCTAssertNotNil(validEmptyBlocks)
        if let validEmptyBlocks = validEmptyBlocks {
            XCTAssertEqual(validEmptyBlocks.blocks, [])
            XCTAssertEqual(validEmptyBlocks.usedEncryptionExponent, 7)
        }
        
        let jsonStringNoBlocks = """
            {
                "exponent": 7
            }
        """
        
        let jsonDataNoBlocks = jsonStringNoBlocks.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(Encrypter.EncryptedData.self, from: jsonDataNoBlocks))
        
        let jsonStringNoExponent = """
            {
                "blocks": [
                    1,
                    2,
                    3
                ]
            }
        """
        
        let jsonDataNoExponent = jsonStringNoExponent.data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(Encrypter.EncryptedData.self, from: jsonDataNoExponent))
    }
    
    func testEncodingEncryptedData() {
        let encryptedData = Encrypter.EncryptedData(blocks: [1, 2, 3], usedEncryptionExponent: 7)
        let encoded = try? JSONEncoder().encode(encryptedData)
        XCTAssertNotNil(encoded)
        
        if let encoded = encoded {
            let decoded = try? JSONDecoder().decode(Encrypter.EncryptedData.self, from: encoded)
            XCTAssertNotNil(decoded)
            if let decoded = decoded {
                XCTAssertEqual(decoded.blocks, encryptedData.blocks)
                XCTAssertEqual(decoded.usedEncryptionExponent, encryptedData.usedEncryptionExponent)
            }
        }
    }
}

//
//  RSATests.swift
//  TextbookRSATests
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import XCTest
@testable import TextbookRSA

class RSATests: XCTestCase {
    func testFullMessageExchange() {
        for _ in 0 ..< 1000 {
            let keys = UIntRSA.Keys()
            let message = UInt.randomInRange(min: 0, count: try! Math.Positive(UInt32(keys.public.value)))
            
            let encryptionParms = keys.generateEncryptionParameters()
            let encryptedMessage = UIntRSA.transform(message, with: encryptionParms)
            
            guard let decryptionParms = keys.generateDecryptionParameters(forEncryptionExponent: encryptionParms.exponent) else {
                XCTFail("Could not generate decryption parameters - keys: \(keys) -- encryptionParms: \(encryptionParms)")
                continue
            }
            
            let decryptedMessage = UIntRSA.transform(encryptedMessage, with: decryptionParms)
            
            XCTAssert(message == decryptedMessage, "keys: \(keys) -- message: \(message) -- encryptionParms: \(encryptionParms) -- encryptedMessage: \(encryptedMessage) -- decryptionParms: \(decryptionParms) -- decryptedMessage: \(decryptedMessage)")
        }
    }
}

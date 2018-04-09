//
//  RSAKeys.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

struct RSAKeys: RSAKeysProtocol {
    typealias RSA = TextbookRSA.RSA
    
    let `private`: (p: RSA.Prime, q: RSA.Prime)
    
    var `public`: RSA.UInteger {
        return self.private.p.value * self.private.q.value
    }
    
    init() {
        self.init(privateP: try! RSA.Prime(2), privateQ: try! RSA.Prime(2)) // TODO
    }
    
    init(privateP: RSA.Prime, privateQ: RSA.Prime) {
        self.private = (p: privateP, q: privateQ)
    }
    
    func generateEncryptionParameters() -> RSA.TransformationParameters {
        return RSA.TransformationParameters(modulo: 0, exponent: 0) // TODO
    }
    
    func generateDecryptionParameters(for encryptionParameters: RSA.TransformationParameters) -> RSA.TransformationParameters {
        return RSA.TransformationParameters(modulo: 0, exponent: 0) // TODO
    }
}

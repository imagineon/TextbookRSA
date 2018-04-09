//
//  RSAKeys.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct RSAKeys: RSAKeysProtocol {
    public typealias RSA = TextbookRSA.RSA
    
    public let `private`: (p: RSA.Prime, q: RSA.Prime)
    
    public var `public`: RSA.UInteger {
        return self.private.p.value * self.private.q.value
    }
    
    public init() {
        self.init(privateP: try! RSA.Prime(2), privateQ: try! RSA.Prime(2)) // TODO
    }
    
    public init(privateP: RSA.Prime, privateQ: RSA.Prime) {
        self.private = (p: privateP, q: privateQ)
    }
    
    public func generateEncryptionParameters() -> RSA.TransformationParameters {
        return RSA.TransformationParameters(modulo: 0, exponent: 0) // TODO
    }
    
    public func generateDecryptionParameters(for encryptionParameters: RSA.TransformationParameters) -> RSA.TransformationParameters {
        return RSA.TransformationParameters(modulo: 0, exponent: 0) // TODO
    }
}

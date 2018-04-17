//
//  Codability.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension RSATransformationParameters {
    enum CodingKeys: String, CodingKey {
        case modulo
        case exponent
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(modulo.value, forKey: .modulo)
        try container.encode(exponent, forKey: .exponent)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let moduloValue = try container.decode(RSA.UInteger.self, forKey: .modulo)
        self.modulo = try RSA.GreaterThanOne(moduloValue)
        self.exponent = try container.decode(RSA.UInteger.self, forKey: .exponent)
    }
}

fileprivate enum RSAKeysProtocolCodingKeys: String, CodingKey {
    case privateP = "prime_p"
    case privateQ = "prime_q"
}

extension RSAKeysProtocol {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RSAKeysProtocolCodingKeys.self)
        try container.encode(primes.p.value, forKey: .privateP)
        try container.encode(primes.q.value, forKey: .privateQ)
    }
}

extension UIntRSAKeys {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RSAKeysProtocolCodingKeys.self)
        let pValue = try container.decode(RSA.UInteger.self, forKey: .privateP)
        let privateP = try RSA.GreaterThanOne(pValue)
        let qValue = try container.decode(RSA.UInteger.self, forKey: .privateQ)
        let privateQ = try RSA.GreaterThanOne(qValue)
        try self.init(privateP: privateP, privateQ: privateQ)
    }
}

extension ECBEncryptedData {
    enum CodingKeys: String, CodingKey {
        case blocks
        case encryptionExponent = "exponent"
    }
}

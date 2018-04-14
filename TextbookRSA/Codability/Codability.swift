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

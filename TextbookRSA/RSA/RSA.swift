//
//  RSA.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

/// A namespace for RSA functions and types.
public enum RSA {}

extension RSA: RSAProtocol {
    public typealias UInteger = UInt
    public typealias Keys = RSAKeys
    
    public static func transform(_ block: UInteger, with parameters: TransformationParameters) -> UInteger {
        return block.power(parameters.exponent, modulo: parameters.modulo.positive)
    }
}

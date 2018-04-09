//
//  RSA.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

/// A namespace for RSA functions and types.
enum RSA {}

extension RSA: RSAProtocol {
    typealias UInteger = UInt
    typealias Keys = RSAKeys
    
    static func transform(_ block: UInteger, with parameters: TransformationParameters) -> UInteger {
        return 0 // TODO
    }
}

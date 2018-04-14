//
//  Errors.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

enum Error: Swift.Error {
    case math(MathError)
    case rsa(RSAError)
    
    enum MathError {
        case positiveFromLessThanOrEqualToZero
        case greaterThanOneFromLessThanOrEqualToOne
    }
    
    enum RSAError {
        case invalidPrivateKeys
    }
}

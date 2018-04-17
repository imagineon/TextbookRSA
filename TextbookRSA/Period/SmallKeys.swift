//
//  SmallKeys.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 17.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension UIntRSAKeys {
    public static func small(maxPrime: UInt32) -> UIntRSAKeys {
        var result: UIntRSAKeys?
        let count = (maxPrime >= 3) ? try! Math.Positive(maxPrime - 1) : try! Math.Positive(2) // We need at least a count of 2 to generate valid keys.
        
        repeat {
            let privateP = UInt.randomPrimeInRange(min: 2, count: count)
            let privateQ = UInt.randomPrimeInRange(min: 2, count: count)
            
            result = try? UIntRSAKeys(privateP: privateP, privateQ: privateQ)
        } while result == nil
        
        return result!
    }
}

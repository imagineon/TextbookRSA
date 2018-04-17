//
//  Prime.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension Math {
    /**
     Base implementation of primality check. Can be overloaded for custom integer types
     (for example with variable bit width, for real-world encryption).
    */
    static func isPrime<Value: UnsignedInteger>(_ value: Value) -> Bool {
        guard value > 1 else {
            return false
        }
        
        var divisor = Value(2)
        while divisor * divisor <= value {
            guard value % divisor != 0 else {
                return false
            }
            
            divisor += 1
        }
        
        return true
    }
}

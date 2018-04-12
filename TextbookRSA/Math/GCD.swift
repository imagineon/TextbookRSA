//
//  GCD.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 12.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension Math {
    /**
     Use Euclid's algorithm to compute the greatest common divisor of two integers.
     
     - returns: The greatest common divisor of `x` and `y` if there is one, i.e., if
     at least one of them is different of zero. If both `x` and `y` are zero, there
     is no greatest common divisor, so `nil` is returned.
     */
    static func gcd<Value: UnsignedInteger>(_ x: Value, _ y: Value) -> Value? {
        guard x != 0 || y != 0 else {
            return nil
        }

        var dividend: Value = max(x, y)
        var divisor: Value = min(x, y)

        while divisor != 0 {
            let remainder = dividend % divisor
            dividend = divisor
            divisor = remainder
        }

        return dividend
    }
    
    /**
     Check whether two integers are coprime (i.e. have no common non-trivial factors).
     
     - note: We consider 0 and 0 NOT to be coprime. That is, if `gcd(x, y) == nil`, we return `false`.
     */
    static func areCoprime<Value: UnsignedInteger>(_ x: Value, _ y: Value) -> Bool {
        return gcd(x, y) == 1
    }
}

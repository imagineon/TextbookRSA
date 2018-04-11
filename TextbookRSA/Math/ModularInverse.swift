//
//  ModularInverse.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public extension UnsignedInteger {
    /**
     Get the multiplicative inverse of this integer modulo `modulo`.
     
     - returns: A multiplicative modular inverse of this integer, if one exists, `nil` otherwise.
     */
    func inverse(modulo: Math.Positive<Self>) -> Self? {
        guard modulo.value != 1 else {
            return 0
        }

        var dividend = modulo.value
        var divisor = self % modulo.value
        var quotients = [Self]()

        while divisor != 0 {
            let (quotient, remainder) = dividend.quotientAndRemainder(dividingBy: divisor)
            dividend = divisor
            divisor = remainder
            quotients.append(quotient)
        }

        guard dividend == 1 else { return nil } // Below this point we know `quotients` is not empty.

        var oldCoefficient: Self = 0
        var coefficient: Self = 1

        for quotient in quotients.dropLast().reversed() {
            let tmp = coefficient
            coefficient = (oldCoefficient + (coefficient * quotient)) % modulo.value
            oldCoefficient = tmp
        }

        return ((quotients.count - 1) % 2 == 0) ? coefficient : modulo.value - coefficient
    }
}

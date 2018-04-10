//
//  ModularExponentiation.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public extension UnsignedInteger {
    /// Returns an array of length `end` where the `i`-th entry is `self^(2^i) (mod modulo)`
    private func binaryPowers(upTo end: UInt, modulo: Math.Positive<Self>) -> [Self] {
        guard end > 0 else { return [] }

        var currentPower = self % modulo.value
        var result = [currentPower]

        for _ in 1 ..< end {
            currentPower = (currentPower * currentPower) % modulo.value
            result.append(currentPower)
        }

        return result
    }

    public func power(_ exponent: Self, modulo: Math.Positive<Self>) -> Self {
        guard modulo.value != 1 else { return 0 }

        let exponentBits = exponent.base2()
        let powers = binaryPowers(upTo: UInt(exponentBits.count), modulo: modulo)
        var result = Self(1)

        for (index, bit) in exponentBits.enumerated() where bit == .one {
            result = (result * powers[index]) % modulo.value
        }

        return result
    }
}

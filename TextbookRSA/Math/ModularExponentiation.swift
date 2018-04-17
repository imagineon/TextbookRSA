//
//  ModularExponentiation.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension Math {
    /**
     This class efficiently computes modular exponentiation for unsigned integer types.
     Not only the computation of each individual power is efficient, but especially the
     bulk computation of different powers of the same base over the same ring (i.e. just
     with different exponents).
     
     If you wish to compute "b^e (mod m)" for fixed "b" and "m" but with many different "e",
     you should create and keep one such `PowerOracle` and use its `power` function, instead
     of calling `b.power(e, modulo: m)` each time.
     */
    class PowerOracle<Value: UnsignedInteger> {
        let base: Value
        let modulo: Math.Positive<Value>
        
        init(base: Value, modulo: Math.Positive<Value>) {
            self.base = base
            self.modulo = modulo
        }
        
        func power(exponent: Value) -> Value {
            guard modulo.value != 1 else { return 0 }

            var result = Value(1)
            
            let exponentBits = exponent.base2()
            ensureBinaryPowers(upTo: exponentBits.count)
            
            for (index, bit) in exponentBits.enumerated() where bit == .one {
                result = (result * binaryPowers[index]) % modulo.value
            }

            return result
        }
        
        // An array where the `i`-th entry is `base^(2^i) (mod modulo)`
        private var binaryPowers: [Value] = []
        
        private func appendNextBinaryPower() {
            let next: Value
            
            if let last = binaryPowers.last {
                next = (last * last) % modulo.value
            } else {
                next = base % modulo.value
            }
            
            binaryPowers.append(next)
        }
        
        private func ensureBinaryPowers(upTo count: Int) {
            while binaryPowers.count < count {
                appendNextBinaryPower()
            }
        }
    }
}

extension UnsignedInteger {
    func power(_ exponent: Self, modulo: Math.Positive<Self>) -> Self {
        let oracle = Math.PowerOracle<Self>(base: self, modulo: modulo)
        return oracle.power(exponent: exponent)
    }
}

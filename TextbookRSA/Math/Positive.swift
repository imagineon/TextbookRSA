//
//  Positive.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension Math {
    /// Wrapper around an integral value which guarantees the value is greater than 0.
    public struct Positive<Value: BinaryInteger> {
        let value: Value
        
        init(_ value: Value) throws {
            guard value > 0 else {
                throw Error.math(.positiveFromLessThanOrEqualToZero)
            }
            
            self.value = value
        }
        
        static func *(left: Positive, right: Positive) -> Positive<Value> {
            // Force try: We know that both values are positive numbers, so their product is also positive.
            return try! Positive(left.value * right.value)
        }
    }
    
    /// Wrapper around an integral value which guarantees the value is greater than 1.
    public struct GreaterThanOne<Value: BinaryInteger> {
        let value: Value
        
        init(_ value: Value) throws {
            guard value > 1 else {
                throw Error.math(.greaterThanOneFromLessThanOrEqualToOne)
            }
            
            self.value = value
        }
        
        var positive: Positive<Value> {
            return try! Positive(value)
        }
    }
}

extension UnsignedInteger {
    func usedBitWidth() -> Int {
        var exponent: Int = 0
        var powerOfTwo: Self = 1
        
        while powerOfTwo <= self {
            exponent += 1
            powerOfTwo <<= 1
        }
        
        return exponent
    }
}

extension Math.GreaterThanOne where Value: UnsignedInteger {
    func usedBitWidth() -> Math.GreaterThanOne<Int> {
        return try! Math.GreaterThanOne<Int>(value.usedBitWidth())
    }
}

//
//  Positive.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension Math {
    /// Wrapper around an unsigned integral value which guarantees the value is not 0.
    public struct Positive<Value: UnsignedInteger> {
        let value: Value
        
        init(_ value: Value) throws {
            guard value > 0 else {
                throw Error.math(.positiveFromZero)
            }
            
            self.value = value
        }
        
        static func *(left: Positive, right: Positive) -> Positive<Value> {
            // Force try: We know that both values are positive numbers, so their product is also positive.
            return try! Positive(left.value * right.value)
        }
    }
    
    public struct MoreThanOne<Value: UnsignedInteger> {
        let value: Value
        
        init(_ value: Value) throws {
            guard value > 1 else {
                throw Error.math(.moreThanOneFromZeroOrOne)
            }
            
            self.value = value
        }
        
        var positive: Positive<Value> {
            return try! Positive(value)
        }
        
        func usedBitWidth() -> MoreThanOne<UInt> {
            return try! MoreThanOne<UInt>(value.usedBitWidth())
        }
    }
}

extension UnsignedInteger {
    func usedBitWidth() -> UInt {
        var exponent: UInt = 0
        var powerOfTwo: UInt = 1
        
        while powerOfTwo <= self {
            exponent += 1
            powerOfTwo <<= 1
        }
        
        return exponent
    }
}

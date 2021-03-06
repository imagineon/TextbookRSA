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
    struct Positive<Value: BinaryInteger> {
        let value: Value
        
        init(_ value: Value) throws {
            guard value > 0 else {
                throw Error.invalidArguments
            }
            
            self.value = value
        }
        
        static func *(left: Positive, right: Positive) -> Positive<Value> {
            return try! Positive(left.value * right.value)
        }
    }
    
    /// Wrapper around an integral value which guarantees the value is greater than 1.
    public struct GreaterThanOne<Value: BinaryInteger>: Comparable, CustomStringConvertible {
        public let value: Value
        
        init(_ value: Value) throws {
            guard value > 1 else {
                throw Error.invalidArguments
            }
            
            self.value = value
        }
        
        var positive: Positive<Value> {
            return try! Positive(value)
        }
        
        var predecessor: Positive<Value> {
            return try! Positive(value - 1)
        }
        
        static func *(left: GreaterThanOne, right: GreaterThanOne) -> GreaterThanOne<Value> {
            return try! GreaterThanOne(left.value * right.value)
        }
        
        public static func <(lhs: Math.GreaterThanOne<Value>, rhs: Math.GreaterThanOne<Value>) -> Bool {
            return lhs.value < rhs.value
        }
        
        public static func ==(lhs: Math.GreaterThanOne<Value>, rhs: Math.GreaterThanOne<Value>) -> Bool {
            return lhs.value == rhs.value
        }
        
        public var description: String {
            return "\(value)"
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

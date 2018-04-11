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
            guard value != 0 else {
                throw Error.math(.positiveFromZero)
            }
            
            self.value = value
        }
        
        static func *(left: Positive, right: Positive) -> Positive<Value> {
            // Force try: We know that both values are positive numbers, so their product is also positive.
            return try! Positive(left.value * right.value)
        }
    }
}

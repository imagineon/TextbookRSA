//
//  Bit.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 10.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

enum Bit {
    case zero
    case one
}

/**
 Consider the array initialized as follows:
 ```
 let bits: [Bit] = [.zero, .zero, .one]
 ```
 In little-endian order, this array is the base-2 representation of the number
 0 * 2^0 + 0 * 2^1 + 1 * 2^2 = 4. In big-endian order, it is the base-2 representation
 of 0 * 2^2 + 0 * 2^1 + 1 * 2^0 = 1.
 
 In this framework we use the little-endian order by default.
 */
enum ByteOrder {
    case littleEndian
    case bigEndian
    
    /// The default byte-order used throughout this framework: Little-endian.
    static let `default` = littleEndian
}

extension UnsignedInteger {
    /// Get the base-2 representation of this number.
    func base2(byteOrder: ByteOrder = .default) -> [Bit] {
        var bits = [Bit]()
        var modified = self
        
        while modified != 0 {
            let newBit: Bit = (modified % 2 == 0) ? .zero : .one
            bits.append(newBit)
            modified /= 2
        }
        
        switch byteOrder {
        case .littleEndian:
            return bits
        case .bigEndian:
            return bits.reversed()
        }
    }
    
    /**
     Initialize an integer from its base-2 representation.
     
     - note: While the array of bits can be arbitrarily long, many implementations of `UnsignedInteger`
     have a maximum width. This initializer does not throw, but the resulting integer might be a different
     value than what the array of bits represents, if the array is too long. It is the user's
     responsibility to check that `bits` corresponds to an integral value that can be represented in
     type `Self`.
     */
    init(fromBase2 bits: [Bit], byteOrder: ByteOrder = .default) {
        let bitsLittleEndian: [Bit] = {
            switch byteOrder {
            case .littleEndian:
                return bits
            case .bigEndian:
                return bits.reversed()
            }
        }()
        
        var result = Self(0)
        
        for (index, bit) in bitsLittleEndian.enumerated() where bit == .one {
            result += (1 << index)
        }
        
        self.init(result)
    }
}

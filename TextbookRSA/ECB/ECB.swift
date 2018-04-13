//
//  ECB.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct ECB: ECBProtocol {
    public typealias Block = UInt
    
    let blockSize: Math.Positive<Int>
    
    public func chop(_ data: Data) -> [Block] {
        let bits = data.map { $0.base2() }.map { $0 + Array<Bit>(repeating: .zero, count: 8 - $0.count) }.joined()

        // We pad the array of bits on the back with a single `Bit.one`, followed by the smallest
        // number of `Bit.zero`s that is required to make the resulting array's count a multiple of `blockSize`.
        let countWithOne = bits.count + 1
        let remainder = countWithOne % blockSize.value
        let numZeros = (remainder == 0) ? 0 : (blockSize.value - remainder)
        let padded = bits + [Bit.one] + Array<Bit>(repeating: .zero, count: numZeros)
        
        // Then we slice the padded array of bits into slices of size exactly `blockSize`.
        let slices = stride(from: 0, to: padded.count, by: blockSize.value).map { index in
            Array(padded[index ..< index + blockSize.value])
        }
        
        // And finally convert each slice into an integer again.
        return slices.map { UInt(fromBase2: $0) }
    }
    
    public func reconstruct(_ blocks: [Block]) -> Data? {
        return nil // TODO
    }
}

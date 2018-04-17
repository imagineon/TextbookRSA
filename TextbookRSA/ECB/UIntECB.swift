//
//  UIntECB.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

struct UIntECB: ECBProtocol {
    typealias Block = UInt
    
    let blockSize: Math.Positive<Int>
    
    func chop(_ data: Data) -> [Block] {
        let bits = data.map { $0.base2() }.map { $0 + Array<Bit>(repeating: .zero, count: 8 - $0.count) }.joined()

        // We pad the array of bits on the back with a single `Bit.one`, followed by the smallest
        // number of `Bit.zero`s that is required to make the resulting array's count a multiple of `blockSize`.
        let countWithOne = bits.count + 1
        let remainder = countWithOne % blockSize.value
        let numZeros = (remainder == 0) ? 0 : (blockSize.value - remainder)
        let padded = bits + [Bit.one] + Array<Bit>(repeating: .zero, count: numZeros)
        
        // Then we slice the padded array of bits into slices of size exactly `blockSize`.
        let slices = padded.slice(chunkSize: blockSize.value)
        
        // And finally convert each slice into an integer again.
        return slices.map { UInt(fromBase2: $0) }
    }
    
    func reconstruct(_ blocks: [Block]) -> Data? {
        // If any of the blocks uses more than `blockSize` bits in its base-2 representation,
        // these blocks were not created using `UIntECB.chop` with the same `blockSize`.
        let maxBlock = (1 << blockSize.value)
        guard blocks.first(where: { $0 >= maxBlock }) == nil else { return nil }
        
        let padded = Array(blocks.map { $0.base2() }.map { $0 + Array<Bit>(repeating: .zero, count: blockSize.value - $0.count) }.joined())
        
        // If there is no bit equal to 1, or if the last 1 is followed by more than `blockSize - 1` many 0s,
        // these blocks were not created using `UIntECB.chop` with the same `blockSize`.
        guard let lastOne = padded.index(ofLast: .one), padded.count - lastOne <= blockSize.value else { return nil }
        
        // If after removing the padding the length of the remaining array of bits is not a multiple of 8,
        // these blocks were not created using `UIntECB.chop`.
        let bits = Array(padded[0 ..< lastOne])
        guard bits.count % 8 == 0 else { return nil }
        
        let slices = bits.slice(chunkSize: 8)
        
        return Data(bytes: slices.map { UInt8(fromBase2: $0) })
    }
}

extension Array where Element == Bit {
    func slice(chunkSize: Int) -> [[Bit]] {
        return stride(from: 0, to: count, by: chunkSize).map { index in
            Array(self[index ..< index + chunkSize])
        }
    }
    
    func index(ofLast bit: Bit) -> Index? {
        return reversed().index(of: bit).map({ count - ($0 + 1) })
    }
}

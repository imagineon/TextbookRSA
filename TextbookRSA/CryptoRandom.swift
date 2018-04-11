//
//  CryptoRandom.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 11.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

extension UInt {
    /// This implementation uses `arc4random_uniform`, so we require the range to contain at most `UInt32.max` elements.
    /// - note: The range is viewed as open (i.e. it does not contain `min + count`).
    static func randomInOpenRange(min: UInt, count: Math.Positive<UInt32>) -> UInt {
        let maxAllowedRangeCount = UInt.max - min
        let usedCount = (UInt(count.value) <= maxAllowedRangeCount) ? count.value : UInt32(maxAllowedRangeCount)
        let randomPositionInRange = UInt(arc4random_uniform(usedCount))
        
        return min + randomPositionInRange
    }
}

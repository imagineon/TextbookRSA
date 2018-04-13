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
    
    let blockSize: UInt
    
    public func chop(_ data: Data) -> [Block] {
        return [] // TODO
    }
    
    public func reconstruct(_ blocks: [Block]) -> Data? {
        return nil // TODO
    }
}

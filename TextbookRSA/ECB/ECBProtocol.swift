//
//  ECBProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 13.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public protocol ECBProtocol {
    associatedtype Block
    
    func chop(_ data: Data) -> [Block]
    func reconstruct(_ blocks: [Block]) -> Data?
}

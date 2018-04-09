//
//  RSAProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct RSATransformationParameters<RSA: RSAProtocol> {
    let modulo: RSA.UInteger
    let exponent: RSA.UInteger
}

public protocol RSAKeysProtocol {
    associatedtype RSA: RSAProtocol
    
    var `private`: (p: RSA.Prime, q: RSA.Prime) { get }
    var `public`: RSA.UInteger { get }
    
    init()
    init(privateP: RSA.Prime, privateQ: RSA.Prime)
    
    func generateEncryptionParameters() -> RSA.TransformationParameters
    func generateDecryptionParameters(for encryptionParameters: RSA.TransformationParameters) -> RSA.TransformationParameters
}

public protocol RSAProtocol {
    associatedtype UInteger: UnsignedInteger
    typealias Prime = Math.Prime<UInteger>
    
    associatedtype Keys: RSAKeysProtocol where Keys.RSA == Self
    
    typealias TransformationParameters = RSATransformationParameters<Self>
    static func transform(_ block: UInteger, with parameters: TransformationParameters) -> UInteger
}

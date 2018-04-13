//
//  RSAProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct RSATransformationParameters<RSA: RSAProtocol> {
    let modulo: RSA.GreaterThanOne
    let exponent: RSA.UInteger
}

public protocol RSAKeysProtocol {
    associatedtype RSA: RSAProtocol
    
    /// The two (secret) prime factors of the public key.
    var `private`: (p: RSA.Prime, q: RSA.Prime) { get }
    var `public`: RSA.GreaterThanOne { get }
    
    /// Generate key-pair by choosing prime factors randomly.
    init()
    
    /// Initialize key-pair for given prime factors.
    init(privateP: RSA.Prime, privateQ: RSA.Prime) throws
    
    /// Generate parameters for encryption by randomly choosing a suitable exponent.
    func generateEncryptionParameters() -> RSA.TransformationParameters
    
    /// Generate parameters for decryption by inverting the given `encryptionExponent` (modulo the Euler totient of the public key), if possible.
    func generateDecryptionParameters(forEncryptionExponent encryptionExponent: RSA.UInteger) -> RSA.TransformationParameters?
}

public protocol RSAProtocol {
    associatedtype UInteger: UnsignedInteger
    typealias Prime = Math.Prime<UInteger>
    typealias Positive = Math.Positive<UInteger>
    typealias GreaterThanOne = Math.GreaterThanOne<UInteger>
    
    associatedtype Keys: RSAKeysProtocol where Keys.RSA == Self
    
    typealias TransformationParameters = RSATransformationParameters<Self>
    
    /// Apply modular exponentiation to the block (exponent and modulo are in the parameters). Used for both encryption and decryption.
    static func transform(_ block: UInteger, with parameters: TransformationParameters) -> UInteger
}

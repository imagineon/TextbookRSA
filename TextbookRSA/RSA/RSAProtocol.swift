//
//  RSAProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct RSATransformationParameters<RSA: RSAProtocol>: Codable {
    public let modulo: RSA.GreaterThanOne
    public let exponent: RSA.UInteger
}

public protocol RSAKeysProtocol: Codable, Equatable {
    associatedtype RSA: RSAProtocol
    
    /// The two (secret) prime factors of the public key.
    var `private`: (p: RSA.GreaterThanOne, q: RSA.GreaterThanOne) { get }
    var `public`: RSA.GreaterThanOne { get }
    
    /// Generate key-pair by choosing prime factors randomly.
    init()
    
    /// Generate parameters for encryption by randomly choosing a suitable exponent.
    func generateEncryptionParameters() -> RSA.TransformationParameters
}

extension RSAKeysProtocol {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return (lhs.private.p == rhs.private.p && lhs.private.q == rhs.private.q) ||
            (lhs.private.p == rhs.private.q && lhs.private.q == rhs.private.p)
    }
}

public protocol RSAProtocol {
    associatedtype UInteger: UnsignedInteger, Codable
    typealias GreaterThanOne = Math.GreaterThanOne<UInteger>
    associatedtype Keys: RSAKeysProtocol where Keys.RSA == Self
    typealias TransformationParameters = RSATransformationParameters<Self>
}

extension RSAProtocol {
    typealias Positive = Math.Positive<UInteger>
}

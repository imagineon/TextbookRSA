//
//  RSAProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct RSATransformationParameters<RSA: RSAProtocol>: Codable, Equatable, CustomStringConvertible {
    public let modulo: RSA.GreaterThanOne
    public let exponent: RSA.UInteger
}

extension RSATransformationParameters {
    public static func ==(lhs: RSATransformationParameters, rhs: RSATransformationParameters) -> Bool {
        return (lhs.modulo == rhs.modulo && lhs.exponent == rhs.exponent)
    }
    
    public var description: String {
        return "RSATransformationParameters(modulo: \(modulo), exponent: \(exponent))"
    }
}

public protocol RSAKeysProtocol: Codable, Equatable, CustomStringConvertible {
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
    
    public var description: String {
        return "RSAKeys(primes: (p: \(self.private.p), q: \(self.private.q)))"
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

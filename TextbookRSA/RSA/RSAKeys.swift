//
//  RSAKeys.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

fileprivate extension Math {
    static func eulerTotient<Value>(_ prime: Math.Prime<Value>) -> Math.Positive<Value> {
        return try! Math.Positive(prime.value - 1)
    }
}

fileprivate extension RSAKeysProtocol {
    var eulerTotient: RSA.Positive {
        return Math.eulerTotient(self.private.p) * Math.eulerTotient(self.private.q)
    }
}

fileprivate extension Math.Prime where Value == UInt {
    static func randomInRange(min: UInt, count: Math.Positive<UInt32>) -> Math.Prime<UInt> {
        while true {
            let value = UInt.randomInRange(min: min, count: count)
            
            if let prime = try? Math.Prime(value) {
                return prime
            }
        }
    }
}

public struct RSAKeys: RSAKeysProtocol {
    public typealias RSA = TextbookRSA.RSA
    
    public let `private`: (p: RSA.Prime, q: RSA.Prime)
    
    public var `public`: RSA.Positive {
        return self.private.p.positive * self.private.q.positive
    }
    
    public init() {
        var privateP: RSA.Prime
        var privateQ: RSA.Prime
        
        repeat {
            let minP = UInt(2)
            let maxP = RSAKeys.smallestPrimeFactorUpperBound
            privateP = RSA.Prime.randomInRange(min: minP, count: try! Math.Positive<UInt32>(UInt32(maxP - minP)))
            
            let minQ = privateP.value + 1
            let maxQ = RSAKeys.publicKeyUpperBound / privateP.value
            privateQ = RSA.Prime.randomInRange(min: minQ, count: try! Math.Positive<UInt32>(UInt32(maxQ - minQ)))
        } while !RSAKeys.areValidPrivateKeys(privateP: privateP, privateQ: privateQ)

        self.private = (p: privateP, q: privateQ)
    }
    
    public init(privateP: RSA.Prime, privateQ: RSA.Prime) throws {
        guard RSAKeys.areValidPrivateKeys(privateP: privateP, privateQ: privateQ) else {
            throw Error.rsa(.invalidPrivateKeys)
        }
        
        self.private = (p: privateP, q: privateQ)
    }
    
    public func generateEncryptionParameters() -> RSA.TransformationParameters {
        var exponent: UInt
        let totient = eulerTotient.value
        let halfTotient = try! Math.Positive<UInt32>(UInt32(totient / 2))
        
        repeat {
            // We know that `totient` is an even number, and we want `exponent` to be coprime with it, so it
            // needs to be odd. That's why we restrict our search to the odd numbers `1, 3, ... , totient - 1`.
            let random = UInt.randomInRange(min: 0, count: halfTotient)
            exponent = (2 * random) + 1
        } while !Math.areCoprime(exponent, totient)
        
        return RSA.TransformationParameters(modulo: self.public, exponent: exponent)
    }
    
    public func generateDecryptionParameters(forEncryptionExponent encryptionExponent: RSA.UInteger) -> RSA.TransformationParameters? {
        return encryptionExponent.inverse(modulo: eulerTotient).map { decryptionExponent in
            RSA.TransformationParameters(modulo: self.public, exponent: decryptionExponent)
        }
    }
    
    /// The public key must be less than or equal to the square root of `UInt.max`. This makes sure the multiplications
    /// inside `UInt.power(...)` do not overflow. We also have the guarantee that this bound is representable as UInt32.
    static let publicKeyUpperBound: UInt = {
        let halfBitWidth = UInt.bitWidth / 2
        let tooMuch = UInt(1) << halfBitWidth
        return tooMuch - 1
    }()
    
    /// At least one of the two prime factors of the public key must be less than the square root of the upper bound for
    /// the public key, so this square root can be used to restrict our search for one of the prime factors.
    static let smallestPrimeFactorUpperBound: UInt =  {
        let quarterBitWidth = UInt.bitWidth / 4
        let tooMuch = UInt(1) << quarterBitWidth
        return tooMuch - 1
    }()
    
    private static func areValidPrivateKeys(privateP: RSA.Prime, privateQ: RSA.Prime) -> Bool {
        // First check: The primes must be distinct.
        guard privateP.value != privateQ.value else { return false }
        
        // Second check: The public key is small enough.
        guard privateP.value * privateQ.value <= publicKeyUpperBound else { return false }
        
        return true
    }
}

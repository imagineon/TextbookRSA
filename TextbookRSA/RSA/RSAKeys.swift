//
//  RSAKeys.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 09.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

fileprivate extension RSAKeysProtocol {
    var eulerTotient: RSA.Positive {
        return self.private.p.predecessor * self.private.q.predecessor
    }
}

public struct RSAKeys: RSAKeysProtocol {
    public typealias RSA = TextbookRSA.RSA
    
    public let `private`: (p: RSA.GreaterThanOne, q: RSA.GreaterThanOne)
    
    public var `public`: RSA.GreaterThanOne {
        return self.private.p * self.private.q
    }
    
    public init() {
        var privateP: RSA.GreaterThanOne
        var privateQ: RSA.GreaterThanOne
        
        repeat {
            let minP = UInt(2)
            let maxP = RSAKeys.smallestPrimeFactorUpperBound
            privateP = UInt.randomPrimeInRange(min: minP, count: try! Math.Positive(UInt32(maxP - minP)))
            
            let minQ = privateP.value + 1
            let maxQ = RSAKeys.publicKeyUpperBound / privateP.value
            privateQ = UInt.randomPrimeInRange(min: minQ, count: try! Math.Positive(UInt32(maxQ - minQ)))
        } while !RSAKeys.areValidPrivateKeys(privateP: privateP, privateQ: privateQ)

        self.private = (p: privateP, q: privateQ)
    }
    
    public init(privateP: RSA.GreaterThanOne, privateQ: RSA.GreaterThanOne) throws {
        guard RSAKeys.areValidPrivateKeys(privateP: privateP, privateQ: privateQ) else {
            throw Error.rsa(.invalidPrivateKeys)
        }
        
        self.private = (p: privateP, q: privateQ)
    }
    
    public func generateEncryptionParameters() -> RSA.TransformationParameters {
        var exponent: UInt
        let totient = eulerTotient.value
        let halfTotient = try! Math.Positive(UInt32(totient / 2))
        
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
    
    private static func areValidPrivateKeys(privateP: RSA.GreaterThanOne, privateQ: RSA.GreaterThanOne) -> Bool {
        // First check: The primes must be distinct.
        guard privateP.value != privateQ.value else { return false }
        
        // Second check: The public key is small enough.
        guard privateP.value * privateQ.value <= publicKeyUpperBound else { return false }
        
        return true
    }
}

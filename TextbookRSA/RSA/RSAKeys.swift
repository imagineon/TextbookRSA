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
    static func randomInOpenRange(min: UInt, count: Math.Positive<UInt32>) -> Math.Prime<UInt> {
        while true {
            let value = UInt.randomInOpenRange(min: min, count: count)
            
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
        let randomPrime: () -> RSA.Prime = { return RSA.Prime.randomInOpenRange(min: 0, count: try! Math.Positive<UInt32>(UInt32.max)) }
        
        var privateP = randomPrime()
        var privateQ = randomPrime()
        
        while !RSAKeys.areValidPrivateKeys(privateP: privateP, privateQ: privateQ) {
            privateP = randomPrime()
            privateQ = randomPrime()
        }

        self.private = (p: privateP, q: privateQ)
    }
    
    public init(privateP: RSA.Prime, privateQ: RSA.Prime) throws {
        guard RSAKeys.areValidPrivateKeys(privateP: privateP, privateQ: privateQ) else {
            throw Error.rsa(.invalidPrivateKeys)
        }
        
        self.private = (p: privateP, q: privateQ)
    }
    
    public func generateEncryptionParameters() -> RSA.TransformationParameters {
        return RSA.TransformationParameters(modulo: try! RSA.Positive(1), exponent: 0) // TODO
    }
    
    public func generateDecryptionParameters(forEncryptionExponent encryptionExponent: RSA.UInteger) -> RSA.TransformationParameters? {
        return encryptionExponent.inverse(modulo: eulerTotient).map { decryptionExponent in
            RSA.TransformationParameters(modulo: self.public, exponent: decryptionExponent)
        }
    }
    
    private static func areValidPrivateKeys(privateP: RSA.Prime, privateQ: RSA.Prime) -> Bool {
        return privateP.value != privateQ.value
    }
}

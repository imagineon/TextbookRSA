//
//  PeriodOracle.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public enum PeriodOracle {}

extension PeriodOracle: PeriodOracleProtocol {
    public typealias UInteger = RSA.UInteger
    
    public static func period(of base: UInteger, modulo: Math.Positive<UInteger>) -> UInteger? {
        guard modulo.value != 1 && base != 1 else { return 1 }
        guard base != 0 else { return nil }
        
        let powerOracle = Math.PowerOracle<UInteger>(base: base, modulo: modulo)
        var foundPowers = Set<UInteger>()
        
        for exponent in 1 ..< modulo.value {
            let power = powerOracle.power(exponent: exponent)
            
            if power == 1 {
                return exponent
            } else if foundPowers.contains(power) {
                return nil
            } else {
                foundPowers.insert(power)
            }
        }
        
        return nil
    }
}

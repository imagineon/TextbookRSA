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
        guard modulo.value != 1 else { return 1 }
        return (1 ..< modulo.value).first { base.power($0, modulo: modulo) == 1 }
    }
}

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
    
    public static func period(of base: UInteger, modulo: Math.Positive<UInteger>) -> UInteger {
        return 0 // TODO
    }
}

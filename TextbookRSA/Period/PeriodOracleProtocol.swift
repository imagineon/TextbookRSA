//
//  PeriodOracleProtocol.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public protocol PeriodOracleProtocol {
    associatedtype UInteger: UnsignedInteger

    static func period(of base: UInteger, modulo: Math.Positive<UInteger>) -> UInteger?
}

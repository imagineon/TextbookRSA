//
//  PeriodDecrypter.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 14.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//

import Foundation

public struct PeriodDecrypter: DecrypterProtocol {
    public typealias RSA = TextbookRSA.RSA
    public typealias ECB = TextbookRSA.ECB
    
    public func decrypt(_ encryptedData: PeriodDecrypter.EncryptedData) -> Data? {
        return nil // TODO
    }
}

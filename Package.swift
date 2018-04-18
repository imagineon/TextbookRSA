//
//  Package.swift
//  TextbookRSA
//
//  Created by Tomás Silveira Salles on 18.04.18.
//  Copyright © 2018 ImagineOn GmbH. All rights reserved.
//
//  swift-tools-version:4.0
//

import PackageDescription

let package = Package(
    name: "TextbookRSA",
    exclude: [
        "TextbookRSATests",
        "TextbookRSA.xcworkspace",
        "TextbookRSA.playground"
    ]
)

//
//  Filters.swift
//  PixelFx
//
//  Created by SpexX on 10/01/16.
//  Copyright © 2016 Brian Pinsard. All rights reserved.
//

import UIKit

struct Filters {
    static let Sepia = "CISepiaTone"
    static let Vignette = "CIVignette"
    static let Invert = "CIColorInvert"
    static let Grayscale = "CIMaximumComponent"
    
    static let properties : [String : (inputKey: String, maxInputValue: Float)?] =
    [
        Sepia : (kCIInputIntensityKey, 1.0),
        Vignette : (kCIInputIntensityKey, 1.0),
        Invert: nil,
        Grayscale: nil
    ]
    
    static func getNames() -> [String] {
        return [String] (properties.keys)
    }
}

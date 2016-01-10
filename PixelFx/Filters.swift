//
//  Filters.swift
//  PixelFx
//
//  Created by SpexX on 10/01/16.
//  Copyright © 2016 Brian Pinsard. All rights reserved.
//

import UIKit

struct Filters {
    private static let DEFAULT_COLOR_PROPERTIES = (kCIInputIntensityKey, Float(1.0))
    private static let DEFAULT_BLUR_PROPERTIES = (kCIInputRadiusKey, Float(10.0))
    private static let DEFAULT_ANGULAR_PROPERTIES = (kCIInputAngleKey, Float(M_PI * 2))
    
    //Color
    static let SEPIA = "CISepiaTone"
    static let VIGNETTE = "CIVignette"
    static let INVERT = "CIColorInvert"
    static let HUE = "CIHueAdjust"
    //Premade
    static let CHROME = "CIPhotoEffectChrome"
    static let FADE = "CIPhotoEffectFade"
    static let INSTANT = "CIPhotoEffectInstant"
    static let NOIR = "CIPhotoEffectNoir"
    static let PROCESS = "CIPhotoEffectProcess"
    //Blurs
    static let BOX_BLUR = "CIBoxBlur"
    static let GAUSSIAN_BLUR = "CIGaussianBlur"
    static let MOTION_BLUR = "CIMotionBlur"
    //Weird...
    static let KALEIDOSCOPE = "CIKaleidoscope"
    
    static let properties : [String : (inputKey: String, maxInputValue: Float)?] =
    [
        SEPIA:                  DEFAULT_COLOR_PROPERTIES,
        VIGNETTE:               DEFAULT_COLOR_PROPERTIES,
        HUE:                    DEFAULT_ANGULAR_PROPERTIES,
        INVERT:                 nil,
        CHROME:                 nil,
        FADE:                   nil,
        INSTANT:                nil,
        NOIR:                   nil,
        PROCESS:                nil,
        BOX_BLUR:               DEFAULT_BLUR_PROPERTIES,
        GAUSSIAN_BLUR:          DEFAULT_BLUR_PROPERTIES,
        MOTION_BLUR:            DEFAULT_BLUR_PROPERTIES,
        KALEIDOSCOPE:           DEFAULT_ANGULAR_PROPERTIES,
    ]
    
    static func getNames() -> [String] {
        let filterNames = [String] (properties.keys)
        return filterNames.sort() { $0 < $1 }
    }
}

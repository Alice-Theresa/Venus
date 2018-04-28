//
//  Filter.swift
//  Venus
//
//  Created by S.C. on 2017/11/12.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation

enum FilterName: String {
    case Grayscale      = "Grayscale"
    case CrCbSkinDetect = "CrCb Skin Detect"
    case RGBSkinDetect  = "RGB Skin Detect"
    case Gradient       = "Gradient"
    
    case Gamma            = "Gamma"
    case Mosaic           = "Mosaic"
    case PolkaDot         = "Polka Dot"
    case GaussianBlur     = "Gaussian Blur"
    case FastGaussianBlur = "Fast Gaussian Blur"

    case BilateralFilter = "Bilateral Filter"
    case GuideFilter = "Guide Filter"
}

enum FilterFunction: String {
    case Grayscale      = "Grayscale"
    case CrCbSkinDetect = "CrCbSkinDetect"
    case RGBSkinDetect  = "RGBSkinDetect"
    case Gradient       = "Gradient"
    
    case Gamma                  = "Gamma"
    case Mosaic                 = "Mosaic"
    case PolkaDot               = "PolkaDot"
    case GaussianBlur           = "GaussianBlur"
    case FastGaussianBlurRow    = "FastGaussianBlurRow"
    case FastGaussianBlurColumn = "FastGaussianBlurColumn"
    
    case BilateralFilter = "BilateralFilter"
    case GuidedFilter = "GuidedFilter"
}

struct Filter {
    
    let filterName: FilterName
    let filterFunctions: [FilterFunction]
    let stepper: [StepperConfig]
    
}

struct StepperConfig {
    
    let minValue: Double
    let maxValue: Double
    let step: Double
    
}

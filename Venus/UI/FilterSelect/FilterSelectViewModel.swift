//
//  FilterSelectViewModel.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation

class FilterSelectViewModel {
    
    var sections: [FilterSelectSection]!
    
    init() {
        sections = [setupNoParam(), setupSingleParam(), setupTripleParam()]
    }
    
    func setupNoParam() -> FilterSelectSection {
        let GradientFilter = Filter(filterName: .Gradient,
                                     filterFunctions: [.Gradient],
                                     stepper: [])
        let Gradient = FilterSelectItem(title: .Gradient, filter: GradientFilter)
        
        let GrayscaleFilter = Filter(filterName: .Grayscale,
                                     filterFunctions: [.Grayscale],
                                     stepper: [])
        let Grayscale = FilterSelectItem(title: .Grayscale, filter: GrayscaleFilter)
        
        let RGBSkinDetectFilter = Filter(filterName: .RGBSkinDetect,
                                         filterFunctions: [.RGBSkinDetect],
                                         stepper: [])
        let RGBSkinDetect = FilterSelectItem(title: .RGBSkinDetect, filter: RGBSkinDetectFilter)
        
        let CrCbSkinDetectFilter = Filter(filterName: .CrCbSkinDetect,
                                          filterFunctions: [.CrCbSkinDetect],
                                          stepper: [])
        let CrCbSkinDetect = FilterSelectItem(title: .CrCbSkinDetect, filter: CrCbSkinDetectFilter)
        
        return FilterSelectSection(title: "No Input", items: [Gradient, Grayscale, RGBSkinDetect, CrCbSkinDetect], params: .NoParamVC)
    }
    
    func setupSingleParam() -> FilterSelectSection {
        let gammaFilter = Filter(filterName: .Gamma,
                                 filterFunctions: [.Gamma],
                                 stepper: [StepperConfig(minValue: 0, maxValue: 3, step: 0.2)])
        let gamma = FilterSelectItem(title: .Gamma, filter: gammaFilter)
        
        let mosaicFilter = Filter(filterName: .Mosaic,
                                  filterFunctions: [.Mosaic],
                                  stepper: [StepperConfig(minValue: 1, maxValue: 100, step: 10)])
        let mosaic = FilterSelectItem(title: .Mosaic, filter: mosaicFilter)
        
        let polkaDotFilter = Filter(filterName: .PolkaDot,
                                    filterFunctions: [.PolkaDot],
                                    stepper: [StepperConfig(minValue: 1, maxValue: 100, step: 10)])
        let polkaDot = FilterSelectItem(title: .PolkaDot, filter: polkaDotFilter)
        
        let gaussianBlurFilter = Filter(filterName: .GaussianBlur,
                                        filterFunctions: [.GaussianBlur],
                                        stepper: [StepperConfig(minValue: 1, maxValue: 51, step: 10)])
        let gaussianBlur = FilterSelectItem(title: .GaussianBlur, filter: gaussianBlurFilter)
        
        let fastGaussianBlurFilter = Filter(filterName: .FastGaussianBlur,
                                            filterFunctions: [.FastGaussianBlurRow, .FastGaussianBlurColumn],
                                            stepper: [StepperConfig(minValue: 1, maxValue: 201, step: 20)])
        let fastGaussianBlur = FilterSelectItem(title: .FastGaussianBlur, filter: fastGaussianBlurFilter)
        
        return FilterSelectSection(title: "Single Input", items: [gamma, mosaic, polkaDot, gaussianBlur, fastGaussianBlur], params: .SingleParamVC)
    }
    
    func setupTripleParam() -> FilterSelectSection {
        let bilateralFilter = Filter(filterName: .BilateralFilter,
                                     filterFunctions: [.BilateralFilter],
                                     stepper: [StepperConfig(minValue: 1, maxValue: 51, step: 10),
                                               StepperConfig(minValue: 1, maxValue: 100, step: 5),
                                               StepperConfig(minValue: 0.1, maxValue: 1, step: 0.2)])
        let bilateralBlur = FilterSelectItem(title: .BilateralFilter, filter: bilateralFilter)
        
        let guideFilter = Filter(filterName: .GuideFilter,
                                 filterFunctions: [.GuidedFilter],
                                 stepper: [StepperConfig(minValue: 1, maxValue: 51, step: 5),
                                           StepperConfig(minValue: 1, maxValue: 100, step: 5),
                                           StepperConfig(minValue: 0.01, maxValue: 0.2, step: 0.01)])
        let guideFilterBlur = FilterSelectItem(title: .GuideFilter, filter: guideFilter)
        
        return FilterSelectSection(title: "Triple Input", items: [bilateralBlur, guideFilterBlur], params: .TripleParamVC)
    }
    
}

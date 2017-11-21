//
//  FilterSelectViewModel.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation

class FilterSelectViewModel {
    
    let sections: [FilterSelectSection]
    
    init() {
        let RGBSkinDetectFilter = Filter(filterName: .RGBSkinDetect,
                                         filterFunctions: [.RGBSkinDetect],
                                         stepper: [])
        let RGBSkinDetect = FilterSelectItem(title: .RGBSkinDetect, filter: RGBSkinDetectFilter)
        
        let CrCbSkinDetectFilter = Filter(filterName: .CrCbSkinDetect,
                                          filterFunctions: [.CrCbSkinDetect],
                                          stepper: [])
        let CrCbSkinDetect = FilterSelectItem(title: .CrCbSkinDetect, filter: CrCbSkinDetectFilter)
        
        let mosaicFilter = Filter(filterName: .Mosaic,
                                  filterFunctions: [.Mosaic],
                                  stepper: [StepperConfig(minValue: 1, maxValue: 100, step: 10)])
        let mosaic = FilterSelectItem(title: .Mosaic, filter: mosaicFilter)
        
        let gaussianBlurFilter = Filter(filterName: .GaussianBlur,
                                        filterFunctions: [.GaussianBlur],
                                        stepper: [StepperConfig(minValue: 1, maxValue: 51, step: 10)])
        let gaussianBlur = FilterSelectItem(title: .GaussianBlur, filter: gaussianBlurFilter)
        
        let fastGaussianBlurFilter = Filter(filterName: .FastGaussianBlur,
                                            filterFunctions: [.FastGaussianBlurRow, .FastGaussianBlurColumn],
                                            stepper: [StepperConfig(minValue: 1, maxValue: 201, step: 20)])
        let fastGaussianBlur = FilterSelectItem(title: .FastGaussianBlur, filter: fastGaussianBlurFilter)
        
        let bilateralFilter = Filter(filterName: .BilateralFilter,
                                     filterFunctions: [.BilateralFilter],
                                     stepper: [StepperConfig(minValue: 1, maxValue: 51, step: 10),
                                               StepperConfig(minValue: 1, maxValue: 100, step: 5),
                                               StepperConfig(minValue: 0.1, maxValue: 1, step: 0.2)])
        let bilateralBlur = FilterSelectItem(title: .BilateralFilter, filter: bilateralFilter)

        let noInput = FilterSelectSection(title: "No Input", items: [RGBSkinDetect, CrCbSkinDetect], params: .NoParamVC)
        let singleInput = FilterSelectSection(title: "Single Input", items: [mosaic, gaussianBlur, fastGaussianBlur], params: .SingleParamVC)
        let tripleInput = FilterSelectSection(title: "Triple Input", items: [bilateralBlur], params: .TripleParamVC)
        
        sections = [noInput, singleInput, tripleInput]
    }
}

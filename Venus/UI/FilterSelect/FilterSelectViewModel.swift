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
                                         minValue: 1,
                                         maxValue: 201,
                                         step: 20)
        let RGBSkinDetect = FilterSelectItem(title: .RGBSkinDetect, filter: RGBSkinDetectFilter)
        
        let CrCbSkinDetectFilter = Filter(filterName: .CrCbSkinDetect,
                                          filterFunctions: [.CrCbSkinDetect],
                                          minValue: 1,
                                          maxValue: 201,
                                          step: 20)
        let CrCbSkinDetect = FilterSelectItem(title: .CrCbSkinDetect, filter: CrCbSkinDetectFilter)
        
        let mosaicFilter = Filter(filterName: .Mosaic,
                                  filterFunctions: [.Mosaic],
                                  minValue: 1,
                                  maxValue: 100,
                                  step: 10)
        let mosaic = FilterSelectItem(title: .Mosaic, filter: mosaicFilter)
        
        let gaussianBlurFilter = Filter(filterName: .GaussianBlur,
                                        filterFunctions: [.GaussianBlur],
                                        minValue: 1,
                                        maxValue: 51,
                                        step: 10)
        let gaussianBlur = FilterSelectItem(title: .GaussianBlur, filter: gaussianBlurFilter)
        
        let fastGaussianBlurFilter = Filter(filterName: .FastGaussianBlur,
                                            filterFunctions: [.FastGaussianBlurRow, .FastGaussianBlurColumn],
                                            minValue: 1,
                                            maxValue: 201,
                                            step: 20)
        let fastGaussianBlur = FilterSelectItem(title: .FastGaussianBlur, filter: fastGaussianBlurFilter)
        
        let bilateralFilter = Filter(filterName: .BilateralFilter,
                                            filterFunctions: [.BilateralFilter],
                                            minValue: 1,
                                            maxValue: 51,
                                            step: 10)
        let bilateralBlur = FilterSelectItem(title: .BilateralFilter, filter: bilateralFilter)
        
        let noInput = FilterSelectSection(title: "No Input", items: [RGBSkinDetect, CrCbSkinDetect])
        let singleInput = FilterSelectSection(title: "Single Input", items: [mosaic, gaussianBlur, fastGaussianBlur])
        let tripleInput = FilterSelectSection(title: "Triple Input", items: [bilateralBlur])
        
        sections = [noInput, singleInput, tripleInput]
    }
}

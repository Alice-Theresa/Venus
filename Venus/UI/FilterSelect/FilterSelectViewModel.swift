//
//  FilterSelectViewModel.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation

class FilterSelectViewModel {
    
//    let sections: [FilterSelectSection]
    let filters: [FilterSelectItem]
    
    init() {
        var temp: [FilterSelectItem] = []

        let mosaicFilter = Filter(filterName: .Mosaic,
                                  filterFunctions: [.Mosaic],
                                  minValue: 1,
                                  maxValue: 100,
                                  step: 10)
        let mosaic = FilterSelectItem(title: .Mosaic, filter: mosaicFilter)
        temp.append(mosaic)
        
        let gaussianBlurFilter = Filter(filterName: .GaussianBlur,
                                        filterFunctions: [.GaussianBlur],
                                        minValue: 1,
                                        maxValue: 51,
                                        step: 10)
        let gaussianBlur = FilterSelectItem(title: .GaussianBlur, filter: gaussianBlurFilter)
        temp.append(gaussianBlur)
        
        let fastGaussianBlurFilter = Filter(filterName: .FastGaussianBlur,
                                            filterFunctions: [.FastGaussianBlurRow, .FastGaussianBlurColumn],
                                            minValue: 1,
                                            maxValue: 201,
                                            step: 20)
        let fastGaussianBlur = FilterSelectItem(title: .FastGaussianBlur, filter: fastGaussianBlurFilter)
        temp.append(fastGaussianBlur)
        
        let RGBSkinDetectFilter = Filter(filterName: .RGBSkinDetect,
                                            filterFunctions: [.RGBSkinDetect],
                                            minValue: 1,
                                            maxValue: 201,
                                            step: 20)
        let RGBSkinDetect = FilterSelectItem(title: .RGBSkinDetect, filter: RGBSkinDetectFilter)
        temp.append(RGBSkinDetect)
        
        let CrCbSkinDetectFilter = Filter(filterName: .CrCbSkinDetect,
                                         filterFunctions: [.CrCbSkinDetect],
                                         minValue: 1,
                                         maxValue: 201,
                                         step: 20)
        let CrCbSkinDetect = FilterSelectItem(title: .CrCbSkinDetect, filter: CrCbSkinDetectFilter)
        temp.append(CrCbSkinDetect)
        
        let bilateralFilter = Filter(filterName: .BilateralFilter,
                                            filterFunctions: [.BilateralFilter],
                                            minValue: 1,
                                            maxValue: 51,
                                            step: 10)
        let bilateralBlur = FilterSelectItem(title: .BilateralFilter, filter: bilateralFilter)
        temp.append(bilateralBlur)
        
        filters = temp
    }
}

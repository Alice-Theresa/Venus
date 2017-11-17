//
//  FilterSelectViewModel.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation

class FilterSelectViewModel {
    
    let filters: [FilterSelectModel]
    
    init() {
        var temp: [FilterSelectModel] = []

        let mosaicFilter = Filter(filterName: .Mosaic,
                                  filterFunctions: [.Mosaic],
                                  minValue: 1,
                                  maxValue: 100,
                                  step: 10)
        let mosaic = FilterSelectModel(title: .Mosaic, filter: mosaicFilter)
        temp.append(mosaic)
        
        let gaussianBlurFilter = Filter(filterName: .GaussianBlur,
                                        filterFunctions: [.GaussianBlur],
                                        minValue: 1,
                                        maxValue: 51,
                                        step: 10)
        let gaussianBlur = FilterSelectModel(title: .GaussianBlur, filter: gaussianBlurFilter)
        temp.append(gaussianBlur)
        
        let fastGaussianBlurFilter = Filter(filterName: .FastGaussianBlur,
                                            filterFunctions: [.FastGaussianBlurRow, .FastGaussianBlurColumn],
                                            minValue: 1,
                                            maxValue: 201,
                                            step: 20)
        let fastGaussianBlur = FilterSelectModel(title: .FastGaussianBlur, filter: fastGaussianBlurFilter)
        temp.append(fastGaussianBlur)
        
        let bilateralFilter = Filter(filterName: .BilateralFilter,
                                            filterFunctions: [.BilateralFilter],
                                            minValue: 1,
                                            maxValue: 51,
                                            step: 10)
        let bilateralBlur = FilterSelectModel(title: .BilateralFilter, filter: bilateralFilter)
        temp.append(bilateralBlur)
        
        filters = temp
    }
}

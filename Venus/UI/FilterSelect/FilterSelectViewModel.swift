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
        
        let mosaicFilter = Filter(filterName: "Mosaic", minValue: 1, maxValue: 100, step: 10)
        let mosaic = FilterSelectModel(title: "Mosaic", filter: mosaicFilter)
        temp.append(mosaic)
        
        let gaussianBlurFilter = Filter(filterName: "GaussianBlur", minValue: 1, maxValue: 50, step: 5)
        let gaussianBlur = FilterSelectModel(title: "Gaussian Blur", filter: gaussianBlurFilter)
        temp.append(gaussianBlur)
        
        filters = temp
    }
}

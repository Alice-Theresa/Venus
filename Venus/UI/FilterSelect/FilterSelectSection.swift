//
//  FilterSelectSection.swift
//  Venus
//
//  Created by Theresa on 2017/11/20.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation

enum ParamNumberOfVC {
    case NoParamVC
    case SingleParamVC
    case TripleParamVC
}

struct FilterSelectSection {
    
    let title: String
    let items: [FilterSelectItem]
    let params: ParamNumberOfVC
    
}

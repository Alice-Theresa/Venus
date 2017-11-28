//
//  ProjectSelectViewModel.swift
//  Venus
//
//  Created by Theresa on 2017/11/28.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class ProjectSelectViewModel {

    let items: [ProjectSelectItem]
    
    init() {
        let imageProject = ProjectSelectItem(title: "Image Processing")
        let videoProject = ProjectSelectItem(title: "Video Processing")
        items = [ imageProject, videoProject ]
    }
    
}

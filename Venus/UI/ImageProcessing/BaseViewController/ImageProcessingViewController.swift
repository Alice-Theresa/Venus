//
//  ImageProcessingViewController.swift
//  Venus
//
//  Created by S.C. on 2017/11/20.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class ImageProcessingViewController: UIViewController {

    let metalManager = MetalManager.shared
    let queue = DispatchQueue(label: "com.image.processing")
    let filter: Filter
    
    lazy var pipelineState: [MTLComputePipelineState] = {
        var pipelines = [MTLComputePipelineState]()
        
        for filter in self.filter.filterFunctions {
            let function: MTLFunction! = self.metalManager.library.makeFunction(name: filter.rawValue)
            let pipelineState = try! self.metalManager.device.makeComputePipelineState(function: function)
            pipelines.append(pipelineState)
        }
        return pipelines
    }()
    
    let threadGroupCount = MTLSizeMake(16, 16, 1)
    lazy var threadGroups: MTLSize = {
        MTLSizeMake(Int(self.metalManager.inTexture.width) / self.threadGroupCount.width, Int(self.metalManager.inTexture.height) / self.threadGroupCount.height, 1)
    }()
    
    init(filter: Filter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
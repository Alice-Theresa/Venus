//
//  MetalManager.swift
//  Venus
//
//  Created by Theresa on 2017/11/17.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation
import Metal

class MetalManager {
    
    static let shared = MetalManager()
    
    let device: MTLDevice! = MTLCreateSystemDefaultDevice()
    
    lazy var commandQueue: MTLCommandQueue! = {
        return self.device.makeCommandQueue()
    }()
    
    lazy var library: MTLLibrary! = {
        return self.device.makeDefaultLibrary()
    }()
    
    var inTexture: MTLTexture!
    var tempTexture: MTLTexture!
    var outTexture: MTLTexture!
    
    private init() {
        
    }
    
}

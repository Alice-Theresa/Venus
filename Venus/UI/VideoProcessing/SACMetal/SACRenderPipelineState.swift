//
//  SACRenderPipelineState.swift
//  Venus
//
//  Created by Theresa on 2018/7/9.
//  Copyright © 2018年 Carolar. All rights reserved.
//

import Metal
import Foundation

enum SACRenderPipelineStateType: String {
    case mapping = "mapping"
    case grayscale = "grayscale"
    case gradient = "gradient"
}

class SACRenderPipelineState {
    
    static func createRenderPipelineState(type: SACRenderPipelineStateType) -> MTLRenderPipelineState {
        let vertex = type.rawValue + "Vertex"
        let fragment = type.rawValue + "Fragment"
        let library = SACMetalCenter.shared.device.makeDefaultLibrary()!
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.sampleCount = 1
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .invalid
        pipelineDescriptor.vertexFunction = library.makeFunction(name: vertex)
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: fragment)
        
        do {
            return try SACMetalCenter.shared.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed creating a render state pipeline. Can't render the texture without one.")
        }
    }
        
}

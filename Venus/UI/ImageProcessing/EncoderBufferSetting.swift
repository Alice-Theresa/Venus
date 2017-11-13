//
//  EncoderBufferSetting.swift
//  Venus
//
//  Created by Theresa on 2017/11/13.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import Foundation
import Metal

class EncoderBuffer {
    
    class func setting(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int, filter: FilterName) {
        
        switch filter {
        case .Mosaic:
            EncoderBuffer.mosaicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        case .GaussianBlur:
            EncoderBuffer.gaussianBlurBuffer(device: device, encoder: encoder, inputValue: inputValue)
        case .FastGaussianBlur:
            EncoderBuffer.fastGaussianBlurBuffer(device: device, encoder: encoder, inputValue: inputValue)
        default:
            break
        }
        
    }
    
    private class func basicBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        var input = inputValue
        let buffer = device.makeBuffer(bytes: &input, length: MemoryLayout<Int>.size, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 0)
    }
    
    private class func mosaicBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
    }
    
    private class func gaussianBlurBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        
        let radius = inputValue
        var sum: Float = 0
        var temp: Double = 0
        let sigma: Double = (Double(radius) * 2 + 1) / 2
        
        for x in stride(from: -radius, through: radius, by: 1) {
            for y in stride(from: radius, through: -radius, by: -1) {
                let ep: Double = -(pow(Double(x), 2) + pow(Double(y), 2)) / 2 / pow(sigma, 2)
                let res: Double = 0.159 / pow(sigma, 2) * exp(ep)
                temp = temp + res
            }
        }
        sum = Float(temp)
        let buffer2 = device.makeBuffer(bytes: &sum, length: MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer2, offset: 0, index: 1)
    }
    
    private class func fastGaussianBlurBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
    }
    
}

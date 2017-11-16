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
        case .BilateralFilter:
            EncoderBuffer.BilateralBuffer(device: device, encoder: encoder, inputValue: inputValue)
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
        let length = (radius * 2 + 1) * (radius * 2 + 1)
        var floatMatrix = MathsGenerator.Gaussian2DMatrix(radius: radius)
        
        let buffer = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 1)
    }
    
    private class func fastGaussianBlurBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        
        let radius = inputValue
        let length = (radius * 2 + 1)
        var floatMatrix = MathsGenerator.Gaussian1DMatrix(radius: radius)
        
        let buffer = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 1)
    }
    
    private class func BilateralBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        
        let sigmaD: Float = 10;
        let sigmaR: Float = 300;
        let coeD: Float = -0.5 / pow(sigmaD, 2);
        let coeR: Float = -0.5 / pow(sigmaR, 2);
        
        var floatlist = [Float]()
        for i in 0...255 {
            floatlist.append(exp(Float(i) * Float(i) * coeR))
        }
        
        let buffer1 = device.makeBuffer(bytes: &floatlist, length: MemoryLayout<Float>.size * 256, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer1, offset: 0, index: 1)
        
        
        let radius = inputValue
        let length = (radius * 2 + 1) * (radius * 2 + 1)
        var floatMatrix = [Float]()
        
        for x in stride(from: -radius, through: radius, by: 1) {
            for y in stride(from: radius, through: -radius, by: -1) {
                floatMatrix.append(exp((Float(x) * Float(x) + Float(y) * Float(y)) * coeD))
            }
        }
        let buffer2 = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer2, offset: 0, index: 2)
    }
    
}

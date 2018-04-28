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
    
    class func setting(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Double, filter: FilterName) {
        
        if case .Gamma = filter {
            EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: Float(inputValue))
        }
        if case .Mosaic = filter {
            EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: Float(inputValue))
        }
        if case .PolkaDot = filter {
            EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: Float(inputValue))
        }
        if case .GaussianBlur = filter {
            EncoderBuffer.gaussianBlurBuffer(device: device, encoder: encoder, inputValue: Float(inputValue))
        }
        if case .FastGaussianBlur = filter {
            EncoderBuffer.fastGaussianBlurBuffer(device: device, encoder: encoder, inputValue: Float(inputValue))
        }
        
    }
    
    class func setting(device: MTLDevice, encoder: MTLComputeCommandEncoder, input1: Double, input2: Double, input3: Double, filter: FilterName) {
        
        if case .BilateralFilter = filter {
            EncoderBuffer.BilateralBuffer(device: device, encoder: encoder, input1: Float(input1), input2: Float(input2), input3: Float(input3))
        }
        if case .GuideFilter = filter {
            EncoderBuffer.GuideBuffer(device: device, encoder: encoder, input1: Float(input1), input2: Float(input2), input3: Float(input3))
        }
    }
    
    // MARK: private
    
    private class func basicBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Float) {
        var radius = inputValue
        let buffer = device.makeBuffer(bytes: &radius, length: MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 0)
    }

    private class func gaussianBlurBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Float) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        
        let radius = inputValue
        let length: Int = Int(pow((radius * 2 + 1), 2))
        var floatMatrix = MathsGenerator.Gaussian2DMatrix(radius: radius)
        
        let buffer = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 1)
    }
    
    private class func fastGaussianBlurBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Float) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        
        let radius = inputValue
        let length = Int(radius * 2 + 1)
        var floatMatrix = MathsGenerator.Gaussian1DMatrix(radius: radius)
        
        let buffer = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 1)
    }
    
    private class func BilateralBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, input1: Float, input2: Float, input3: Float) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: input1)
        
        let sigmaR = input3  // 值域
        var coeR = -0.5 / pow(sigmaR, 2)
        
        let buffer1 = device.makeBuffer(bytes: &coeR, length: MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer1, offset: 0, index: 1)
        
        let radius = input1
        let length: Int = Int(pow((radius * 2 + 1), 2))
        var floatMatrix = MathsGenerator.Spatial2DMatrix(radius: input1, sigma: input2)  // 空间域
        
        let buffer2 = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer2, offset: 0, index: 2)
    }
    
    private class func GuideBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, input1: Float, input2: Float, input3: Float) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: input1)
        
        let sigmaR = input3  // 值域
        var coeR = -0.5 / pow(sigmaR, 2)
        
        let buffer1 = device.makeBuffer(bytes: &coeR, length: MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer1, offset: 0, index: 1)
    }
    
}

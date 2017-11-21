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
//        case .BilateralFilter:
//            EncoderBuffer.BilateralBuffer(device: device, encoder: encoder, input1: Int, input2: Int, input3: Int)
        default:
            break
        }
        
    }
    
    class func setting(device: MTLDevice, encoder: MTLComputeCommandEncoder, input1: Int, input2: Float, input3: Float, filter: FilterName) {
        switch filter {
        case .BilateralFilter:
            EncoderBuffer.BilateralBuffer(device: device, encoder: encoder, input1: input1, input2: input2, input3: input3)
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
    
    private class func BilateralBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, input1: Int, input2: Float, input3: Float) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: input1)
        
        let sigmaD: Float = input2  //10  空间域
        let sigmaR: Float = input3  //0.3  值域
        let coeD: Float = -0.5 / pow(sigmaD, 2)
        var coeR: Float = -0.5 / pow(sigmaR, 2)
        
        let buffer1 = device.makeBuffer(bytes: &coeR, length: MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer1, offset: 0, index: 1)
        
        
        let radius = input1
        let length = (radius * 2 + 1) * (radius * 2 + 1)
        var floatMatrix = [Float]()
        
        for x in (-radius)...radius {
            for y in (-radius)...radius {
                floatMatrix.append(exp((Float(x) * Float(x) + Float(y) * Float(y)) * coeD))
            }
        }
        let buffer2 = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer2, offset: 0, index: 2)
    }
    
}

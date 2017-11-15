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
        
        var sum: Double = 0
        var counter: Int = 0
        let sigma: Double = (Double(radius) * 2 + 1) / 2
        let length = (radius * 2 + 1) * (radius * 2 + 1)
        let coe = 1 / 2 / Double.pi
        let indexcoe = -1 / 2 / pow(sigma, 2)
        
        var doubleMatrix: [Double] = Array(repeating: 0, count: length)
        var floatMatrix: [Float] = Array(repeating: 0, count: length)
        
        for x in stride(from: -radius, through: radius, by: 1) {
            for y in stride(from: radius, through: -radius, by: -1) {
                let ep: Double = (pow(Double(x), 2) + pow(Double(y), 2)) * indexcoe
                let res: Double = coe / pow(sigma, 2) * exp(ep)
                sum = sum + res
                doubleMatrix[counter] = res
                counter += 1
            }
        }
        
        // normalization
        counter = 0
        for _ in 0..<length {
            floatMatrix[counter] = Float(doubleMatrix[counter] / sum)
            counter += 1
        }
        
        let buffer = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 1)
    }
    
    private class func fastGaussianBlurBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
        
        let radius = inputValue
        
        var sum: Double = 0
        var counter: Int = 0
        let sigma: Double = (Double(radius) * 2 + 1) / 2
        let length = (radius * 2 + 1)
        let coe = 1 / sqrt(2 * Double.pi)
        let indexcoe = -1 / 2 / pow(sigma, 2)
        
        var doubleMatrix: [Double] = Array(repeating: 0, count: length)
        var floatMatrix: [Float] = Array(repeating: 0, count: length)
        
        for x in stride(from: -radius, through: radius, by: 1) {
            let ep: Double = pow(Double(x), 2) * indexcoe
            let res: Double = coe / sigma * exp(ep)
            sum = sum + res
            doubleMatrix[counter] = res
            counter += 1
        }
        
        // normalization
        counter = 0
        for _ in 0..<length {
            floatMatrix[counter] = Float(doubleMatrix[counter] / sum)
            counter += 1
        }
        
        let buffer = device.makeBuffer(bytes: &floatMatrix, length: MemoryLayout<Float>.size * length, options: MTLResourceOptions.storageModeShared)
        encoder.setBuffer(buffer, offset: 0, index: 1)
    }
    
    private class func BilateralBuffer(device: MTLDevice, encoder: MTLComputeCommandEncoder, inputValue: Int) {
        EncoderBuffer.basicBuffer(device: device, encoder: encoder, inputValue: inputValue)
    }
    
    
}

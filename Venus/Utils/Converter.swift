//
//  Converter.swift
//  Venus
//
//  Created by Theresa on 2017/11/17.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit
import Metal
import MetalKit

class Converter {
    
    class func convert(texture: MTLTexture) -> UIImage {
        let bytesPerPixel = 4
        let bitsPerComponent = 8
        
        let imageByteCount = texture.width * texture.height * bytesPerPixel
        let bytesPerRow = texture.width * bytesPerPixel
        var src = [UInt8](repeating: 0, count: Int(imageByteCount))
        
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        texture.getBytes(&src, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &src,
                                width: texture.width,
                                height: texture.height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        
        let dstImageFilter = context?.makeImage()
        return UIImage(cgImage: dstImageFilter!, scale: 0.0, orientation: UIImageOrientation.up)
    }
    
    class func convert(image: UIImage, with device: MTLDevice) -> MTLTexture {
        
        guard let cgImage = image.cgImage else {
            fatalError("Can't open image \(image)")
        }
        
        let textureLoader = MTKTextureLoader(device: device)
        do {
            return try textureLoader.newTexture(cgImage: cgImage, options: nil)
        }
        catch {
            fatalError("Can't load texture")
        }
    }
    
}

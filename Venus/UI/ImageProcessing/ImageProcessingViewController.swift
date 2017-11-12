//
//  ImageProcessingViewController.swift
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit
import Metal
import MetalKit

class ImageProcessingViewController: UIViewController {
    
    // Metal
    let device: MTLDevice! = MTLCreateSystemDefaultDevice()
    
    lazy var commandQueue: MTLCommandQueue! = {
        return self.device.makeCommandQueue()
    }()
    
    lazy var library: MTLLibrary! = {
        return self.device.makeDefaultLibrary()
    }()
    
    lazy var pipelineState: MTLComputePipelineState = {
        let function: MTLFunction! = self.library.makeFunction(name: self.filter.filterName)
        let pipelineState = try! self.device.makeComputePipelineState(function: function)
        return pipelineState
    }()
    
    var inTexture: MTLTexture!
    var outTexture: MTLTexture!
    
    let bytesPerPixel = 4
    let threadGroupCount = MTLSizeMake(16, 16, 1)
    
    lazy var threadGroups: MTLSize = {
        MTLSizeMake(Int(self.inTexture.width) / self.threadGroupCount.width, Int(self.inTexture.height) / self.threadGroupCount.height, 1)
    }()
    
    // UI
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    let queue = DispatchQueue(label: "com.image.processing")
    let filter: Filter
    var pixelSize: Int = 1
//    var sum: Float = 0
    
    lazy var dimmingView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.center = view.center
        indicatorView.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
        indicatorView.startAnimating()
        view.addSubview(indicatorView)
        return view
    }()
    
    init(filter: Filter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
        title = filter.filterName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        
        stepper.maximumValue = filter.maxValue
        stepper.minimumValue = filter.minValue
        stepper.stepValue = filter.step
        
        let image = UIImage(named: "Beauty.JPG")!
        inTexture = texture(from: image)
    }

    @IBAction func changeValue(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            pixelSize = Int(stepper.value)
            valueLabel.text = "\(pixelSize)"
            UIApplication.shared.keyWindow?.addSubview(dimmingView)
            queue.async {
                self.applyFilter()
                let finalResult = self.image(from: self.outTexture)
                DispatchQueue.main.async {
                    self.dimmingView.removeFromSuperview()
                    self.imageView.image = finalResult
                }
            }
        }
    }
    
    func applyFilter() {
        let commandBuffer: MTLCommandBuffer! = commandQueue.makeCommandBuffer()
        let commandEncoder: MTLComputeCommandEncoder! = commandBuffer.makeComputeCommandEncoder()!
        
        commandEncoder.setComputePipelineState(pipelineState)
        commandEncoder.setTexture(inTexture, index: 0)
        commandEncoder.setTexture(outTexture, index: 1)
        
        let buffer = device.makeBuffer(bytes: &pixelSize, length: MemoryLayout<UInt>.size, options: MTLResourceOptions.storageModeShared)
        commandEncoder.setBuffer(buffer, offset: 0, index: 0)
        
        var sum: Float = 0
        var temp: Double = 0
        let sigma: Double = (Double(pixelSize) * 2 + 1) / 2
        
        for x in stride(from: -pixelSize, through: pixelSize, by: 1) {
            for y in stride(from: pixelSize, through: -pixelSize, by: -1) {
                let ep: Double = -(pow(Double(x), 2) + pow(Double(y), 2)) / 2 / pow(sigma, 2)
                let res: Double = 0.159 / pow(sigma, 2) * exp(ep)
                temp = temp + res
            }
        }
        sum = Float(temp)
        let buffer2 = device.makeBuffer(bytes: &sum, length: MemoryLayout<Float>.size, options: MTLResourceOptions.storageModeShared)
        commandEncoder.setBuffer(buffer2, offset: 0, index: 1)
        
        commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
        commandEncoder.endEncoding()
        
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
    
    func texture(from image: UIImage) -> MTLTexture {
        
        guard let cgImage = image.cgImage else {
            fatalError("Can't open image \(image)")
        }
        
        let textureLoader = MTKTextureLoader(device: self.device)
        do {
            let textureOut = try textureLoader.newTexture(cgImage: cgImage, options: nil)
            let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: textureOut.pixelFormat, width: textureOut.width, height: textureOut.height, mipmapped: false)
            outTexture = self.device.makeTexture(descriptor: textureDescriptor)
            return textureOut
        }
        catch {
            fatalError("Can't load texture")
        }
    }
    
    func image(from texture: MTLTexture) -> UIImage {
        
        let imageByteCount = texture.width * texture.height * bytesPerPixel
        let bytesPerRow = texture.width * bytesPerPixel
        var src = [UInt8](repeating: 0, count: Int(imageByteCount))
        
        let region = MTLRegionMake2D(0, 0, texture.width, texture.height)
        texture.getBytes(&src, bytesPerRow: bytesPerRow, from: region, mipmapLevel: 0)
        
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.noneSkipFirst.rawValue))
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        let context = CGContext(data: &src,
                                width: texture.width,
                                height: texture.height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo.rawValue)
        
        let dstImageFilter = context?.makeImage()
        
        return UIImage(cgImage: dstImageFilter!, scale: 0.0, orientation: UIImageOrientation.left)
    }
}

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
    let metalManager = MetalManager.shared
    
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
    
    // UI
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    let queue = DispatchQueue(label: "com.image.processing")
    let filter: Filter
    var pixelSize: Int = 1
    
    init(filter: Filter) {
        self.filter = filter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        title = filter.filterName.rawValue
        stepper.maximumValue = filter.maxValue
        stepper.minimumValue = filter.minValue
        stepper.stepValue = filter.step
        
//        let image = UIImage(named: "IMG_0227.jpg")!
        let image = UIImage(named: "Beauty.jpg")!
        imageView.image = image
        metalManager.inTexture = Converter.convert(image: image, with: metalManager.device)
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: metalManager.inTexture.pixelFormat,
                                                                         width: metalManager.inTexture.width,
                                                                         height: metalManager.inTexture.height,
                                                                         mipmapped: false)
        metalManager.outTexture = metalManager.device.makeTexture(descriptor: textureDescriptor)
    }

    @IBAction func changeValue(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            pixelSize = Int(stepper.value)
            valueLabel.text = "半径: \(pixelSize)"
            ActivityIndicatorWindow.show()
            queue.async {
                self.applyFilter()
                let finalResult = Converter.convert(texture: self.metalManager.outTexture)
                DispatchQueue.main.async {
                    ActivityIndicatorWindow.hide()
                    self.imageView.image = finalResult
                }
            }
        }
    }
    
    func applyFilter() {
        metalManager.tempTexture = metalManager.inTexture
        for singleState in pipelineState {
            let commandBuffer: MTLCommandBuffer! = metalManager.commandQueue.makeCommandBuffer()
            let commandEncoder: MTLComputeCommandEncoder! = commandBuffer.makeComputeCommandEncoder()!
            
            commandEncoder.setComputePipelineState(singleState)
            commandEncoder.setTexture(metalManager.tempTexture, index: 0)
            commandEncoder.setTexture(metalManager.outTexture, index: 1)
            
            EncoderBuffer.setting(device: metalManager.device, encoder: commandEncoder, inputValue: pixelSize, filter: filter.filterName)
            
            commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
            commandEncoder.endEncoding()
            
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            metalManager.tempTexture = metalManager.outTexture
        }
        metalManager.outTexture = metalManager.tempTexture
    }

}

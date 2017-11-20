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

class SingleParamImageProcessingVC: ImageProcessingViewController {
    
    // UI
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var pixelSize: Int = 1
    
    override init(filter: Filter) {
        super.init(filter: filter)
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
        let start = Date()
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
        print(Date().timeIntervalSince(start))
    }

}

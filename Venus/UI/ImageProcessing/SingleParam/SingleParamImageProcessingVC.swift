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
    
    let image = UIImage(named: "Beauty.jpg")!
    var pixelSize: Double = 1
    
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
        stepper.maximumValue = filter.stepper[0].maxValue
        stepper.minimumValue = filter.stepper[0].minValue
        stepper.stepValue = filter.stepper[0].step
        
        imageView.image = image
        inTexture = Converter.convert(image: image, with: device)
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: inTexture.pixelFormat,
                                                                         width: inTexture.width,
                                                                         height: inTexture.height,
                                                                         mipmapped: false)
        outTexture = device.makeTexture(descriptor: textureDescriptor)
    }

    @IBAction func changeValue(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            pixelSize = stepper.value
            valueLabel.text = "radius: \(pixelSize)"
            ActivityIndicatorWindow.show()
            queue.async {
                self.applyFilter()
                let finalResult = Converter.convert(texture: self.outTexture)
                DispatchQueue.main.async {
                    ActivityIndicatorWindow.hide()
                    self.imageView.image = finalResult
                }
            }
        }
    }
    
    func applyFilter() {
        let start = Date()
        tempTexture = inTexture
        for singleState in pipelineState {
            let commandBuffer: MTLCommandBuffer! = commandQueue.makeCommandBuffer()
            let commandEncoder: MTLComputeCommandEncoder! = commandBuffer.makeComputeCommandEncoder()!
            
            commandEncoder.setComputePipelineState(singleState)
            commandEncoder.setTexture(tempTexture, index: 0)
            commandEncoder.setTexture(outTexture, index: 1)
            
            EncoderBuffer.setting(device: device, encoder: commandEncoder, inputValue: pixelSize, filter: filter.filterName)
            
            commandEncoder.dispatchThreadgroups(threadGroups, threadsPerThreadgroup: threadGroupCount)
            commandEncoder.endEncoding()
            
            commandBuffer.commit()
            commandBuffer.waitUntilCompleted()
            tempTexture = outTexture
        }
        outTexture = tempTexture
        print(Date().timeIntervalSince(start))
    }

}

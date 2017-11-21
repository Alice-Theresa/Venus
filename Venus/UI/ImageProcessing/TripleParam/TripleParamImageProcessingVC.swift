//
//  TripleParamImageProcessingVC.swift
//  Venus
//
//  Created by S.C. on 2017/11/20.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class TripleParamImageProcessingVC: ImageProcessingViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var valueLabel1: UILabel!
    @IBOutlet weak var valueLabel2: UILabel!
    @IBOutlet weak var valueLabel3: UILabel!
    @IBOutlet weak var stepper1: UIStepper!
    @IBOutlet weak var stepper2: UIStepper!
    @IBOutlet weak var stepper3: UIStepper!
    
    let image = UIImage(named: "Beauty.jpg")!
    var input1: Int = 1
    var input2: Float = 1
    var input3: Float = 1
    
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
        stepper1.maximumValue = filter.stepper[0].maxValue
        stepper1.minimumValue = filter.stepper[0].minValue
        stepper1.stepValue = filter.stepper[0].step
        
        stepper2.maximumValue = filter.stepper[1].maxValue
        stepper2.minimumValue = filter.stepper[1].minValue
        stepper2.stepValue = filter.stepper[1].step
        
        stepper3.maximumValue = filter.stepper[2].maxValue
        stepper3.minimumValue = filter.stepper[2].minValue
        stepper3.stepValue = filter.stepper[2].step
        
        imageView.image = image
        inTexture = Converter.convert(image: image, with: device)
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: inTexture.pixelFormat,
                                                                         width: inTexture.width,
                                                                         height: inTexture.height,
                                                                         mipmapped: false)
        outTexture = device.makeTexture(descriptor: textureDescriptor)
    }
    
    @IBAction func changeValue1(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            input1 = Int(stepper.value)
            valueLabel1.text = "radius: \(input1)"
            imageProcessing()
        }
    }
    
    @IBAction func changeValue2(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            input2 = Float(stepper.value)
            valueLabel2.text = "σ D: \(input2)"
            imageProcessing()
        }
    }
    
    @IBAction func changeValue3(_ sender: Any) {
        if let stepper = sender as? UIStepper {
            input3 = Float(stepper.value)
            valueLabel3.text = "σ R: \(input3)"
            imageProcessing()
        }
    }
    
    func imageProcessing() {
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
    
    func applyFilter() {
        let start = Date()
        tempTexture = inTexture
        for singleState in pipelineState {
            let commandBuffer: MTLCommandBuffer! = commandQueue.makeCommandBuffer()
            let commandEncoder: MTLComputeCommandEncoder! = commandBuffer.makeComputeCommandEncoder()!
            
            commandEncoder.setComputePipelineState(singleState)
            commandEncoder.setTexture(tempTexture, index: 0)
            commandEncoder.setTexture(outTexture, index: 1)
            
            EncoderBuffer.setting(device: device, encoder: commandEncoder, input1: input1, input2: input2, input3: input3, filter: filter.filterName)
            
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

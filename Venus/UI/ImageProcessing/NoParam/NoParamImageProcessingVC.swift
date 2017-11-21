//
//  NoParamImageProcessingVC.swift
//  Venus
//
//  Created by S.C. on 2017/11/20.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit

class NoParamImageProcessingVC: ImageProcessingViewController {

    @IBOutlet weak var imageView: UIImageView!
    let image = UIImage(named: "Beauty.jpg")!
    
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
        
        imageView.image = image
        inTexture = Converter.convert(image: image, with: device)
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: inTexture.pixelFormat,
                                                                         width: inTexture.width,
                                                                         height: inTexture.height,
                                                                         mipmapped: false)
        outTexture = device.makeTexture(descriptor: textureDescriptor)
    }

    @IBAction func filterSwitch(_ sender: Any) {
        if let switcher = sender as? UISwitch {
            if switcher.isOn {
                ActivityIndicatorWindow.show()
                queue.async {
                    self.applyFilter()
                    let finalResult = Converter.convert(texture: self.outTexture)
                    DispatchQueue.main.async {
                        ActivityIndicatorWindow.hide()
                        self.imageView.image = finalResult
                    }
                }
            } else {
                imageView.image = image
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

//
//  VideoProcessingViewController.swift
//  Venus
//
//  Created by Theresa on 2017/11/28.
//  Copyright © 2017年 Carolar. All rights reserved.
//

import UIKit
import MetalKit
import MetalPerformanceShaders

class VideoProcessingViewController: UIViewController {

    @IBOutlet weak var mtkView: MTKView!
    
    let device = MTLCreateSystemDefaultDevice()!
    var commandQueue: MTLCommandQueue!
    var sourceTexture: MTLTexture?
    
    lazy var videoProvider: VideoProvider? = {
        return VideoProvider(device: self.device, delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMetal()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoProvider?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoProvider?.stopRunning()
    }

    private func setupMetal() {
        commandQueue = device.makeCommandQueue()
        
        mtkView.framebufferOnly = false
        mtkView.isPaused = true
        mtkView.delegate = self
        mtkView.device = device
        mtkView.colorPixelFormat = .bgra8Unorm
    }
}

extension VideoProcessingViewController: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    func draw(in view: MTKView) {
        guard
            let currentDrawable = mtkView.currentDrawable,
            let sourceTexture = sourceTexture else { return }

        let commandBuffer = commandQueue.makeCommandBuffer()!
        let destinationTexture = currentDrawable.texture
        
        let gaussian = MPSImageGaussianBlur(device: device, sigma: 10.0)
        gaussian.encode(commandBuffer: commandBuffer,
                        sourceTexture: sourceTexture,
                        destinationTexture: destinationTexture)

        commandBuffer.present(currentDrawable)
        commandBuffer.commit()
    }
}

extension VideoProcessingViewController: VideoProviderDelegate {
    
    func videoProvider(_: VideoProvider, didProvideTexture texture: MTLTexture) {
        sourceTexture = texture
        mtkView.draw()
    }
    
}

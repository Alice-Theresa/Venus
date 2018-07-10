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
    
    let device = SACMetalCenter.shared.device
    var commandQueue = SACMetalCenter.shared.commandQueue
    var sourceTexture: MTLTexture?
    
    lazy var videoProvider: VideoProvider? = {
        return VideoProvider(device: self.device, delegate: self)
    }()
    
    lazy var grayPipelineState: MTLRenderPipelineState = {
        return SACRenderPipelineState.createRenderPipelineState(type: .grayscale)
    }()
    
    lazy var gradientPipelineState: MTLRenderPipelineState = {
        return SACRenderPipelineState.createRenderPipelineState(type: .gradient)
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
        SACMetalCenter.shared.renderingSize = CGSize(width: 1080.0, height: 1920.0)
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
        SACMetalCenter.shared.filters = [.grayscale, .gradient]
        SACMetalCenter.shared.render(sourceTexture: sourceTexture!, renderView: mtkView)
    }
}

extension VideoProcessingViewController: VideoProviderDelegate {
    
    func videoProvider(_: VideoProvider, didProvideTexture texture: MTLTexture) {
        sourceTexture = texture
        mtkView.draw()
    }
    
}

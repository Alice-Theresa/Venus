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
    
    lazy var pipelineState: MTLRenderPipelineState = {
        let library = device.makeDefaultLibrary()!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.sampleCount = 1
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .invalid
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "mapTexture")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "displayTexture")
        
        do {
            return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed creating a render state pipeline. Can't render the texture without one.")
        }
    }()
    
    lazy var grayPipelineState: MTLRenderPipelineState = {
        let library = device.makeDefaultLibrary()!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.sampleCount = 1
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.depthAttachmentPixelFormat = .invalid
        pipelineDescriptor.vertexFunction = library.makeFunction(name: "grayscaleVertex")
        pipelineDescriptor.fragmentFunction = library.makeFunction(name: "grayscaleFragment")
        
        do {
            return try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("Failed creating a render state pipeline. Can't render the texture without one.")
        }
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
            let currentRenderPassDescriptor = mtkView.currentRenderPassDescriptor,
            let currentDrawable = mtkView.currentDrawable,
            let sourceTexture = sourceTexture,
            let commandBuffer = device.makeCommandQueue()?.makeCommandBuffer(),
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: currentRenderPassDescriptor)
            else { return }
        
        encoder.pushDebugGroup("RenderFrame")
        encoder.setRenderPipelineState(pipelineState)
        
        encoder.setRenderPipelineState(grayPipelineState)
        
        encoder.setFragmentTexture(sourceTexture, index: 0)
        encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4, instanceCount: 1)
        encoder.popDebugGroup()
        encoder.endEncoding()
        
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

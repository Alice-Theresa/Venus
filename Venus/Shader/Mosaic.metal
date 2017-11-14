//
//  Mosaic.metal
//  Venus
//
//  Created by Theresa on 2017/11/10.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void Mosaic(texture2d<float, access::read> inTexture [[texture(0)]],
                   texture2d<float, access::write> outTexture [[texture(1)]],
                   device unsigned int *pixelSize [[buffer(0)]],
                   uint2 gid [[thread_position_in_grid]])
{
    const uint2 pixellateGrid = uint2((gid.x / pixelSize[0]) * pixelSize[0], (gid.y / pixelSize[0]) * pixelSize[0]);
    const float4 colorAtPixel = inTexture.read(pixellateGrid);
    outTexture.write(colorAtPixel, gid);
}


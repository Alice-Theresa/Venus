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
                   device float *input [[buffer(0)]],
                   uint2 gid [[thread_position_in_grid]])
{
    const short radius = input[0];
    const uint2 pixellateGrid = uint2((gid.x / radius) * radius, (gid.y / radius) * radius);
    const float4 colorAtPixel = inTexture.read(pixellateGrid);
    outTexture.write(colorAtPixel, gid);
}

kernel void PolkaDot(texture2d<float, access::read> inTexture [[texture(0)]],
                     texture2d<float, access::write> outTexture [[texture(1)]],
                     device float *input [[buffer(0)]],
                     uint2 gid [[thread_position_in_grid]])
{
    const short diameter = input[0];
    const uint ox = (gid.x / diameter) * diameter + 0.5 * diameter;
    const uint oy = (gid.y / diameter) * diameter + 0.5 * diameter;
    const uint2 pixellateGrid = uint2(ox, oy);
    float4 colorAtPixel;
    
    if (distance(float2(ox, oy), float2(gid.x, gid.y)) > 0.5 * diameter) {
        colorAtPixel = float4(0, 0, 0, 0);
    } else {
        colorAtPixel = inTexture.read(pixellateGrid);
    }
    outTexture.write(colorAtPixel, gid);
}

//
//  GuideFilter.metal
//  Venus
//
//  Created by Theresa on 2018/4/24.
//  Copyright © 2018年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void GuidedFilter(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         device float *input [[buffer(0)]],
                         uint2 gid [[thread_position_in_grid]])
{
    const short radius = input[0];
    const short size = (2 * radius + 1) * (2 * radius + 1);
    
    float4 mean = float4(0);
    float4 meanSquare = float4(0);
    
    for (short x = -radius; x <= radius; x++) {
        for (short y = -radius; y <= radius; y++) {
            float4 colorAtPixel = inTexture.read(ushort2(gid.x + x, gid.y + y));
            mean += colorAtPixel;
            meanSquare += colorAtPixel * colorAtPixel;
        }
    }
    mean /= size;
    meanSquare /= size;
    
    float4 v = meanSquare - mean * mean;
    float4 k = v / (v + 0.01);
    float4 fin = k * inTexture.read(gid) + (1.0 - k) * mean;
    
    outTexture.write(fin, gid);
}

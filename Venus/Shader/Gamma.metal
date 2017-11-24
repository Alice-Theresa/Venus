//
//  Gamma.metal
//  Venus
//
//  Created by Theresa on 2017/11/24.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void Gamma(texture2d<float, access::read> inTexture [[texture(0)]],
                  texture2d<float, access::write> outTexture [[texture(1)]],
                  device float *input [[buffer(0)]],
                  uint2 gid [[thread_position_in_grid]])
{
    const float gamma = input[0];
    float4 colorAtPixel = inTexture.read(gid);
    outTexture.write(float4(pow(colorAtPixel.rgb, gamma), 1), gid);
}

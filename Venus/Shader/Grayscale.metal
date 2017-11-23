//
//  Grayscale.metal
//  Venus
//
//  Created by Theresa on 2017/11/23.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void Grayscale(texture2d<float, access::read> inTexture [[texture(0)]],
                      texture2d<float, access::write> outTexture [[texture(1)]],
                      uint2 gid [[thread_position_in_grid]])
{
    // Gray = R*0.299 + G*0.587 + B*0.114
    const float3 coe = float3(0.299, 0.587, 0.114);
    
    float4 colorAtPixel = inTexture.read(gid);
    float gary = dot(coe, colorAtPixel.rgb);
    outTexture.write(float4(gary, gary, gary, 1), gid);
}

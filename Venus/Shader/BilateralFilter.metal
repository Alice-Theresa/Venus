//
//  BilateralFilter.metal
//  Venus
//
//  Created by Theresa on 2017/11/14.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
#include <metal_geometric>
using namespace metal;

kernel void BilateralFilter(texture2d<float, access::read> inTexture [[texture(0)]],
                            texture2d<float, access::write> outTexture [[texture(1)]],
                            device unsigned int *pixelSize [[buffer(0)]],
                            uint2 gid [[thread_position_in_grid]])
{
    const float sigmaD = 5;
    const float sigmaR = 5;
    const float coeD = -0.5 / pow(sigmaD, 2);
    const float coeR = -0.5 / pow(sigmaR, 2);
    
    const int radius = pixelSize[0];
    
    float3 result = float3(0, 0, 0);
    float3 sumW = 0;
    
    float color_weight[256 * 3];
    for (int i = 0; i < 256 * 3; i++) {
        color_weight[i] = exp(i * i * coeR);
    }
    
    for (float x = -radius; x <= radius; x++) {
        for (float y = radius; y >= -radius; y--) {
            
            float2 currentPoint = float2(gid.x + x, gid.y + y);
            float2 origin = float2(gid.x, gid.y);
            float4 originColor = inTexture.read(gid);
            float4 currentColor = inTexture.read(uint2(currentPoint));
            
            float expD = exp(distance_squared(float2(0, 0), float2(x, y)) * coeD);
            int expRr = abs(originColor.r - currentColor.r);
            int expRg = abs(originColor.g - currentColor.g);
            int expRb = abs(originColor.b - currentColor.b);
            
            int p = color_weight[expRr + expRg + expRb];
            
            float w = color_weight[p] * expD;
            sumW += w;
            result += float3(w * currentColor.x, w * currentColor.y, w * currentColor.z);
        }
    }
    float3 d = float3(result.xyz / sumW.xyz);
    outTexture.write(float4(d, 0), gid);
}

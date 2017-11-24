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
                            device float *input [[buffer(0)]],
                            device float *coe [[buffer(1)]],
                            device float *matrix [[buffer(2)]],
                            uint2 gid [[thread_position_in_grid]])
{
    const short radius = input[0];
    
    int counter = 0;
    float weightSum = 0;
    float3 colorSum = float3(0, 0, 0);
    float4 colorAtCenter = inTexture.read(gid);
    
    for (short x = -radius; x <= radius; x++) {
        for (short y = -radius; y <= radius; y++) {
            
            ushort2 pixel = ushort2(gid.x + x, gid.y + y);
            float4 colorAtPixel = inTexture.read(pixel);
            
//            float closeness = 1 - distance(colorAtPixel.xyz, colorAtCenter.xyz) / length(float3(1,1,1));  faster
            float closeness = exp(pow(distance(colorAtPixel.xyz, colorAtCenter.xyz), 2) * coe[0]);
            float spacial = matrix[counter];
            float weight = closeness * spacial;
            
            colorSum += colorAtPixel.rgb * weight;
            weightSum += weight;
            counter += 1;
        }
    }
    outTexture.write(float4((colorSum / weightSum), 0), gid);
}

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
                            device float *list [[buffer(1)]],
                            device float *matrix [[buffer(2)]],
                            uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    
    int counter = 0;
    float weightSum = 0;
    float3 colorSum = float3(0, 0, 0);
    float4 colorAtCenter = inTexture.read(gid);
    
    for (float x = -radius; x <= radius; x++) {
        for (float y = -radius; y <= radius; y++) {
            
            uint2 pixel = uint2(gid.x + x, gid.y + y);
            float4 colorAtPixel = inTexture.read(pixel);
            
            float closeness = 0.5 - distance(colorAtPixel.xyz, colorAtCenter.xyz) / length(float3(1,1,1));
            float res = matrix[counter];
            float weight = closeness * res;
            
            colorSum += colorAtPixel.rgb * weight;
            weightSum += weight;
            counter += 1;
        }
    }
    outTexture.write(float4((colorSum / weightSum), 0), gid);
}

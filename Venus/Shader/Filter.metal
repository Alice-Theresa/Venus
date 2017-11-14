//
//  Filter.metal
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

kernel void GaussianBlur(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         device unsigned int *pixelSize [[buffer(0)]],
                         device float *mat [[buffer(1)]],
                         uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    float3 secondSum = float3(0, 0, 0);
    
    int counter = 0;
    for (float x = -radius; x < radius + 1; x++) {
        for (float y = radius; y > -radius - 1; y--) {
            float res = mat[counter];
            uint2 loc = uint2(gid.x + x, gid.y + y);
            float4 colorAtPixel = inTexture.read(loc);
            secondSum = secondSum + colorAtPixel.rgb * res;
            counter += 1;
        }
    }
    outTexture.write(float4(secondSum, 0), gid);
}

kernel void FastGaussianBlurRow(texture2d<float, access::read> inTexture [[texture(0)]],
                                texture2d<float, access::write> outTexture [[texture(1)]],
                                device unsigned int *pixelSize [[buffer(0)]],
                                device float *list [[buffer(1)]],
                                uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    float3 sum = float3(0, 0, 0);
    
    int counter = 0;
    for (float x = -radius; x < radius + 1; x++) {
        float res = list[counter];
        uint2 loc = uint2(gid.x + x, gid.y);
        float4 colorAtPixel = inTexture.read(loc);
        sum = sum + colorAtPixel.rgb * res;
        counter += 1;
    }
    outTexture.write(float4(sum, 0), gid);
}

kernel void FastGaussianBlurColumn(texture2d<float, access::read> inTexture [[texture(0)]],
                                   texture2d<float, access::write> outTexture [[texture(1)]],
                                   device unsigned int *pixelSize [[buffer(0)]],
                                   device float *list [[buffer(1)]],
                                   uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    float3 sum = float3(0, 0, 0);
    
    int counter = 0;
    for (float y = -radius; y < radius + 1; y++) {
        float res = list[counter];
        uint2 loc = uint2(gid.x, gid.y + y);
        float4 colorAtPixel = inTexture.read(loc);
        sum = sum + colorAtPixel.rgb * res;
        counter += 1;
    }
    outTexture.write(float4(sum, 0), gid);
}

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
                         device float *total [[buffer(1)]],
                         uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    const float sigma = (radius * 2 + 1) / 2.0;
    const float index = -0.5 / pow(sigma, 2);
    const float sum = total[0];
    
    float3 secondSum = float3(0, 0, 0);
    
    for (float x = -radius; x < radius + 1; x++) {
        for (float y = radius; y > -radius - 1; y--) {
            float ep = (pow(x, 2) + pow(y, 2)) * index;
            float res = 0.159 / pow(sigma, 2) * exp(ep);
            uint2 loc = uint2(gid.x + x, gid.y + y);
            float4 colorAtPixel = inTexture.read(loc);
            secondSum = secondSum + colorAtPixel.rgb * res / sum;
        }
    }
    
    outTexture.write(float4(secondSum, 0), gid);
}

kernel void FastGaussianBlurRow(texture2d<float, access::read> inTexture [[texture(0)]],
                                texture2d<float, access::write> outTexture [[texture(1)]],
                                device unsigned int *pixelSize [[buffer(0)]],
                                uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    const float sigma = (radius * 2 + 1) / 2.0;
    const float index = -0.5 / pow(sigma, 2);
    const float coi = M_2_SQRTPI_F * M_SQRT1_2_F / 2.0;
    
    float3 XSum = float3(0, 0, 0);
    float sum = 0;
    
    for (float x = -radius; x < radius + 1; x++) {
        float ep = pow(x, 2) * index;
        float res = coi * sigma * exp(ep);
        sum = sum + res;
    }
    for (float x = -radius; x < radius + 1; x++) {
        float ep = pow(x, 2) * index;
        float res = coi * sigma * exp(ep);
        uint2 loc = uint2(gid.x + x, gid.y);
        float4 colorAtPixel = inTexture.read(loc);
        XSum = XSum + colorAtPixel.rgb * res / sum ;
        
    }
    outTexture.write(float4(XSum, 0), gid);
}

kernel void FastGaussianBlurColumn(texture2d<float, access::read> inTexture [[texture(0)]],
                                   texture2d<float, access::write> outTexture [[texture(1)]],
                                   device unsigned int *pixelSize [[buffer(0)]],
                                   uint2 gid [[thread_position_in_grid]])
{
    const int radius = pixelSize[0];
    const float sigma = (radius * 2 + 1) / 2.0;
    const float index = -0.5 / pow(sigma, 2);
    const float coi = M_2_SQRTPI_F * M_SQRT1_2_F / 2.0;
    
    float3 XSum = float3(0, 0, 0);
    float sum = 0;
    
    for (float x = -radius; x < radius + 1; x++) {
        float ep = pow(x, 2) * index;
        float res = coi * sigma * exp(ep);
        sum = sum + res;
    }
    for (float y = -radius; y < radius + 1; y++) {
        float ep = pow(y, 2) * index;
        float res = coi * sigma * exp(ep);
        uint2 loc = uint2(gid.x, gid.y + y);
        float4 colorAtPixel = inTexture.read(loc);
        XSum = XSum + colorAtPixel.rgb * res / sum ;
    }
    
    outTexture.write(float4(XSum, 0), gid);
}

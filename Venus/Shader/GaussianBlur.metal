//
//  GaussianBlur.metal
//  Venus
//
//  Created by Theresa on 2017/11/14.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void GaussianBlur(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         device unsigned int *input [[buffer(0)]],
                         device float *coeMatrix [[buffer(1)]],
                         uint2 gid [[thread_position_in_grid]])
{
    const short radius = input[0];
    float3 secondSum = float3(0, 0, 0);
    short counter = 0;
    
    for (short x = -radius; x <= radius; x++) {
        for (short y = -radius; y <= radius; y++)  {
            float gaussianCoe = coeMatrix[counter];
            ushort2 pixel = ushort2(gid.x + x, gid.y + y);
            float4 colorAtPixel = inTexture.read(pixel);
            secondSum += colorAtPixel.rgb * gaussianCoe;
            counter++;
        }
    }
    outTexture.write(float4(secondSum, 0), gid);
}

kernel void FastGaussianBlurRow(texture2d<float, access::read> inTexture [[texture(0)]],
                                texture2d<float, access::write> outTexture [[texture(1)]],
                                device unsigned int *input [[buffer(0)]],
                                device float *coeMatrix [[buffer(1)]],
                                uint2 gid [[thread_position_in_grid]])
{
    const short radius = input[0];
    float3 sum = float3(0, 0, 0);
    
    for (short x = -radius, counter = 0; x <= radius; x++, counter++) {
        float gaussianCoe = coeMatrix[counter];
        ushort2 pixel = ushort2(gid.x + x, gid.y);
        float4 colorAtPixel = inTexture.read(pixel);
        sum += colorAtPixel.rgb * gaussianCoe;
    }
    outTexture.write(float4(sum, 0), gid);
}

kernel void FastGaussianBlurColumn(texture2d<float, access::read> inTexture [[texture(0)]],
                                   texture2d<float, access::write> outTexture [[texture(1)]],
                                   device unsigned int *pixelSize [[buffer(0)]],
                                   device float *coeMatrix [[buffer(1)]],
                                   uint2 gid [[thread_position_in_grid]])
{
    const short radius = pixelSize[0];
    float3 sum = float3(0, 0, 0);
    
    for (short y = -radius, counter = 0; y <= radius; y++, counter++) {
        float gaussianCoe = coeMatrix[counter];
        ushort2 pixel = ushort2(gid.x, gid.y + y);
        float4 colorAtPixel = inTexture.read(pixel);
        sum += colorAtPixel.rgb * gaussianCoe;
    }
    outTexture.write(float4(sum, 0), gid);
}

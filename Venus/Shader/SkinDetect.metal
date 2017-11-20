//
//  SkinDetect.metal
//  Venus
//
//  Created by Theresa on 2017/11/20.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void RGBSkinDetect(texture2d<float, access::read> inTexture [[texture(0)]],
                          texture2d<float, access::write> outTexture [[texture(1)]],
                          uint2 gid [[thread_position_in_grid]])
{
    const float4 colorAtPixel = inTexture.read(gid);
    const float r = colorAtPixel.r;
    const float g = colorAtPixel.g;
    const float b = colorAtPixel.b;
    
// formula from <Human Skin Colour Clustering for Face Detection>
    float4 result;
    if ((r > 0.3752
         && g > 0.1569
         && b > 0.0784
         && (r - g) > 0.0588
         && r > b
         && max(max(r, g), b) - min(min(r, g), b) > 0.0588)
        ||
        (r > 0.8627
         && g > 0.8235
         && b > 0.6667
         && r > b
         && g > b
         && abs(r - g) < 0.0588))
    {
        result = float4(0, 1, 0, 1);
    } else {
        result = colorAtPixel;
    }
    outTexture.write(result, gid);
}

kernel void CrCbSkinDetect(texture2d<float, access::read> inTexture [[texture(0)]],
                           texture2d<float, access::write> outTexture [[texture(1)]],
                           uint2 gid [[thread_position_in_grid]])
{
    const float4 colorAtPixel = inTexture.read(gid);
    
    float3 cbFormula = float3(-0.148, -0.291, 0.439);
    float3 crFormula = float3(0.439, -0.368, -0.071);
    
    float Cb = dot(cbFormula, colorAtPixel.rgb * 255) + 128;
    float Cr = dot(crFormula, colorAtPixel.rgb * 255) + 128;
    
    float4 result;
    if (Cb > 77 && Cb < 127 && Cr > 133 && Cr < 173) {
        result = float4(0, 1, 0, 1);
    } else {
        result = colorAtPixel;
    }
    
    outTexture.write(result, gid);
}

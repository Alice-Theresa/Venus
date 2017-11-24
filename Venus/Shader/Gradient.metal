//
//  Gradient.metal
//  Venus
//
//  Created by Theresa on 2017/11/24.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void Gradient(texture2d<float, access::read> inTexture [[texture(0)]],
                     texture2d<float, access::write> outTexture [[texture(1)]],
                     uint2 gid [[thread_position_in_grid]])
{
    float3 gx = inTexture.read(ushort2(gid.x + 1, gid.y)).rgb - inTexture.read(ushort2(gid.x - 1, gid.y)).rgb;
    float3 gy = inTexture.read(ushort2(gid.x, gid.y + 1)).rgb - inTexture.read(ushort2(gid.x, gid.y - 1)).rgb;
    float3 gxy = sqrt(gx * gx + gy * gy);
    outTexture.write(float4(gxy, 1), gid);
}

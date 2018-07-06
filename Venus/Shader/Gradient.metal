//
//  Gradient.metal
//  Venus
//
//  Created by Theresa on 2017/11/24.
//  Copyright © 2017年 Carolar. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

typedef struct {
    float4 renderedCoordinate [[position]];
    float2 textureCoordinate;
} GradientMappingVertex;

kernel void Gradient(texture2d<float, access::read> inTexture [[texture(0)]],
                     texture2d<float, access::write> outTexture [[texture(1)]],
                     uint2 gid [[thread_position_in_grid]])
{
    float3 gx = inTexture.read(ushort2(gid.x + 1, gid.y)).rgb - inTexture.read(ushort2(gid.x - 1, gid.y)).rgb;
    float3 gy = inTexture.read(ushort2(gid.x, gid.y + 1)).rgb - inTexture.read(ushort2(gid.x, gid.y - 1)).rgb;
    float3 gxy = sqrt(gx * gx + gy * gy);
    outTexture.write(float4(gxy, 1), gid);
}

vertex GradientMappingVertex gradientVertex(unsigned int vertex_id [[ vertex_id ]]) {
    float4x4 renderedCoordinates = float4x4(float4( -1.0, -1.0, 0.0, 1.0 ),
                                            float4(  1.0, -1.0, 0.0, 1.0 ),
                                            float4( -1.0,  1.0, 0.0, 1.0 ),
                                            float4(  1.0,  1.0, 0.0, 1.0 ));
    
    float4x2 textureCoordinates = float4x2(float2( 0.0, 1.0 ),
                                           float2( 1.0, 1.0 ),
                                           float2( 0.0, 0.0 ),
                                           float2( 1.0, 0.0 ));
    GradientMappingVertex outVertex;
    outVertex.renderedCoordinate = renderedCoordinates[vertex_id];
    outVertex.textureCoordinate = textureCoordinates[vertex_id];
    
    return outVertex;
}

fragment half4 gradientFragment(GradientMappingVertex mappingVertex [[ stage_in ]],
                                 texture2d<float, access::sample> texture [[ texture(0) ]]) {
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    
    const float2 wStep = float2(1/1080.0, 0);
    const float2 hStep = float2(0, 1/1920.0);
    const float2 whStep = float2(1/1080.0, 1/1920.0);
    const float2 wnhStep = float2(1/1080.0, -1/1920.0);
    
    half4 s0 = half4(texture.sample(s, mappingVertex.textureCoordinate - wnhStep));
    half4 s1 = half4(texture.sample(s, mappingVertex.textureCoordinate + hStep));
    half4 s2 = half4(texture.sample(s, mappingVertex.textureCoordinate + whStep));
    half4 s3 = half4(texture.sample(s, mappingVertex.textureCoordinate - wStep));
    half4 s5 = half4(texture.sample(s, mappingVertex.textureCoordinate + wStep));
    half4 s6 = half4(texture.sample(s, mappingVertex.textureCoordinate - whStep));
    half4 s7 = half4(texture.sample(s, mappingVertex.textureCoordinate - hStep));
    half4 s8 = half4(texture.sample(s, mappingVertex.textureCoordinate + wnhStep));
    
    half4 sh = s2 + 2.0 * s5 + s8 - (s1 + 2.0 * s3 + s6);
    half4 sw = -(s0 + 2.0 * s1 + s2) + s6 + 2.0 * s7 + s8;
    half4 sobel = sqrt(sh * sh + sw * sw);
    
    return half4(sobel.rgb, 1);
}

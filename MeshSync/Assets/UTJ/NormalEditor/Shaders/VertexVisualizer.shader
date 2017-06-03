﻿Shader "Hidden/UTJ/MeshSync/VertexVisualizer" {
    Properties {
        [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("ZTest", Int) = 4
    }

CGINCLUDE
#include "UnityCG.cginc"

half4 _Color;
float _Size;
float4x4 _Transform;
StructuredBuffer<float3> _Points;

struct appdata
{
    float4 vertex : POSITION;
    UNITY_VERTEX_INPUT_INSTANCE_ID
};

struct v2f
{
    float4 vertex : SV_POSITION;
};

v2f vert(appdata v)
{
    UNITY_SETUP_INSTANCE_ID(v);

    float4 vertex = v.vertex;
#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
    vertex.xyz += _Points[unity_InstanceID];
#endif
    vertex = mul(mul(UNITY_MATRIX_VP, _Transform), vertex);

    v2f o;
    o.vertex = vertex;
    return o;
}

half4 frag(v2f v) : SV_Target
{
    return _Color;
}
ENDCG

    SubShader
    {
        Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" }
        ZTest [_ZTest]
        ZWrite OFF
        Blend SrcAlpha OneMinusSrcAlpha
        Lighting Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.5
            ENDCG
        }
    }
}

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tib/WaterPanner"
{
	Properties
	{
		_Speed("Speed", Float) = 1
		_TextureSample1("Texture Sample 1", 2D) = "white" {}
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		_WaterPower("Water Power", Float) = 1
		_StepValue("Step Value", Float) = 0.26
		_StepThreshHold("Step ThreshHold", Float) = 0.1
		_Color1("Color1", Color) = (0.2501335,0.7264151,0.7164745,0)
		_Color2("Color2", Color) = (0.004138493,0.5233507,0.8773585,0)
		_Speed2("Speed 2", Vector) = (0,0,0,0)
		_Speed1("Speed 1", Vector) = (0,0,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Unlit keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _Color1;
		uniform float4 _Color2;
		uniform float _WaterPower;
		uniform sampler2D _TextureSample1;
		uniform float _Speed;
		uniform float2 _Speed1;
		uniform sampler2D _TextureSample2;
		uniform float2 _Speed2;
		uniform float _StepValue;
		uniform float _StepThreshHold;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_7_0 = ( _Speed * _Time.y );
			float2 panner9 = ( temp_output_7_0 * _Speed1 + i.uv_texcoord);
			float2 panner10 = ( temp_output_7_0 * _Speed2 + i.uv_texcoord);
			float4 temp_cast_0 = (_StepValue).xxxx;
			float4 temp_cast_1 = (( _StepValue + _StepThreshHold )).xxxx;
			float4 clampResult19 = clamp( (float4( 0,0,0,0 ) + (( _WaterPower * tex2D( _TextureSample1, panner9 ) * tex2D( _TextureSample2, panner10 ) ) - temp_cast_0) * (float4( 1,1,1,0 ) - float4( 0,0,0,0 )) / (temp_cast_1 - temp_cast_0)) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
			float grayscale24 = Luminance(clampResult19.rgb);
			float4 lerpResult20 = lerp( _Color1 , _Color2 , grayscale24);
			o.Emission = lerpResult20.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
216;73;932;646;1327.979;-25.36826;1.356922;True;False
Node;AmplifyShaderEditor.RangedFloatNode;4;-1072.672,396.6943;Float;False;Property;_Speed;Speed;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;6;-1087.153,481.5056;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;3;-1032.6,213.2968;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-784.1049,455.6489;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-758.0721,321.1771;Float;False;Property;_Speed1;Speed 1;9;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1046.646,669.3779;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;27;-758.0717,709.2566;Float;False;Property;_Speed2;Speed 2;8;0;Create;True;0;0;False;0;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;10;-560.3511,574.2511;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.1,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;9;-516.3195,304.7246;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0.4,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-144.0822,881.9246;Float;False;Property;_StepValue;Step Value;4;0;Create;True;0;0;False;0;0.26;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;14;38.73868,259.9839;Float;False;Property;_WaterPower;Water Power;3;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-287.3327,554.4025;Float;True;Property;_TextureSample2;Texture Sample 2;2;0;Create;True;0;0;False;0;47799c280b4d51a4a924b2bfa04e76c1;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;16;-73.48876,1001.541;Float;False;Property;_StepThreshHold;Step ThreshHold;5;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-330.8499,274.0359;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;47799c280b4d51a4a924b2bfa04e76c1;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;17;248.1032,848.5893;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;13;241.6046,456.9445;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;18;484.8711,713.6781;Float;True;5;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;19;820.7506,711.8845;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;22;952.076,342.8393;Float;False;Property;_Color2;Color2;7;0;Create;True;0;0;False;0;0.004138493,0.5233507,0.8773585,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;950.115,154.5902;Float;False;Property;_Color1;Color1;6;0;Create;True;0;0;False;0;0.2501335,0.7264151,0.7164745,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;24;1077.039,704.4305;Float;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;1275.629,511.4791;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1573.249,349.4323;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;Tib/WaterPanner;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;7;0;4;0
WireConnection;7;1;6;2
WireConnection;10;0;8;0
WireConnection;10;2;27;0
WireConnection;10;1;7;0
WireConnection;9;0;3;0
WireConnection;9;2;26;0
WireConnection;9;1;7;0
WireConnection;12;1;10;0
WireConnection;11;1;9;0
WireConnection;17;0;15;0
WireConnection;17;1;16;0
WireConnection;13;0;14;0
WireConnection;13;1;11;0
WireConnection;13;2;12;0
WireConnection;18;0;13;0
WireConnection;18;1;15;0
WireConnection;18;2;17;0
WireConnection;19;0;18;0
WireConnection;24;0;19;0
WireConnection;20;0;21;0
WireConnection;20;1;22;0
WireConnection;20;2;24;0
WireConnection;0;2;20;0
ASEEND*/
//CHKSM=431D87DE31D8E1B6141B8BEB451DBBE540B1E261
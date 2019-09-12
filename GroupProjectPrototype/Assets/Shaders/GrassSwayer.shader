// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tib/GrassShader"
{
	Properties
	{
		_WindNoise("Wind Noise", 2D) = "white" {}
		_GrassWaveSpeed("Grass Wave Speed", Range( 0 , 5)) = 0
		_WindStrength("Wind Strength", Range( 0 , 5)) = 0
		_DiffuseMap("Diffuse Map", 2D) = "white" {}
		_VectorMap("VectorMap", 2D) = "white" {}
		_TilingVector("TilingVector", Vector) = (1,1,0,0)
		_NoiseColor("NoiseColor", Color) = (0.9339623,0.9154974,0.4273318,0)
		_NoiseMapOpacity("NoiseMapOpacity", Float) = 0.7
		_Falloff("Falloff", Float) = 17.08
		_FresnelBias("FresnelBias", Range( 0 , 0.5)) = 0.1
		_FresnelColor("Fresnel Color", Color) = (0.5580835,0.8113208,0.2104842,0)
		_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 4
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 4.6
		#define ASE_TEXTURE_PARAMS(textureName) textureName

		#pragma surface surf Standard keepalpha exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _WindNoise;
		uniform float _GrassWaveSpeed;
		uniform float _WindStrength;
		uniform sampler2D _DiffuseMap;
		uniform float4 _DiffuseMap_ST;
		uniform sampler2D _VectorMap;
		uniform float2 _TilingVector;
		uniform float _Falloff;
		uniform float _NoiseMapOpacity;
		uniform float4 _NoiseColor;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;


		inline float4 TriplanarSamplingSF( sampler2D topTexMap, float3 worldPos, float3 worldNormal, float falloff, float2 tiling, float3 normalScale, float3 index )
		{
			float3 projNormal = ( pow( abs( worldNormal ), falloff ) );
			projNormal /= ( projNormal.x + projNormal.y + projNormal.z ) + 0.00001;
			float3 nsign = sign( worldNormal );
			half4 xNorm; half4 yNorm; half4 zNorm;
			xNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.zy * float2( nsign.x, 1.0 ) ) );
			yNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xz * float2( nsign.y, 1.0 ) ) );
			zNorm = ( tex2D( ASE_TEXTURE_PARAMS( topTexMap ), tiling * worldPos.xy * float2( -nsign.z, 1.0 ) ) );
			return xNorm * projNormal.x + yNorm * projNormal.y + zNorm * projNormal.z;
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float4 GrassSpeed142 = ( _Time * _GrassWaveSpeed );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float2 uv_TexCoord146 = v.texcoord.xy + ( GrassSpeed142 + (ase_vertex3Pos).y ).xy;
			float3 ase_vertexNormal = v.normal.xyz;
			float3 temp_output_152_0 = ( ( tex2Dlod( _WindNoise, float4( uv_TexCoord146, 0, 1.0) ).r - 0.5 ) * ( ase_vertexNormal * _WindStrength ) );
			v.vertex.xyz += temp_output_152_0;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			o.Normal = float3(0,0,1);
			float2 uv_DiffuseMap = i.uv_texcoord * _DiffuseMap_ST.xy + _DiffuseMap_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float4 triplanar45 = TriplanarSamplingSF( _VectorMap, ase_worldPos, ase_worldNormal, _Falloff, _TilingVector, 1.0, 0 );
			float grayscale46 = Luminance(triplanar45.xyz);
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float fresnelNdotV84 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode84 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV84, _FresnelPower ) );
			o.Emission = ( ( tex2D( _DiffuseMap, uv_DiffuseMap ) + ( ( grayscale46 * _NoiseMapOpacity ) * _NoiseColor ) ) + ( fresnelNode84 * _FresnelColor ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
408;73;740;646;3366.788;703.0964;6.608256;True;False
Node;AmplifyShaderEditor.CommentaryNode;136;-1872.445,-1000.388;Float;False;914.394;362.5317;Comment;4;142;139;138;137;Wave Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.TimeNode;137;-1751.548,-950.388;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;138;-1822.445,-752.8553;Float;False;Property;_GrassWaveSpeed;Grass Wave Speed;1;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1422.512,-815.3673;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;140;-1770.327,-407.7352;Float;False;2321.461;426.9865;Comment;12;153;152;151;150;149;148;147;146;145;144;143;141;Vertex Animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;141;-1722.326,-263.7353;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-1201.052,-907.7121;Float;False;GrassSpeed;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-3330.301,628.0773;Float;False;Property;_Falloff;Falloff;8;0;Create;True;0;0;False;0;17.08;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;47;-3316.858,702.2533;Float;False;Property;_TilingVector;TilingVector;5;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ComponentMaskNode;143;-1482.327,-247.7352;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-1402.327,-327.7352;Float;False;142;GrassSpeed;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TriplanarNode;45;-3099.473,649.2025;Float;True;Spherical;World;False;VectorMap;_VectorMap;white;4;None;Mid Texture 1;_MidTexture1;white;-1;None;Bot Texture 1;_BotTexture1;white;-1;None;Triplanar Sampler;False;10;0;SAMPLER2D;;False;5;FLOAT;1;False;1;SAMPLER2D;;False;6;FLOAT;0;False;2;SAMPLER2D;;False;7;FLOAT;0;False;9;FLOAT3;0,0,0;False;8;FLOAT;1;False;3;FLOAT2;1,1;False;4;FLOAT;1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-1194.327,-327.7352;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;129;-2711.676,777.6443;Float;False;Property;_NoiseMapOpacity;NoiseMapOpacity;7;0;Create;True;0;0;False;0;0.7;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCGrayscale;46;-2651.122,661.014;Float;False;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;134;-2479.4,914.9523;Float;False;Property;_NoiseColor;NoiseColor;6;0;Create;True;0;0;False;0;0.9339623,0.9154974,0.4273318,0;0.9339623,0.9154974,0.4273318,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;146;-1002.328,-359.7352;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;87;-2618.793,1168.205;Float;False;Property;_FresnelBias;FresnelBias;9;0;Create;True;0;0;False;0;0.1;1111111;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;130;-2428.392,666.6324;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2561.794,1261.205;Float;False;Property;_FresnelScale;Fresnel Scale;11;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-2549.794,1343.205;Float;False;Property;_FresnelPower;Fresnel Power;12;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;149;-730.3281,-359.7352;Float;True;Property;_WindNoise;Wind Noise;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;128;-2288.242,303.759;Float;True;Property;_DiffuseMap;Diffuse Map;3;0;Create;True;0;0;False;0;1c18271c5bb7cee4493bc2f19215050f;1c18271c5bb7cee4493bc2f19215050f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FresnelNode;84;-2252.604,1151.832;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;135;-2206.355,760.5962;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;86;-2195.494,1409.032;Float;False;Property;_FresnelColor;Fresnel Color;10;0;Create;True;0;0;False;0;0.5580835,0.8113208,0.2104842,0;0.5580835,0.8113208,0.2104842,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.NormalVertexDataNode;147;-378.3275,-263.7353;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;148;-426.3275,-103.7352;Float;False;Property;_WindStrength;Wind Strength;2;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1702.577,1163.812;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;-1956.126,498.7362;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;150;-42.32747,-327.7352;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-42.32747,-167.7352;Float;False;2;2;0;FLOAT3;1,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1301.476,1144.424;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;117.6723,-199.7352;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;277.6722,-199.7352;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;155;180.6743,790.0666;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;34;747.155,423.0602;Float;False;True;6;Float;ASEMaterialInspector;0;0;Standard;Tib/GrassShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;139;0;137;0
WireConnection;139;1;138;0
WireConnection;142;0;139;0
WireConnection;143;0;141;0
WireConnection;45;3;47;0
WireConnection;45;4;23;0
WireConnection;145;0;144;0
WireConnection;145;1;143;0
WireConnection;46;0;45;0
WireConnection;146;1;145;0
WireConnection;130;0;46;0
WireConnection;130;1;129;0
WireConnection;149;1;146;0
WireConnection;84;1;87;0
WireConnection;84;2;88;0
WireConnection;84;3;89;0
WireConnection;135;0;130;0
WireConnection;135;1;134;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;44;0;128;0
WireConnection;44;1;135;0
WireConnection;150;0;149;1
WireConnection;151;0;147;0
WireConnection;151;1;148;0
WireConnection;69;0;44;0
WireConnection;69;1;85;0
WireConnection;152;0;150;0
WireConnection;152;1;151;0
WireConnection;153;0;152;0
WireConnection;34;2;69;0
WireConnection;34;11;152;0
ASEEND*/
//CHKSM=E8A0BDE4ED645DF64545BC20534A5A5E126E8E4F
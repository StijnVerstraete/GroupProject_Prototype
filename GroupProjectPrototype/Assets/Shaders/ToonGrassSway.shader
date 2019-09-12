// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Tib/ToonGrassShader"
{
	Properties
	{
		_ToonRamp("Toon Ramp", 2D) = "white" {}
		_WindNoise("Wind Noise", 2D) = "white" {}
		_GrassWaveSpeed("Grass Wave Speed", Range( 0 , 5)) = 0
		[HDR]_RimColor("Rim Color", Color) = (0,1,0.8758622,0)
		_WindStrength("Wind Strength", Range( 0 , 5)) = 0
		_DiffuseMap("Diffuse Map", 2D) = "white" {}
		_RimPower("Rim Power", Range( 0 , 10)) = 0.5
		_RimOffset("Rim Offset", Float) = 0.24
		_FresnelBias("FresnelBias", Range( 0 , 0.5)) = 0.1
		_FresnelColor("Fresnel Color", Color) = (0.5580835,0.8113208,0.2104842,0)
		_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 4
		_ToonStrength("ToonStrength", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#pragma target 4.6
		#pragma surface surf StandardCustomLighting keepalpha exclude_path:deferred vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float3 worldPos;
			float3 worldNormal;
			INTERNAL_DATA
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		uniform sampler2D _WindNoise;
		uniform float _GrassWaveSpeed;
		uniform float _WindStrength;
		uniform sampler2D _DiffuseMap;
		uniform float4 _DiffuseMap_ST;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float4 _FresnelColor;
		uniform sampler2D _ToonRamp;
		uniform float _ToonStrength;
		uniform float _RimOffset;
		uniform float _RimPower;
		uniform float4 _RimColor;

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

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			c.rgb = 0;
			c.a = 1;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 uv_DiffuseMap = i.uv_texcoord * _DiffuseMap_ST.xy + _DiffuseMap_ST.zw;
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float fresnelNdotV84 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode84 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV84, _FresnelPower ) );
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult169 = dot( ase_worldNormal , ase_worldlightDir );
			float2 temp_cast_0 = (saturate( (dotResult169*0.5 + 0.5) )).xx;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float dotResult160 = dot( ase_worldNormal , ase_worldViewDir );
			o.Emission = ( ( ( ( tex2D( _DiffuseMap, uv_DiffuseMap ) + ( fresnelNode84 * _FresnelColor ) ) * ( tex2D( _ToonRamp, temp_cast_0 ) * _ToonStrength ) ) * ( ase_lightColor * float4( ( float3(0,0,0) + 1 ) , 0.0 ) ) ) + ( saturate( ( ( 1 * dotResult169 ) * pow( ( 1.0 - saturate( ( dotResult160 + _RimOffset ) ) ) , _RimPower ) ) ) * ( _RimColor * ase_lightColor ) ) ).rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17000
408;73;740;646;2610.812;-1071.412;4.308312;False;False
Node;AmplifyShaderEditor.CommentaryNode;156;-3181.196,2519.176;Float;False;507.201;385.7996;Comment;3;160;158;157;N . V;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;159;-2509.196,2759.176;Float;False;1617.938;553.8222;;13;187;186;184;182;180;177;176;175;173;171;167;163;162;Rim Light;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;158;-3085.196,2727.176;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldNormalVector;157;-3133.196,2567.176;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.CommentaryNode;136;-1872.445,-1000.388;Float;False;914.394;362.5317;Comment;4;142;139;138;137;Wave Speed;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;161;-3181.196,2023.176;Float;False;540.401;320.6003;Comment;3;169;165;164;N . L;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldNormalVector;165;-3069.196,2071.176;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;164;-3117.196,2231.176;Float;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;138;-1822.445,-752.8553;Float;False;Property;_GrassWaveSpeed;Grass Wave Speed;2;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;166;-2308.295,1875.475;Float;False;723.599;290;Also know as Lambert Wrap or Half Lambert;3;174;172;168;Diffuse Wrap;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-2429.196,3031.176;Float;False;Property;_RimOffset;Rim Offset;7;0;Create;True;0;0;False;0;0.24;0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TimeNode;137;-1751.548,-950.388;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DotProductOpNode;160;-2829.196,2647.176;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-1422.512,-815.3673;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;140;-1770.327,-407.7352;Float;False;2321.461;426.9865;Comment;12;153;152;151;150;149;148;147;146;145;144;143;141;Vertex Animation;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;163;-2221.196,2919.176;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;169;-2781.196,2135.176;Float;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-2258.295,2050.476;Float;False;Constant;_WrapperValue;Wrapper Value;0;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;167;-2061.196,2919.176;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;170;-2045.196,2311.176;Float;False;812;304;Comment;5;183;181;178;190;191;Attenuation and Ambient;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-2549.794,1343.205;Float;False;Property;_FresnelPower;Fresnel Power;11;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2561.794,1261.205;Float;False;Property;_FresnelScale;Fresnel Scale;10;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;142;-1201.052,-907.7121;Float;False;GrassSpeed;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2618.793,1168.205;Float;False;Property;_FresnelBias;FresnelBias;8;0;Create;True;0;0;False;0;0.1;1111111;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;172;-1992.894,1925.475;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;141;-1722.326,-263.7353;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;174;-1759.696,1932.276;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;173;-1885.196,2919.176;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;84;-2252.604,1151.832;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-1997.196,3047.176;Float;False;Property;_RimPower;Rim Power;6;0;Create;True;0;0;False;0;0.5;1.47;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;86;-2195.494,1409.032;Float;False;Property;_FresnelColor;Fresnel Color;9;0;Create;True;0;0;False;0;0.5580835,0.8113208,0.2104842,0;0.5580835,0.8113208,0.2104842,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;143;-1482.327,-247.7352;Float;False;False;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;190;-2019.353,2524.733;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;144;-1402.327,-327.7352;Float;False;142;GrassSpeed;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;128;-1639.392,900.0849;Float;True;Property;_DiffuseMap;Diffuse Map;5;0;Create;True;0;0;False;0;1c18271c5bb7cee4493bc2f19215050f;1c18271c5bb7cee4493bc2f19215050f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;-1702.577,1163.812;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;145;-1194.327,-327.7352;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PowerNode;176;-1693.196,2919.176;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;175;-1709.196,2807.176;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IndirectDiffuseLighting;191;-1799.465,2451.438;Float;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;192;-1321.152,2136.908;Float;False;Property;_ToonStrength;ToonStrength;12;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;179;-1389.196,1911.176;Float;True;Property;_ToonRamp;Toon Ramp;0;0;Create;True;0;0;False;0;1ff5ef80faa16e04e82f996650846e52;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;-1062.057,1948.287;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LightColorNode;180;-1421.196,3207.176;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.LightColorNode;178;-1933.196,2359.176;Float;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;146;-1002.328,-359.7352;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-1301.476,1144.424;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-1453.196,2887.176;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;177;-1533.196,3031.176;Float;False;Property;_RimColor;Rim Color;3;1;[HDR];Create;True;0;0;False;0;0,1,0.8758622,0;0.1607843,0.6873025,0.8313726,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-1549.196,2471.176;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;185;-840.5399,1903.467;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;148;-426.3275,-103.7352;Float;False;Property;_WindStrength;Wind Strength;4;0;Create;True;0;0;False;0;0;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;147;-378.3275,-263.7353;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;149;-730.3281,-359.7352;Float;True;Property;_WindNoise;Wind Noise;1;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;186;-1261.196,2887.176;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;184;-1229.196,3015.176;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;183;-1389.196,2359.176;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;187;-1069.196,2887.176;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;151;-42.32747,-167.7352;Float;False;2;2;0;FLOAT3;1,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;150;-42.32747,-327.7352;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;-589.1216,2148.683;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;153;277.6722,-199.7352;Float;False;Wind;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;189;12.20754,2452.895;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;152;117.6723,-199.7352;Float;False;2;2;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.NormalVertexDataNode;155;180.6743,790.0666;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;34;866.2014,1618.483;Float;False;True;6;Float;ASEMaterialInspector;0;0;CustomLighting;Tib/ToonGrassShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;ForwardOnly;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0.1;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;160;0;157;0
WireConnection;160;1;158;0
WireConnection;139;0;137;0
WireConnection;139;1;138;0
WireConnection;163;0;160;0
WireConnection;163;1;162;0
WireConnection;169;0;165;0
WireConnection;169;1;164;0
WireConnection;167;0;163;0
WireConnection;142;0;139;0
WireConnection;172;0;169;0
WireConnection;172;1;168;0
WireConnection;172;2;168;0
WireConnection;174;0;172;0
WireConnection;173;0;167;0
WireConnection;84;1;87;0
WireConnection;84;2;88;0
WireConnection;84;3;89;0
WireConnection;143;0;141;0
WireConnection;85;0;84;0
WireConnection;85;1;86;0
WireConnection;145;0;144;0
WireConnection;145;1;143;0
WireConnection;176;0;173;0
WireConnection;176;1;171;0
WireConnection;175;0;190;0
WireConnection;175;1;169;0
WireConnection;179;1;174;0
WireConnection;193;0;179;0
WireConnection;193;1;192;0
WireConnection;146;1;145;0
WireConnection;69;0;128;0
WireConnection;69;1;85;0
WireConnection;182;0;175;0
WireConnection;182;1;176;0
WireConnection;181;0;191;0
WireConnection;181;1;190;0
WireConnection;185;0;69;0
WireConnection;185;1;193;0
WireConnection;149;1;146;0
WireConnection;186;0;182;0
WireConnection;184;0;177;0
WireConnection;184;1;180;0
WireConnection;183;0;178;0
WireConnection;183;1;181;0
WireConnection;187;0;186;0
WireConnection;187;1;184;0
WireConnection;151;0;147;0
WireConnection;151;1;148;0
WireConnection;150;0;149;1
WireConnection;188;0;185;0
WireConnection;188;1;183;0
WireConnection;153;0;152;0
WireConnection;189;0;188;0
WireConnection;189;1;187;0
WireConnection;152;0;150;0
WireConnection;152;1;151;0
WireConnection;34;2;189;0
WireConnection;34;11;152;0
ASEEND*/
//CHKSM=032B6A648E576F9A5D3FB932A24C607B23D3CD09
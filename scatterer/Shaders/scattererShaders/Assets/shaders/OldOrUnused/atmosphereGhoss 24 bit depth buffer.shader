﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'


Shader "Scatterer/AtmosphericScatter" {
    SubShader {
          Tags {"Queue" = "Transparent-5" "IgnoreProjector" = "True" "RenderType" = "Transparent"}
		
	
    	

//        Pass {  //extinction pass
//
//    		ZWrite Off
//    		ZTest Off
//    		cull Front
//
//            Blend DstColor Zero //multiplicative
//
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//            #pragma glsl
//            #pragma target 3.0
//            #include "UnityCG.cginc"
//            #include "AtmosphereScatterer.cginc"
//            
////           	#pragma multi_compile ECLIPSES_OFF ECLIPSES_ON
//            
//            uniform float4x4 _ViewProjInv;
////            uniform float _viewdirOffset;
//            uniform float _Scale;
//            uniform float _global_alpha;
//            uniform float _global_depth;
//            uniform float _Ocean_Sigma;
//            uniform float fakeOcean;
//            uniform float _fade;
//            uniform float3 _Ocean_Color;
//            uniform float3 _camPos; // camera position relative to planet's origin
//            uniform float _Post_Extinction_Tint;
//            uniform float postExtinctionMultiplier;
//            uniform sampler2D _customDepthTexture;
//            uniform float4 _MainTex_TexelSize;
//            uniform float _openglThreshold;
//            //   uniform float _edgeThreshold;
//            uniform float _horizonDepth;
//            uniform float4x4 _Globals_CameraToWorld;
//            
////            //eclipse uniforms
////#if defined (ECLIPSES_ON)			
////			uniform float4 sunPosAndRadius; //xyz sun pos w radius
////			uniform float4x4 lightOccluders1; //array of light occluders
////											 //for each float4 xyz pos w radius
////			uniform float4x4 lightOccluders2;
////#endif
//            
//            struct v2f
//            {
//                float4 pos: SV_POSITION;
//                float4 screenPos: TEXCOORD0;
//                float2 uv: TEXCOORD1;
//                float2 uv_depth: TEXCOORD2;
//				float3 view_dir:TEXCOORD3;
//            };
//            
//            v2f vert(appdata_base v)
//            {
//                v2f o;
//                o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
//                o.screenPos = ComputeScreenPos(o.pos);
//                o.uv = o.screenPos.xy / o.screenPos.w;
//                o.uv_depth = o.uv;
//                #if UNITY_UV_STARTS_AT_TOP
//                if (_MainTex_TexelSize.y < 0)
//                o.uv.y = 1 - o.uv.y;
//                #endif
//                COMPUTE_EYEDEPTH(o.screenPos.z); //o = -mul( UNITY_MATRIX_MV, v.vertex ).z
//                o.view_dir = mul(unity_ObjectToWorld, v.vertex) - _WorldSpaceCameraPos;
//                return o;
//            }
//            
//            half4 frag(v2f i): COLOR
//            {
//                float depth = tex2D(_customDepthTexture, i.uv_depth).r;
//                
//                float4 H = float4(i.uv_depth.x * 2.0f - 1.0f, (i.uv_depth.y) * 2.0f - 1.0f, depth, 1.0f);
//                float4 D = mul(_ViewProjInv, H);
//                float3 worldPos = D / D.w;  //reconstruct world position from depth
//                							//worldPos relative to planet origin
//                							//ie planetOrigin=(0,0,0);
//                
//                float3 rayDir=i.view_dir;
//                float interSectPt = intersectSphere2(_camPos, rayDir, float3(0.0, 0.0, 0.0), Rg); //intersection with ocean surface
//
//                bool infinite = (depth == 1.0); //basically viewer ray isn't hitting any terrain
//                bool rightDir = (interSectPt > 0); //this ensures that we're looking in the right direction // ie ocean surface intersection point is in front of us
//
//                if (!(rightDir) && (infinite))
//                {
//                    return float4(1.0, 1.0, 1.0, 1.0);
//                }
//
//                float3 worldPos2 = _camPos + interSectPt * rayDir; //ocean intersection point's world position
//
//                bool oceanCloserThanTerrain = (length(worldPos2 - _camPos) < length(worldPos - _camPos)); //this condition ensures the ocean is in front of the terrain, if it's in front we use its pos else we don't
//				worldPos = (rightDir && oceanCloserThanTerrain) ? worldPos2 : worldPos;
//				
//                //artifacts fix
//                worldPos= length(worldPos) < (Rg + _openglThreshold) ? (Rg + _openglThreshold) * normalize(worldPos) : worldPos ;
//
//                float3 extinction = getExtinction(_camPos, worldPos, 1.0, 1.0, 1.0);
//                float average=(extinction.r+extinction.g+extinction.b)/3;
//
//                //lerped manually because of an issue with opengl or whatever
//                extinction = float3(_Post_Extinction_Tint*extinction.r + (1-_Post_Extinction_Tint)*average,
//                _Post_Extinction_Tint*extinction.g + (1-_Post_Extinction_Tint)*average,
//                _Post_Extinction_Tint*extinction.b + (1-_Post_Extinction_Tint)*average);
//                //                extinction = lerp(average, extinction, _Post_Extinction_Tint);
//                extinction = lerp (float3(1,1,1), extinction, postExtinctionMultiplier);
//                
//                
////#if defined (ECLIPSES_ON)				
//// 				float eclipseShadow = 1;
//// 							
////            	for (int i=0; i<4; ++i)
////    			{
////        			if (lightOccluders1[i].w <= 0)	break;
////					eclipseShadow*=getEclipseShadow(worldPos, sunPosAndRadius.xyz,lightOccluders1[i].xyz,
////								   lightOccluders1[i].w, sunPosAndRadius.w)	;
////				}
////						
////				for (int j=0; j<4; ++j)
////    			{
////        			if (lightOccluders2[j].w <= 0)	break;
////					eclipseShadow*=getEclipseShadow(worldPos, sunPosAndRadius.xyz,lightOccluders2[j].xyz,
////								   lightOccluders2[j].w, sunPosAndRadius.w)	;
////				}
////
////				extinction*=eclipseShadow;
////#endif
//
//
////                float3 sunExtinction = sunsetExtinction(worldPos); //bad idea
////                extinction*=sunExtinction;
//                
//                return float4(extinction, 1.0);
//            }
//            ENDCG
//        }


//scattering pass
Pass {
			Cull Front
			ZTest Off
			ZWrite Off
    	
            Blend OneMinusDstColor One //soft additive

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma glsl
            #pragma target 3.0
            #include "UnityCG.cginc"
            #include "AtmosphereScatterer.cginc"

            //#define LOGARITHMIC_DEPTH_ON
            #define VIEW_SPACE_DISTANCE_ON

            #pragma multi_compile GODRAYS_OFF GODRAYS_ON
//			#pragma multi_compile ECLIPSES_OFF ECLIPSES_ON
			#pragma multi_compile PLANETSHINE_OFF PLANETSHINE_ON
            
            uniform float4x4 _ViewProjInv;
//            uniform float _viewdirOffset;
            uniform float _Scale;
            uniform float _global_alpha;
//            uniform float _Exposure;
            uniform float _global_depth;
            uniform float _Ocean_Sigma;
            uniform float fakeOcean;
            uniform float _fade;
            uniform float3 _Ocean_Color;
            uniform float3 _camPos; // camera position relative to planet's origin
            uniform float3 _camForward;
            uniform sampler2D _customDepthTexture;
#if defined (GODRAYS_ON)
            uniform sampler2D _godrayDepthTexture;
#endif
            uniform float4 _MainTex_TexelSize;
            uniform float _openglThreshold;
            uniform float _horizonDepth;
            uniform float4x4 _Globals_CameraToWorld;
            
//            //eclipse uniforms
//#if defined (ECLIPSES_ON)			
//			uniform float4 sunPosAndRadius; //xyz sun pos w radius
//			uniform float4x4 lightOccluders1; //array of light occluders
//											 //for each float4 xyz pos w radius
//			uniform float4x4 lightOccluders2;
//#endif
        
#if defined (PLANETSHINE_ON)
			uniform float4x4 planetShineSources;
			uniform float4x4 planetShineRGB;
#endif
                    
            struct v2f
            {
                float4 pos: SV_POSITION;
                float4 screenPos: TEXCOORD0;
                float2 uv: TEXCOORD1;
                //float2 uv_depth: TEXCOORD2;
                float3 view_dir:TEXCOORD2;
                //float3 cubeWorldPos:TEXCOORD4;
            };

            v2f vert(appdata_base v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.pos);
                o.uv = o.screenPos.xy / o.screenPos.w;
				o.view_dir = mul(unity_ObjectToWorld, v.vertex) - _WorldSpaceCameraPos;
                return o;
            }


            half4 frag(v2f i): COLOR
            {
				float depth = tex2D(_customDepthTexture, i.uv).r;                

#if defined (LOGARITHMIC_DEPTH_ON)
				float C=1.0;
				float _offset=2.0;

				float z = ( exp( depth * log (C*750000.0 + _offset)) - _offset) / C;
				float dpt = z/750000.0;
				float zbx = 1.0 - (750000.0/300.0);
				float zby = (750000.0/300.0);
				depth = (1.0/dpt -zby) / zbx;

#endif

				float3 rayDir=i.view_dir;

//#if defined (VIEW_SPACE_DISTANCE_ON)

				if (depth == 1.0)
					depth = 1000000.0;
				//float3 worldPos = depth*normalize(rayDir) + _camPos;

				//using view-space z
				float aa = dot(normalize(rayDir), normalize (_camForward));
				//float dist = depth * 750000 /aa;
				float dist = depth / aa;
				float3 worldPos = dist*normalize(rayDir) + _camPos;
//#else
//
//                float3 worldPos = D / D.w;
//#endif

#if defined (GODRAYS_ON)				
				float godrayDepth= tex2D(_godrayDepthTexture, i.uv).r;

				//fade godrays when looking at them sideways by lerping to terrain depth
                float3 SidewaysFromSun = normalize(cross(_camPos,SUN_DIR));
                float godrayBlendFactor= 1-abs (dot(SidewaysFromSun,normalize(rayDir)));
                
                depth= (godrayDepth > 0) && (godrayDepth < depth) && (depth<1) ? lerp(depth, godrayDepth, godrayBlendFactor) : depth;
				H = float4(i.uv.x * 2.0f - 1.0f, i.uv.y * 2.0f - 1.0f, depth, 1.0f);
                D = mul(_ViewProjInv, H); //reconstruct world position from depth, in this case lerped depth and godray depth
                float3 godrayWorldPos = D / D.w;
#endif


				float interSectPt = intersectSphere2(_camPos, rayDir, float3(0.0, 0.0, 0.0), Rg);  //intersection with ocean surface
                
                bool rightDir = (interSectPt > 0); //this ensures that we're looking in the right direction // ie ocean surface intersection point is in front of us
                bool infinite = (depth == 1.0); //basically viewer ray isn't hitting any terrain

#if defined (VIEW_SPACE_DISTANCE_ON)
				infinite = (depth == 1000000.0);
#endif

				if (!(rightDir) && (infinite))
                {
                    return float4(0.0, 0.0, 0.0, 0.0);
                }

				float3 worldPos2 = _camPos + interSectPt * rayDir; //ocean intersection point's world position

                bool oceanCloserThanTerrain = length(worldPos2 - _camPos) < length(worldPos - _camPos); //this condition ensures the ocean is in front of the terrain, if it's in front we use its pos else we don't
                worldPos = rightDir && oceanCloserThanTerrain ? worldPos2 : worldPos;
                
#if defined (GODRAYS_ON)
                oceanCloserThanTerrain = (length(worldPos2 - _camPos) < length(godrayWorldPos - _camPos));
                godrayWorldPos = rightDir && oceanCloserThanTerrain ? worldPos2 : godrayWorldPos;
#endif
                
                //artifacts fix
                worldPos= (length(worldPos) < (Rg + _openglThreshold)) ? (Rg + _openglThreshold) * normalize(worldPos) : worldPos ;

#if defined (GODRAYS_ON)
				godrayWorldPos= length(godrayWorldPos) < (Rg + _openglThreshold) ? (Rg + _openglThreshold) * normalize(godrayWorldPos) : godrayWorldPos ;
#endif


                float3 extinction = float3(0, 0, 0);

#if defined (GODRAYS_ON)
                float3 inscatter = InScattering2(_camPos, godrayWorldPos, extinction, SUN_DIR, 1.0, 1.0, 1.0);
                float dpth = length(godrayWorldPos - _camPos);
#else
				float3 inscatter = InScattering2(_camPos, worldPos, extinction, SUN_DIR, 1.0, 1.0, 1.0);
                float dpth = length(worldPos -_camPos);
#endif
                float visib = 1;
                visib = (dpth <= _global_depth) ? (1 - exp(-1 * (4 * dpth / _global_depth))) : visib;
                //visib= smoothstep(0,2000,dpth); //smooth the last edge
                //visib = (length(worldPos - _camPos) - 400) / 2000;
                //visib*= min(1,(length(worldPos - _camPos) - length(i.cubeWorldPos)) / 1200);//smooth the last edge
                inscatter*= visib;
                
#if defined (PLANETSHINE_ON)
			    float3 inscatter2=0;
			    for (int i=0; i<4; ++i)
    			{
    				if (planetShineRGB[i].w == 0) break;
    				
    				//if source is not a sun compute intensity of light from angle to light source
			   		float intensity=1;  
			   		if (planetShineSources[i].w != 1.0f)
					{
						intensity = 0.57f*max((0.75-dot(normalize(planetShineSources[i].xyz - worldPos),SUN_DIR)),0);
					}
    				
    				inscatter2+=InScattering2(_camPos, worldPos,extinction, normalize(planetShineSources[i].xyz),1.0, 1.0, 1.0)
    							*planetShineRGB[i].xyz*planetShineRGB[i].w*intensity;
    			}
    			
    			#if defined (GODRAYS_ON)
    				visib = 1;
                	dpth = length(worldPos - _camPos);
                	visib = (dpth <= _global_depth) ? (1 - exp(-1 * (4 * dpth / _global_depth))) : visib;
                	inscatter+=inscatter2*visib;
    			#else
    				inscatter+=inscatter2*visib;
    			#endif			    
#endif
                
//#if defined (ECLIPSES_ON)				
// 				float eclipseShadow = 1;
// 							
//            	for (int i=0; i<4; ++i)
//    			{
//        			if (lightOccluders1[i].w <= 0)	break;
//					eclipseShadow*=getEclipseShadow(worldPos, sunPosAndRadius.xyz,lightOccluders1[i].xyz,
//								   lightOccluders1[i].w, sunPosAndRadius.w)	;
//				}
//						
//				for (int j=0; j<4; ++j)
//    			{
//        			if (lightOccluders2[j].w <= 0)	break;
//					eclipseShadow*=getEclipseShadow(worldPos, sunPosAndRadius.xyz,lightOccluders2[j].xyz,
//								   lightOccluders2[j].w, sunPosAndRadius.w)	;
//				}
//
//				inscatter*=eclipseShadow;
//#endif
                
                return float4(hdr(inscatter)*_global_alpha, 1);                				
            }
            ENDCG
        }
    }
}
Shader "AudioFractals/GetDoomedRibbon"
{
	Properties
	{
		_Audio ("Audio input", Float) = 0
		[HideInInspector]
		_AudioTime ("Audio time", Float) = 0
	}

	SubShader
	{
		Cull Off ZWrite Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv     : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
	            o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			#define MAGIC(x,y)	frac(dot(x*2., y*2.)*10.)
			#define ITER		18
			#define TIMESCALE	0.5

			float _Audio;
			float _AudioTime;

			fixed4 frag(v2f i) : SV_Target
			{
				const float	contrast = 8;
				const float	light = 1;

				float2 uv = i.uv * 2 - 1;

				float gTime = _AudioTime * TIMESCALE + 100;
				float f = 0., g = 0., h = 0.;
				float2 res = _ScreenParams.xy;
				float2 mou;
				float demoniColor = sin(gTime * 0.0823456) / 2 + .5;
				float dist = cos(gTime * 0.01) / 4 + .65;
				mou.x = lerp(-1.1, 0.2, sin(gTime * 0.142) / 2 + .5) * dist;
			#ifdef MORE_SYMMETRY
				mou.y = (cos(gTime * 0.08) / 2 + .5) * 2 * dist;
			#else
				mou.y = clamp(cos(gTime / 200) / 1.5 + .25, 0, 1) * dist * (1 / clamp(mou.x, 0.4, 1));
			#endif
				mou = (mou+1.0) * res;
				float2 z = -uv * 2;
				float2 p = ((-res+2.0+mou) / res.y);
				//  z.x = abs(z.x);
				for( int i = 0; i < ITER; i++)
				{
					float d = dot(z,z);
					z = (float2( z.x, -z.y ) / d) + p;
					z.x = abs(z.x);
			#ifdef MORE_SYMMETRY
					z.y = abs(z.y);
			#endif
					f = max(f, MAGIC(z-p,z-p));
					g = max(g, MAGIC(z+p,z-p));
					h = max(h, MAGIC(p-z,p+z));
				}
				float3 col = ((float3(f, g, h) - (1-(1/contrast)))*contrast);
				col = abs(col-demoniColor);
			#ifdef GREYSCALE
				col = float3((col.x + col.y + col.z) / 3);
			#endif
				col *= light;

				return float4(col, 1);
			}

			ENDCG
		}
	}
}

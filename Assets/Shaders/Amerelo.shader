Shader "AudioFractals/Amerelo"
{
	Properties
	{
		_Audio ("Audio input", Float) = 0
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
			
			float _Audio;
			float _AudioTime;

			float4 frag(v2f i) : SV_Target
			{
				float3		col = float3(1, 1, 0);

				float mouse_x = -0.5;
				float i1 = i.uv.x + 0.8;
				float i2 = i.uv.y;
				float a = 0;
				while (i2 * i2 + i1 * i1 <= 4 && a < 20 && ++a)
				{
					float tmp = sin(i1 * i1) - tan(i2 * i2) + mouse_x;
					i2 = 2 * sin(i1 * i2) + mouse_x;
					i1 = tmp * cos(_Time.y) / i1 ;
				}
				col = float3(i1  , i1 - i2 * sin(_Time.y), i2 + sin(_Time.y));

				return float4(col, 1);
			}

			ENDCG
		}
	}
}

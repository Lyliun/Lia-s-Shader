// 🔥 OlhoCrosshairUltra_Fancy - mira estática + breath-in + RingRotation + Flicker
Shader "LiaShader/Cyberpunk Crossair"
{
    Properties
    {
        _MainTex ("Eye Texture", 2D) = "white" {}

        [HDR] _BackgroundColor1 ("Background Color 1", Color) = (0,0.5,1,1)
        [HDR] _BackgroundColor2 ("Background Color 2", Color) = (0,0,0,1)
        _HueOffset ("Hue Offset", Range(0,1)) = 0
        _HueSpeed ("Hue Speed", Range(0,5)) = 0

        // Crosshair
        _Size ("Crosshair Size", Range(0.05,1)) = 0.15
        _Thickness ("Line Thickness", Range(0.001,0.2)) = 0.012
        _ArmLength ("Crosshair Arm Length", Range(0.0, 1.5)) = 0.45
        _ArmFeather ("Arm Feather", Range(0.0, 0.2)) = 0.03
        [HDR] _ShapeColor1 ("Crosshair Color 1", Color) = (0,1,1,1)
        [HDR] _ShapeColor2 ("Crosshair Color 2", Color) = (1,1,1,1)

        _BreathSpeed ("Breath Speed", Range(0.1,5)) = 1.0
        _BreathStrength ("Breath Strength", Range(0.0,0.5)) = 0.1
        _RotationSpeed ("Rotation Speed", Range(-2,2)) = 0.0

        _Softness ("Glow Softness", Range(0.001,0.3)) = 0.06
        [HDR] _GlowColor ("Glow Color", Color) = (1,1,1,1)
        _Emission ("Emission Strength", Range(0,10)) = 3
        _MasterEmission ("Master Emission", Range(0,5)) = 1

        // Circles
        _Circle1Size ("Circle1 Size", Range(0,1)) = 0.3
        _Circle1Brightness ("Circle1 Brightness", Range(0,2)) = 0.8
        _Circle2Size ("Circle2 Size", Range(0,1)) = 0.5
        _Circle2Brightness ("Circle2 Brightness", Range(0,2)) = 0.4

        // Pulse
        _PulseSpeed ("Pulse Speed", Range(0.01,10)) = 2
        _PulseStrength ("Pulse Strength", Range(0,2)) = 0.6

        // Scanline
        [Toggle] _EnableScan ("Enable Scanline", Float) = 0
        _ScanSpeed ("Scanline Speed", Range(0,10)) = 2
        _ScanWidth ("Scanline Width", Range(0.01,0.5)) = 0.1
        [HDR] _ScanColor ("Scanline Color", Color) = (0,1,1,1)

        // Vignette
        _VignetteThickness ("Vignette Thickness", Range(0,1)) = 0.37
        _VignetteFalloff ("Vignette Falloff", Range(0,1)) = 0.2

        // Ripple/Distorção
        _RippleStrength ("Ripple Strength", Range(0,0.1)) = 0.02
        _RippleSpeed ("Ripple Speed", Range(0.1,10)) = 2.0

        // Glitch
        _GlitchStrength ("Glitch Strength", Range(0,0.2)) = 0.05
        _GlitchSpeed ("Glitch Speed", Range(0.1,20)) = 5

        // Chromatic Aberration
        _ChromaticOffset ("Chromatic Offset", Range(0,0.01)) = 0.002

        // Energy Wave
        _EnergyWaveSpeed ("Energy Wave Speed", Range(0.1,10)) = 2
        _EnergyWaveStrength ("Energy Wave Strength", Range(0,2)) = 0.5

        // 🔥 Novos efeitos
        _RingRotationSpeed ("Ring Rotation Speed", Range(-5,5)) = 1.5
        _FlickerSpeed ("Flicker Speed", Range(0.1,20)) = 8
        _FlickerStrength ("Flicker Strength", Range(0,1)) = 0.4

        // Lens Distortion (mantive os nomes como você escreveu)
        _LensStrenght ("Lens Distortion Strenght", Range(0,0.2)) = 0.05
        _LensFrequency ("Lens Distortion Frenquency", Range(1,20)) = 6

        // Energy Sparks
        _SparkDensity ("Spark Density", Range(1,200)) = 50
        _SparkIntensity ("Spark Intensity", Range(0,3)) = 1.5
    }

    CustomEditor "OlhoCrosshairUltra_Fancy_GUI"

    SubShader
    {
        Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        LOD 200

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 3.0
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _BackgroundColor1, _BackgroundColor2;
            float _HueOffset, _HueSpeed;

            float _Size, _Thickness;
            float _ArmLength, _ArmFeather;
            float4 _ShapeColor1, _ShapeColor2;

            float _BreathSpeed, _BreathStrength;
            float _RotationSpeed;

            float _Softness;
            float4 _GlowColor;
            float _Emission, _MasterEmission;

            float _Circle1Size, _Circle1Brightness;
            float _Circle2Size, _Circle2Brightness;

            float _PulseSpeed, _PulseStrength;

            float _EnableScan, _ScanSpeed, _ScanWidth;
            float4 _ScanColor;

            float _VignetteThickness, _VignetteFalloff;

            float _RippleStrength, _RippleSpeed;
            float _GlitchStrength, _GlitchSpeed;
            float _ChromaticOffset;
            float _EnergyWaveSpeed, _EnergyWaveStrength;

            float _RingRotationSpeed;
            float _FlickerSpeed, _FlickerStrength;

            float _LensStrenght, _LensFrequency;
            float _SparkDensity, _SparkIntensity;

            #ifndef UNITY_PI
            #define UNITY_PI 3.14159265359
            #endif

            struct appdata { float4 vertex : POSITION; float2 uv : TEXCOORD0; };
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float2 rotate2D(float2 p, float a) {
                float s = sin(a), c = cos(a);
                return float2(c*p.x - s*p.y, s*p.x + c*p.y);
            }

            float3 HueShift(float3 c, float h01) {
                float a = h01 * UNITY_PI * 2.0;
                float s = sin(a), q = cos(a);
                float3 k = normalize(float3(1,1,1));
                return c*q + cross(k, c)*s + k*dot(k, c)*(1.0 - q);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 center = float2(0.5, 0.5);
                float t = _Time.y;

                float2 toCenter = uv - center;
                float r = length(toCenter);

                // === Lens distortion / refraction ===
                float2 offset = toCenter;
                float lens = sin(length(offset) * _LensFrequency - t) * _LensStrenght;
                float2 dir0 = (r > 1e-5) ? (offset / r) : float2(0,0);
                uv += dir0 * lens;

                // === Glitch UV ===
                float glitch = frac(sin(dot(uv * t, float2(12.9898,78.233))) * 43758.5453);
                float glitchMask = step(0.98, frac(sin(t * _GlitchSpeed) * 43758.5453));
                uv.x += (glitchMask > 0 ? (glitch - 0.5) * _GlitchStrength : 0);

                // === Ripple distortion ===
                toCenter = uv - center;
                r = length(toCenter);
                float ripple = sin(r * 40.0 - t * _RippleSpeed) * _RippleStrength;
                float2 dir = (r > 1e-5) ? (toCenter / r) : float2(0,0);
                uv += dir * ripple;

                // Recalcula centro/r após distorções
                toCenter = uv - center;
                r = length(toCenter);

                // === Background ===
                float radial = saturate(r * 2.0);
                float3 bg = lerp(_BackgroundColor1.rgb, _BackgroundColor2.rgb, radial);

                // === Breath-in estático ===
                float breath = 1.0 + sin(t * _BreathSpeed) * _BreathStrength;
                float2 dUV = toCenter / max(_Size, 1e-4);
                dUV *= breath;

                // === Crosshair ( + arms ) ===
                float2 ad = abs(dUV);
                float dx = ad.x;
                float dy = ad.y;
                float lineV = 1.0 - smoothstep(_Thickness, _Thickness + _Softness, dx);
                float lineH = 1.0 - smoothstep(_Thickness, _Thickness + _Softness, dy);
                float armMaskV = 1.0 - smoothstep(_ArmLength, _ArmLength + _ArmFeather, dy);
                float armMaskH = 1.0 - smoothstep(_ArmLength, _ArmLength + _ArmFeather, dx);
                lineV *= armMaskV;
                lineH *= armMaskH;
                float crosshair = max(lineV, lineH);

                // === Gradiente + Hue ===
                float gradFactor = saturate((dUV.y + 1.0) * 0.5);
                float3 gradColor = lerp(_ShapeColor1.rgb, _ShapeColor2.rgb, gradFactor);
                float hue = frac(_HueOffset + t * _HueSpeed);
                gradColor = HueShift(gradColor, hue);

                // === Glow ===
                float pulse = (sin(t * _PulseSpeed) * 0.5 + 0.5) * _PulseStrength;
                float3 crossGlow = gradColor * crosshair * (_Emission + pulse) * _MasterEmission;

                // === Circles + RingRotation + EnergyWave ===
                float c1 = (r - _Circle1Size) * 18.0;
                float c2 = (r - _Circle2Size) * 25.0;
                float circle = exp(-(c1*c1)) * _Circle1Brightness;
                circle += exp(-(c2*c2)) * _Circle2Brightness;

                float angle = atan2(toCenter.y, toCenter.x);
                float ringRot = sin(angle * 6.0 + t * _RingRotationSpeed) * 0.5 + 0.5;
                circle *= ringRot;

                float wave = sin((r - frac(t * _EnergyWaveSpeed)) * 40.0) * _EnergyWaveStrength;
                circle += wave * 0.2;

                float3 circleGlow = circle * gradColor * 1.2;

                // === Energy Sparks ===
                float sparkNoise = frac(sin(dot(uv * _SparkDensity, float2(12.9898,78.233))) * 43758.5453);
                float spark = step(0.995, sparkNoise) * _SparkIntensity;
                circleGlow += spark * gradColor;

                // === Flicker ===
                float flicker = (sin(t * _FlickerSpeed) * 0.5 + 0.5) * _FlickerStrength;
                circleGlow *= (1.0 - flicker);

                // === Chromatic Aberration ===
                float3 chroma;
                chroma.r = tex2D(_MainTex, uv + float2(_ChromaticOffset,0)).r;
                chroma.g = tex2D(_MainTex, uv).g;
                chroma.b = tex2D(_MainTex, uv - float2(_ChromaticOffset,0)).b;

                // === Scanline ===
                float3 scanCol = 0;
                if (_EnableScan > 0.5)
                {
                    float t2 = frac(t * _ScanSpeed + uv.y);
                    float scanMask = smoothstep(0.0, _ScanWidth, abs(t2 - 0.5));
                    scanCol = (1.0 - scanMask) * _ScanColor.rgb;
                }

                // === Final composition ===
                float3 col = chroma * bg + crossGlow + circleGlow + scanCol;

                // === Vignette ===
                float vdist = length(uv - float2(0.5,0.5)) * 2.0;
                float vmask = smoothstep(_VignetteThickness, _VignetteThickness + max(_VignetteFalloff, 1e-4), vdist);
                col *= (1.0 - vmask);

                return float4(col, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
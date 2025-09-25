// 🔥 OlhoCrosshairUltra_Fancy - mira estática + breath-in + RingRotation + Flicker
Shader "LiaShader/Cyberpunk Crossair"
{
    Properties
    {
        _MainTex ("Eye Texture", 2D) = "white" {}

        // Cores de fundo otimizadas para half
        [HDR] _BackgroundColor1 ("Background Color 1", Color) = (0,0.5,1,1)
        [HDR] _BackgroundColor2 ("Background Color 2", Color) = (0,0,0,1)
        _HueOffset ("Hue Offset", Range(0,1)) = 0
        _HueSpeed ("Hue Speed", Range(0,5)) = 0

        // Crosshair
        _Size ("Crosshair Size", Range(0.05,1)) = 0.15
        _Thickness ("Line Thickness", Range(0.001,0.2)) = 0.012
        _ArmLength ("Crosshair Arm Length", Range(0.0, 1.5)) = 0.45
        _ArmFeather ("Arm Feather", Range(0.0, 0.2)) = 0.03
        // Cores da mira otimizadas para half
        [HDR] _ShapeColor1 ("Crosshair Color 1", Color) = (0,1,1,1)
        [HDR] _ShapeColor2 ("Crosshair Color 2", Color) = (1,1,1,1)

        _BreathSpeed ("Breath Speed", Range(0.1,5)) = 1.0
        _BreathStrength ("Breath Strength", Range(0.0,0.5)) = 0.1
        _RotationSpeed ("Rotation Speed", Range(-2,2)) = 0.0

        _Softness ("Glow Softness", Range(0.001,0.3)) = 0.06
        // Cores do glow otimizadas para half
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
        // Cor do scanline otimizadas para half
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

        // Enable RGB
        [Toggle] _EnableRGB ("Enable RGB", Float) = 0

        // Afterimage
        _AfterimageStrength ("Afterimage Strength", Range(0,3)) = 1.2
        _AfterimageDensity ("Afterimage Density", Range(1,20)) = 5
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

            // Variáveis otimizadas para half
            half4 _BackgroundColor1, _BackgroundColor2;
            half _HueOffset, _HueSpeed;

            float _Size, _Thickness;
            float _ArmLength, _ArmFeather;
            
            // Variáveis otimizadas para half
            half4 _ShapeColor1, _ShapeColor2;

            float _BreathSpeed, _BreathStrength;
            float _RotationSpeed;

            float _Softness;
           
            // Variáveis otimizadas para half
            half4 _GlowColor;
            float _Emission, _MasterEmission;

            float _Circle1Size, _Circle1Brightness;
            float _Circle2Size, _Circle2Brightness;

            float _PulseSpeed, _PulseStrength;

            float _EnableScan, _ScanSpeed, _ScanWidth;
            
            // Variáveis otimizadas para half
            half4 _ScanColor;

            float _VignetteThickness, _VignetteFalloff;

            float _RippleStrength, _RippleSpeed;
            float _GlitchStrength, _GlitchSpeed;
            float _ChromaticOffset;
            float _EnergyWaveSpeed, _EnergyWaveStrength;

            float _RingRotationSpeed;
            float _FlickerSpeed, _FlickerStrength;

            float _LensStrenght, _LensFrequency;
            float _SparkDensity, _SparkIntensity;

            float _AfterimageStrength, _AfterimageDensity;

            float _EnableRGB;

            #ifndef UNITY_PI
            #define UNITY_PI 3.14159265359
            #endif

            // O `v2f` e `appdata` podem usar half
            struct appdata { float4 vertex : POSITION; half2 uv : TEXCOORD0; };
            struct v2f { float4 pos : SV_POSITION; half2 uv : TEXCOORD0; };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            // A função de rotação pode usar half2
            half2 rotate2D(half2 p, half a) {
                half s = sin(a), c = cos(a);
                return half2(c*p.x - s*p.y, s*p.x + c*p.y);
            }

            // Função de hash para pseudo-aleatoriedade
            half hash12(float2 p) {
                p = frac(p * float2(5.31, 8.21));
                p += dot(p, p.yx);
                return frac(p.x * p.y);
            }

            // A função de HueShift pode usar half3
            half3 HueShift(half3 c, half h01) {
                half a = h01 * UNITY_PI * 2.0;
                half s = sin(a), q = cos(a);
                half3 k = normalize(half3(1,1,1));
                return c*q + cross(k, c)*s + k*dot(k, c)*(1.0 - q);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // Variáveis locais otimizadas para half
                half2 uv = i.uv;
                half2 center = half2(0.5, 0.5);
                float t = _Time.y; // Mantém float para evitar imprecisão com tempo

                half2 toCenter = uv - center;
                half r = length(toCenter);

                // === Lens distortion / refraction ===
                half2 offset = toCenter;
                half lens = sin(length(offset) * _LensFrequency - t) * _LensStrenght;
                half2 dir0 = (r > 1e-5) ? (offset / r) : half2(0,0);
                uv += dir0 * lens;

                // === Glitch UV ===
                half glitch = hash12(uv * t);
                half glitchMask = step(0.98, frac(sin(t * _GlitchSpeed) * 43758.5453));
                uv.x += (glitchMask > 0 ? (glitch - 0.5) * _GlitchStrength : 0);  

                // === Ripple distortion ===
                toCenter = uv - center;
                r = length(toCenter);
                half ripple = sin(r * 40.0 - t * _RippleSpeed) * _RippleStrength;
                half2 dir = (r > 1e-5) ? (toCenter / r) : half2(0,0);
                uv += dir * ripple;

                // Recalcula centro/r após distorções
                toCenter = uv - center;
                r = length(toCenter);

                // === Background ===
                half radial = saturate(r * 2.0);
                half3 finalBgColor1 = _BackgroundColor1.rgb;
                if (_EnableRGB > 0.5)
                {
                    half hue = frac(_HueOffset + t * _HueSpeed);
                    finalBgColor1 = HueShift(finalBgColor1, hue);
                }
                half3 bg = lerp(finalBgColor1, _BackgroundColor2.rgb, radial);

                // === Breath-in estático ===
                half breath = 1.0 + sin(t * _BreathSpeed) * _BreathStrength;
                half2 dUV = toCenter / max(_Size, 1e-4);
                dUV *= breath;

                // === Crosshair ( + arms ) ===
                half2 ad = abs(dUV);
                half dx = ad.x;
                half dy = ad.y;
                half lineV = 1.0 - smoothstep(_Thickness, _Thickness + _Softness, dx);
                half lineH = 1.0 - smoothstep(_Thickness, _Thickness + _Softness, dy);
                half armMaskV = 1.0 - smoothstep(_ArmLength, _ArmLength + _ArmFeather, dy);
                half armMaskH = 1.0 - smoothstep(_ArmLength, _ArmLength + _ArmFeather, dx);
                lineV *= armMaskV;
                lineH *= armMaskH;
                half crosshair = max(lineV, lineH);

                // === Gradiente + Hue ===
                half gradFactor = saturate((dUV.y + 1.0) * 0.5);
                half3 gradColor = lerp(_ShapeColor1.rgb, _ShapeColor2.rgb, gradFactor);
                half hue = frac(_HueOffset + t * _HueSpeed);
                gradColor = HueShift(gradColor, hue);

                // === Glow ===
                half pulse = (sin(t * _PulseSpeed) * 0.5 + 0.5) * _PulseStrength;
                half3 crossGlow = gradColor * crosshair * (_Emission + pulse) * _MasterEmission;

                // === Circles + RingRotation + EnergyWave ===
                half1 c1 = (r - _Circle1Size) * 18.00;
                half c2 = (r - _Circle2Size) * 25.00;
                half afterimageNoise = hash12(uv * _AfterimageDensity);
                half afterimage = step(0.98, afterimageNoise) * _AfterimageStrength;
                crossGlow += afterimage * gradColor;

                // Otimização: trca do exp() por pow() para otimizar o cálculo
                half circle = pow(saturate(1.0 - abs(c1)), 4.0 * _Circle1Brightness);
                circle += pow(saturate(1.0 - abs(c2)), 4.0 * _Circle2Brightness);

                half angle = atan2(toCenter.y, toCenter.x);
                half ringRot = sin(angle * 6.0 + t * _RingRotationSpeed) * 0.5 + 0.5;
                circle *= ringRot;

                half wave = sin((r - frac(t * _EnergyWaveSpeed)) * 40.0) * _EnergyWaveStrength;
                circle += wave * 0.2;

                half3 circleGlow = circle * gradColor * 1.2;

                // === Energy Sparks ===
                half sparkNoise = hash12(uv * _SparkDensity);
                half spark = step(0.995, sparkNoise) * _SparkIntensity;
                circleGlow += spark * gradColor;

                // === Flicker ===
                half flicker = (sin(t * _FlickerSpeed) * 0.5 + 0.5) * _FlickerStrength;
                circleGlow *= (1.0 - flicker);

                // === Chromatic Aberration ===
                half3 chroma;
                chroma.r = tex2D(_MainTex, uv + half2(_ChromaticOffset,0)).r;
                chroma.g = tex2D(_MainTex, uv).g;
                chroma.b = tex2D(_MainTex, uv - half2(_ChromaticOffset,0)).b;

                // === Scanline ===
                half3 scanCol = 0;
                if (_EnableScan > 0.5)
                {
                    // Sincronização com o Glitch: Pega a mesma máscara do efeito de glitch existente
                    half glitchMask = step(0.98, frac(sin(t * _GlitchSpeed) * 43758.5453));

                    // Deslocamento Sincronizado: A scanline "pula" apenas quando o glitch acontece
                    half displace_y = glitchMask * (frac(sin(t * _GlitchSpeed + 1.234) * 54321.123) - 0.5) * 0.1;

                    // Ondulação: Adiciona uma leve distorção de seno
                    half y_offset = sin(uv.x * 30.0 + _Time.y * _ScanSpeed) * 0.01;

                    // Calcula a posição da scanline com todos os efeitos
                    half t2 = frac(t * _ScanSpeed + uv.y + y_offset + displace_y);

                    // Afterglow / Brilho: Usa uma função de potência para criar um brilho mais suave no centro
                    half scanMask = pow(abs(t2 - 0.5), 0.5);

                    // Aplica o efeito de scanline
                    half scanline_effect = 1.0 - smoothstep(_ScanWidth, _ScanWidth + 0.02, scanMask);

                    scanCol = scanline_effect * _ScanColor.rgb;
                }

                // === Final composition ===
                half3 col = chroma * bg + crossGlow + circleGlow + scanCol;

                // === Vignette ===
                half vdist = length(uv - half2(0.5, 0.5)) * 2.0;
                half vmask = smoothstep(_VignetteThickness, _VignetteThickness + max(_VignetteFalloff, 1e-4), vdist);
                col *= (1.0 - vmask);

                return half4(col, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
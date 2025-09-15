using UnityEngine;
using UnityEditor;

public class OlhoCrosshairUltra_Fancy_GUI : ShaderGUI
{
    private bool showCrosshair = true;
    private bool showColors = true;
    private bool showAnimations = true;
    private bool showAdvanced = false;

    // 🔹 Estilo para títulos
    private GUIStyle headerStyle;

    public override void OnGUI(MaterialEditor materialEditor, MaterialProperty[] props)
    {
        if (headerStyle == null)
        {
            headerStyle = new GUIStyle(EditorStyles.boldLabel);
            headerStyle.normal.textColor = new Color(0.4f, 0.9f, 1f); // azul-cyberpunk
        }

        EditorGUILayout.Space();
        EditorGUILayout.LabelField("⚡ OlhoCrosshairUltra_Fancy Shader", headerStyle);
        EditorGUILayout.Space();

        // 🎯 CROSSHAIR
        showCrosshair = EditorGUILayout.Foldout(showCrosshair, "🎯 Crosshair", true);
        if (showCrosshair)
        {
            DrawProperties(materialEditor, props, "_Size", "_Thickness", "_ArmLength", "_ArmFeather");
            DrawProperties(materialEditor, props, "_Circle1Size", "_Circle1Brightness", "_Circle2Size", "_Circle2Brightness");
        }
        DrawSeparator();

        // 🌈 COLORS & GLOW
        showColors = EditorGUILayout.Foldout(showColors, "🌈 Cores & Glow", true);
        if (showColors)
        {
            DrawProperties(materialEditor, props, "_EnableRGB"); // Toggle para RGB

            if (FindProperty("_EnableRGB", props).floatValue < 0.5f)
            {
                DrawProperties(materialEditor, props, "_HueOffset", "_HueSpeed");
            }

            DrawProperties(materialEditor, props, "_ShapeColor1", "_ShapeColor2");
            DrawProperties(materialEditor, props, "_GlowColor", "_Emission", "_MasterEmission");
            DrawProperties(materialEditor, props, "_BackgroundColor1", "_BackgroundColor2");
        }
        DrawSeparator();

        // 🔄 ANIMATIONS
        showAnimations = EditorGUILayout.Foldout(showAnimations, "🔄 Animações", true);
        if (showAnimations)
        {
            DrawProperties(materialEditor, props, "_BreathSpeed", "_BreathStrength");
            DrawProperties(materialEditor, props, "_RingRotationSpeed", "_FlickerSpeed", "_FlickerStrength");
            DrawProperties(materialEditor, props, "_PulseSpeed", "_PulseStrength");
        }
        DrawSeparator();

        // ⚙️ ADVANCED FX
        showAdvanced = EditorGUILayout.Foldout(showAdvanced, "⚙️ Efeitos Avançados", true);
        if (showAdvanced)
        {
            DrawProperties(materialEditor, props, "_RippleStrength", "_RippleSpeed");
            DrawProperties(materialEditor, props, "_GlitchStrength", "_GlitchSpeed");
            DrawProperties(materialEditor, props, "_LensStrenght", "_LensFrequency");
            DrawProperties(materialEditor, props, "_SparkDensity", "_SparkIntensity");
            DrawProperties(materialEditor, props, "_ChromaticOffset");
            DrawProperties(materialEditor, props, "_EnableScan", "_ScanSpeed", "_ScanWidth", "_ScanColor");
        }
        DrawSeparator();

        // ✨ Rodapé com sombra gradiente translúcida
        EditorGUILayout.Space();
        Rect creditRect = GUILayoutUtility.GetRect(
            new GUIContent("✦ OlhoCrosshair Cyberpunk — by LiA & Utohpiah ✦"),
            EditorStyles.centeredGreyMiniLabel
        );

        // Texto branco com brilho animado
        GUIStyle creditStyle = new GUIStyle(EditorStyles.centeredGreyMiniLabel);
        creditStyle.normal.textColor = Color.white;
        creditStyle.fontStyle = FontStyle.Italic;

        // 🔥 Animação pulsante no alpha
        float pulse = (Mathf.Sin((float)EditorApplication.timeSinceStartup * 2f) * 0.5f + 0.5f) * 0.5f + 0.5f;
        Color animated = new Color(1f, 1f, 1f, pulse);
        creditStyle.normal.textColor = animated;

        EditorGUI.LabelField(creditRect, "✦ OlhoCrosshair Cyberpunk — by LiA & Utohpiah ✦", creditStyle);
    }

    // 🔹 Helper para desenhar propriedades de forma compacta
    private void DrawProperties(MaterialEditor me, MaterialProperty[] props, params string[] names)
    {
        foreach (var n in names)
        {
            MaterialProperty p = FindProperty(n, props, false);
            if (p != null) me.ShaderProperty(p, p.displayName);
        }
    }

    // 🔹 Separador sutil
    private void DrawSeparator()
    {
        EditorGUILayout.Space(2);
        Rect rect = EditorGUILayout.GetControlRect(false, 1);
        EditorGUI.DrawRect(rect, new Color(0.2f, 0.2f, 0.2f, 0.6f));
        EditorGUILayout.Space(2);
    }
}

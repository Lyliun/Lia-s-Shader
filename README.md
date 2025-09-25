### Cyberpunk Eye Crosshair Shader

A custom shader for Unity that creates a futuristic crosshair effect inside a bionic eye. This project focuses on both performance and aesthetics, utilizing optimizations to run efficiently on various platforms while delivering a detailed and immersive visual experience.

---

### ✨ Key Features

-   **Dynamic Crosshair:** A central crosshair with a color gradient and pulse effect that simulates a living system.
-   **Breathing Animation:** A "breath-in" effect that expands and contracts the crosshair, adding a sense of organic tension.
-   **Glitch & Distortion:** Time-synchronized visual glitches and distortion effects that simulate a malfunctioning interface.
-   **Circles and Rotating Rings:** Animated circles and rings that move, rotate, and emit energy waves from the center.
-   **Noise and Sparks:** The addition of subtle signal noise and energy particles that scatter, reinforcing the holographic aesthetic.
-   **Afterimage (Holographic Trail):** A subtle trail effect that simulates an unstable holographic projection.
-   **Iris Mask:** The shader applies effects only to the iris area, revealing the sclera (the white part of the eye) from the original texture.
-   **Custom Editor:** A custom GUI that allows you to control all shader parameters directly within the Unity Inspector.

---

### 🚀 Performance Optimizations

The code has been carefully refactored to ensure maximum performance, using techniques such as:
-   **`half` Data Types:** Use of reduced precision (`half`) to optimize calculations, ideal for mobile and low-end GPUs.
-   **Optimized Hash Function:** Implementation of a lightweight and efficient pseudo-random hash function (`hash12`).
-   **Clean Code:** Removal of unused variables and code blocks for a cleaner and more efficient shader.

---

### 🖼️ Preview

**(Add a screenshot, GIF, or video of the shader in action here)**

---

### How to Use

1.  Create a new **Material** in Unity.
2.  Set the Material's Shader to `LiaShader/Cyberpunk Crossair`.
3.  Adjust the parameters directly in the Inspector using the custom editor.

---

### Credits

-   **Shader Design & Code:** LiA
-   **Refactoring & Optimization:** LiA

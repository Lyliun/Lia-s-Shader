### Cyberpunk Eye Crosshair Shader

Um shader customizado para Unity que cria um efeito de mira futurista dentro de um olho cibernético. Este projeto se concentra em performance e estética, utilizando otimizações para rodar de forma eficiente em diferentes plataformas, enquanto entrega um visual detalhado e imersivo.

---

### ✨ Principais Características

-   **Mira Dinâmica:** Mira central com gradiente de cor e efeito de pulso, que simula um sistema vivo.
-   **Animação de Respiração:** Um efeito de "breath-in" que expande e contrai a mira, dando uma sensação orgânica e de tensão.
-   **Glitch e Distorção:** Efeitos de falha e distorção sincronizados com o tempo para simular uma interface com defeito.
-   **Círculos e Anéis Rotativos:** Círculos e anéis que se movem, giram e emitem ondas de energia a partir do centro.
-   **Ruído e Faíscas:** Adição de ruído de sinal sutil e partículas de energia que se dispersam, reforçando a estética holográfica.
-   **Afterimage (Rastro Fantasma):** Um rastro sutil que simula uma projeção holográfica instável.
-   **Máscara de Íris:** O shader aplica os efeitos somente na área da íris, revelando a textura original da esclera (a parte branca do olho).
-   **Editor Personalizado:** Um GUI customizado que permite controlar todos os parâmetros do shader diretamente no Inspector da Unity.

---

### 🚀 Otimizações de Performance

O código foi cuidadosamente refatorado para garantir o máximo de desempenho, utilizando técnicas como:
-   **Tipos de Dados `half`:** Uso de precisão reduzida (`half`) para otimizar cálculos, ideal para GPUs de dispositivos móveis.
-   **Função Hash Otimizada:** Implementação de uma função hash pseudo-aleatória (`hash12`) leve e eficiente.
-   **Código Enxuto:** Remoção de variáveis e blocos de código não utilizados para um shader mais limpo e leve.

---

### 🖼️ Pré-visualização

**(Adicione aqui uma captura de tela, GIF ou vídeo do shader em ação)**

---

### Como Usar

1.  Crie um novo **Material** na Unity.
2.  Defina o Shader do Material para `LiaShader/Cyberpunk Crossair`.
3.  Ajuste os parâmetros diretamente no Inspector usando o editor customizado.

---

### Créditos

-   **Shader Design & Code:** LiA
-   **Refatoração & Otimização:** Lia

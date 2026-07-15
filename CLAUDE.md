# SkillFix — Guía para Claude

App **Flutter/Dart** (ver `pubspec.yaml`). Código principal en `lib/`.

## Regla: usar el grafo de conocimiento de Graphify

Antes de analizar, explicar o modificar el código de este proyecto, **consultá primero el grafo de Graphify** en `graphify-out/`. Es el mapa de cómo se relacionan archivos, clases y funciones del código Dart. Úsalo para orientarte antes de leer archivos a ciegas.

### Paso 0 — asegurar que el grafo esté fresco

El grafo se desactualiza cuando cambia el código. Si notás que `lib/` se modificó desde la última extracción (o ante la duda), regeneralo **bajo demanda** antes de consultarlo. Es rápido y **no usa API key** (AST local con tree-sitter):

```bash
export PATH="$HOME/.local/bin:$PATH"
graphify extract ./lib --code-only --out .   # re-extrae y escribe en ./graphify-out/ (sin LLM)
```

> Importante: usar `--out .` para que la salida quede en `./graphify-out/` (la ubicación que consultan los comandos por defecto). No uses `graphify update ./lib`: ese comando escribe en `lib/graphify-out/` y crea una copia duplicada.

### Consultar el grafo

```bash
export PATH="$HOME/.local/bin:$PATH"
graphify query "<pregunta>"          # recorrido BFS del grafo para una pregunta
graphify explain "<Nodo>"            # explica un nodo y sus vecinos (ej: "YoutubeService")
graphify affected "<Nodo>"           # qué nodos se ven impactados si tocás X (traversal inverso)
graphify path "A" "B"                # camino más corto entre dos nodos
```

Fuentes de referencia ya generadas: `graphify-out/graph.json` (grafo consultable), `graphify-out/GRAPH_REPORT.md` (resumen), `graphify-out/graph.html` (visualización).

### Regenerar la visualización/reporte (opcional)

```bash
export PATH="$HOME/.local/bin:$PATH"
graphify cluster-only . --no-label   # regenera graph.html + GRAPH_REPORT.md sin LLM
```

> `graphify-out/` está en `.gitignore` (salida generada, no se commitea). La herramienta `graphifyy` está instalada vía pipx en `~/.local/bin/graphify`.

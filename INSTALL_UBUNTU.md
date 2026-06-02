# Ubuntu dev environment (WSL2)

Esta es mi guía de referencia para levantar un entorno Ubuntu desde cero, orientada a WSL2 con Windows Terminal. La uso cada vez que configuro una máquina nueva o reinstalo una distro. No pretende ser exhaustiva — es exactamente lo que yo instalo.

El stack principal es Python (uv + micromamba para bioinformática), con herramientas de terminal que prefiero sobre las que vienen por defecto.

---

## Base del sistema

Lo primero antes de cualquier cosa:

```bash
sudo apt update && sudo apt upgrade -y
```

### Paquetes esenciales

```bash
sudo apt install -y \
  build-essential \
  curl wget unzip git \
  zsh tmux \
  jq tree
```

---

## Shell: zsh

```bash
sudo apt install -y zsh
chsh -s $(which zsh)
```

Reiniciar la sesión. Los plugins y la configuración se instalan aparte — ver el [README de dotfiles](./README.md#instalación).

---

## Terminal utilities

Estas son las herramientas que reemplazan a los comandos clásicos del sistema. Las uso a diario.

```bash
sudo apt install -y \
  bat \
  btop \
  duf \
  fd-find \
  fzf \
  htop \
  ncdu \
  ranger \
  ripgrep
```

| Herramienta | Reemplaza a | Para qué |
|---|---|---|
| `bat` | `cat` | Paginador con syntax highlighting y números de línea |
| `btop` | `top` / `htop` | Monitor de recursos interactivo con gráficas |
| `duf` | `df` | Uso de disco con visualización por colores |
| `fd` | `find` | Búsqueda de archivos rápida y ergonómica |
| `fzf` | — | Fuzzy finder — `Ctrl+R` historial, `Ctrl+T` archivos |
| `ncdu` | `du` | Uso de disco navegable en terminal |
| `ranger` | — | Explorador de archivos en terminal con vim keybindings |
| `ripgrep` | `grep` | Búsqueda en código, ignora `.git` y archivos binarios por defecto |

**Nota Debian:** `bat` se instala como `batcat` y `fd` como `fdfind`. Para usarlos con su nombre canónico, agrega estos alias a `~/.bash_aliases` o `~/.zshrc`:

```bash
alias bat='batcat'
alias fd='fdfind'
```

---

## Visualización y documentos

```bash
sudo apt install -y \
  graphviz \
  lynx \
  pandoc \
  poppler-utils
```

| Herramienta | Para qué |
|---|---|
| `graphviz` | Renderizar gráficos DOT — útil para diagramas de arquitectura y dependencias |
| `lynx` | Navegador web en terminal — útil para ver docs y APIs rápidamente |
| `pandoc` | Convertir entre formatos de documento (Markdown → PDF, HTML, DOCX…) |
| `poppler-utils` | Manipular PDFs desde la línea de comandos (`pdftotext`, `pdfinfo`, etc.) |

---

## Contenedores

```bash
sudo apt install -y podman
```

Prefiero Podman sobre Docker por ser daemonless y no requerir root. En WSL2 funciona igual de bien para el uso cotidiano.

---

## SSH: keychain

```bash
sudo apt install -y keychain
```

Evita que te pida el passphrase de SSH en cada sesión nueva. `ssh-agent.zsh` ya gestiona esto automáticamente al iniciar zsh.

---

## Python

### uv

El gestor de entornos y paquetes que uso para todos mis proyectos Python.

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Se instala en `~/.local/bin/uv`. Reiniciar la sesión o hacer `source ~/.local/bin/env`.

Uso básico:

```bash
uv venv              # crea .venv en el directorio actual
uv pip install ...   # instala paquetes
uv run python ...    # corre sin activar el venv
uv tool install ...  # instala CLIs globales (como pipx)
```

Con direnv, agrego `layout uv` al `.envrc` del proyecto y el entorno se activa automáticamente al entrar al directorio.

### micromamba

Para proyectos de bioinformática que requieren paquetes de conda (bcftools, htslib, herramientas del ecosistema Bioconda).

```bash
"${SHELL}" <(curl -L micro.mamba.pm/install.sh)
```

Se instala en `~/micromamba`. El shell hook se carga en `apps-paths.zsh` y habilita `micromamba activate`.

Entornos que mantengo:

```bash
micromamba create -n genomics-core -c bioconda -c conda-forge \
  bcftools htslib samtools
```

---

## Ruby

Necesario para `teamocil` (gestor de layouts de tmux).

```bash
sudo apt install -y ruby-full
gem install teamocil
```

`teamocil` permite definir layouts de tmux en YAML y abrirlos con un comando. Mis layouts viven en `~/.teamocil/`.

---

## Dependencias de compilación para Python

Necesarias para compilar extensiones C en paquetes como `psycopg2`, `lxml`, `cryptography` y librerías de bioinformática.

```bash
sudo apt install -y \
  libbz2-dev \
  libffi-dev \
  liblzma-dev \
  libpq-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  libxslt1-dev \
  libgraphviz-dev \
  python3-dev \
  zlib1g-dev \
  pkg-config
```

Si algo falla al compilar un paquete Python, es casi siempre una de estas.

---

## wtfutil

Dashboard en terminal. El binario se descarga directamente desde GitHub Releases — no está en apt.

```bash
VERSION="0.49.1"
curl -sLO "https://github.com/wtfutil/wtf/releases/download/v${VERSION}/wtf_${VERSION}_linux_amd64.tar.gz"
tar xzf "wtf_${VERSION}_linux_amd64.tar.gz"
sudo mv wtf /usr/local/bin/wtfutil
rm "wtf_${VERSION}_linux_amd64.tar.gz"
```

La config vive en `~/.config/wtf/config.yml` — incluida en este repo.

---

## Orden de instalación recomendado

Si estás levantando una máquina desde cero, este es el orden que tiene sentido:

1. **Base + zsh** — sin esto nada más funciona
2. **dotfiles** — trae la config de zsh, tmux, vim y los demás
3. **Plugins de zsh** — `git clone` según el README
4. **uv** — instalar antes de cualquier proyecto Python
5. **Terminal utilities** — el bloque de apt de una sola vez
6. **micromamba** — solo si hay proyectos de bioinformática
7. **Ruby + teamocil** — opcional, al final
8. **wtfutil** — opcional, al final

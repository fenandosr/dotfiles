# dotfiles

Configuración personal para **WSL2 + Windows Terminal**, **macOS + iTerm2**, y servers Linux genéricos.

El repo usa `$HOME` como worktree: cada rama trae archivos reales a `$HOME`, no symlinks. Un host se arma **componiendo ramas por eje** en vez de mantener una rama completa por combinación.

---

## Modelo de ramas

| Rama | Eje | Contenido |
|---|---|---|
| `base` | — | Común a todo host: git, aliases, vim, tmux, ranger, `install.sh` |
| `os-wsl2` / `os-macos` / `os-linux` | OS | Env pineado por OS + manifiesto de paquetes (apt/brew) |
| `shell-zsh` / `shell-bash` | shell | `.zshrc`/`.bashrc` como loaders de fragmentos |
| `profile-full` | perfil | Plugins pesados de zsh (submodules), direnv, wtf, tooling de Jupyter/genómica |

`profile-full` es puramente aditivo — nunca borra algo que otra rama agregó — así que compone sin conflictos sobre cualquier combinación de `os-*`/`shell-*`. **Minimal = no mergear `profile-full`**, no existe una rama `profile-minimal` separada.

`main` se mantiene como rama "todo en uno" de referencia (self-detección de OS en runtime), sin depender de este esquema.

### Cómo evita conflictos el merge

`.zshrc`/`.bashrc` no editan las mismas líneas en cada rama — son loaders delgados que hacen `source` de fragmentos:

- `~/.shell.d/*.sh` — env específico de OS, compartido entre bash y zsh (lo trae `os-*`)
- `~/.zsh.d/*.zsh` — `00-core.zsh` (completions, fzf, de `shell-zsh`) + `50-plugins.zsh` (plugins pesados, de `profile-full`)

Cada rama solo **agrega** archivos a esas carpetas, así que componer varias ramas con `git merge` es una unión de adiciones, no una edición concurrente del mismo archivo.

---

## Bootstrap de un host nuevo

```bash
cd ~
git init
git remote add origin git@github.com:fenandosr/dotfiles.git
git fetch --all
git checkout base   # trae install.sh sin pisar nada más todavía

./install.sh --os wsl2 --shell zsh --profile full
```

`install.sh`:
1. Respalda cualquier archivo real que choque con lo que van a traer las ramas, en `~/.dotfiles-backup/<timestamp>/`.
2. Crea (o reusa) una rama `host/<hostname>` a partir de `origin/base`.
3. Mergea `origin/os-<os>`, `origin/shell-<shell>` y, si `--profile full`, `origin/profile-full`.
4. Inicializa los submodules de zsh (`git submodule update --init`) si aplica.
5. Instala el manifiesto de paquetes compuesto (`.dotfiles/packages*.txt`) vía `apt` o `brew`.
6. Guarda la elección en `~/.dotfiles-host`.

### Actualizar un host existente

```bash
~/bin/dotfiles-update
```

Relee `~/.dotfiles-host` y vuelve a mergear las mismas ramas (`git fetch` + `git merge`), sin tener que repetir los flags.

### Pendientes manuales tras el bootstrap

```bash
vim +PlugInstall +qall       # plugins de vim (vim-plug)
chsh -s $(which zsh)         # si el shell elegido fue zsh
```

`wtfutil` no tiene paquete en apt — descarga el binario desde [releases](https://github.com/wtfutil/wtf/releases) (en macOS: `brew install wtfutil`, ya cubierto por el manifiesto de `profile-full`).

---

## Herramientas

### Shell
| Herramienta | Rama | Descripción |
|---|---|---|
| [zsh](https://zsh.org) | `shell-zsh` | Shell principal |
| [zsh-files](https://github.com/fenandosr/zsh-files) | `profile-full` | Config propia — aliases, paths, historial, prompt, ssh-agent |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | `profile-full` | Sugerencias basadas en historial |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | `profile-full` | Highlighting de comandos en tiempo real |
| [zsh-z](https://github.com/agkozak/zsh-z) | `profile-full` | Navegación rápida por directorios frecuentes |
| [zsh-completions](https://github.com/zsh-users/zsh-completions) | `profile-full` | Completions adicionales para zsh |
| [fzf](https://github.com/junegunn/fzf) | `shell-zsh` | Búsqueda fuzzy — `Ctrl+R` historial, `Ctrl+T` archivos, `Alt+C` directorios |

### Terminal
| Herramienta | Rama | Descripción |
|---|---|---|
| [tmux](https://github.com/tmux/tmux) | `base` | Multiplexor de terminal — prefix `C-q` |
| [ranger](https://github.com/ranger/ranger) | `base` | Explorador de archivos en terminal |
| [wtfutil](https://wtfwidget.com) | `profile-full` | Dashboard en terminal |
| [direnv](https://direnv.net) | `profile-full` | Carga automática de variables de entorno por directorio |
| [alacritty](https://alacritty.org) | `profile-full` | Configs opcionales (dark/light/windows) |

### Editores
| Herramienta | Rama | Descripción |
|---|---|---|
| [vim](https://vim.org) | `base` | Editor principal — plugins via vim-plug |

### Python / Data (`profile-full`)
| Herramienta | Descripción |
|---|---|
| [uv](https://docs.astral.sh/uv/) | Gestión de entornos y paquetes Python |
| [micromamba](https://mamba.readthedocs.io) | Entornos conda ligeros |
| `bin/jlab`, `jn-genomics` | Lanzan JupyterLab/Notebook desde el env conda correspondiente |
| `bin/*-register-kernel` | Registra un env (uv o conda) como kernel de Jupyter |
| `.config/systemd/user/*.service` | Unidades para correr Jupyter/túneles como servicio de usuario |

### Scripts en `~/bin/`
| Script | Rama | Descripción |
|---|---|---|
| `add-ssh-key` | `base` | Genera llave SSH e imprime la pública |
| `init-sudo` | `base` | Configura sudoers sin contraseña para el usuario actual |
| `dotfiles-update` | `base` | Re-mergea las ramas del host según `~/.dotfiles-host` |
| `jlab`, `jn-genomics` | `profile-full` | Lanzan JupyterLab/Notebook desde el env conda correspondiente |
| `conda-register-kernel`, `uv-register-kernel` | `profile-full` | Registra un env (uv o conda) como kernel de Jupyter |

`~/.local/bin` es del host (uv, micromamba, wtfutil, symlinks de tool-installs) — nunca se trackea en el repo.

---

## Estructura

```
~
├── install.sh               # Bootstrap: compone ramas, respalda, instala paquetes
├── .dotfiles/
│   ├── packages.txt          # Manifiesto de la rama os-* (apt/brew)
│   ├── packages-shell.txt    # Manifiesto de la rama shell-*
│   └── packages-full.txt     # Manifiesto extra de profile-full
├── .shell.d/*.sh              # Fragmentos de env por OS (bash + zsh)
├── .zsh.d/*.zsh                # Fragmentos de zsh: 00-core, 50-plugins
├── .zshrc / .bashrc           # Loaders delgados (shell-zsh / shell-bash)
├── .tmux.conf                # Multiplexor — prefix C-q, vi mode, clipboard cross-platform
├── .vimrc                    # Vim — vim-plug, cyberpunk theme, airline
├── .bash_aliases             # Aliases compartidos
├── .gitconfig                # Git global — aliases, autocrlf, defaultBranch
├── .config/
│   ├── direnv/direnvrc        # profile-full: layouts uv, python-venv, pyenv, poetry
│   ├── ranger/rc.conf          # base: muestra archivos ocultos
│   ├── wtf/                    # profile-full: dashboard
│   ├── systemd/user/           # profile-full: servicios de Jupyter
│   └── alacritty/              # profile-full: configs opcionales
└── bin/                      # Scripts de utilidad
```

---

## Plataformas

| Característica | WSL2 | macOS | Linux server |
|---|---|---|---|
| Clipboard tmux | `clip.exe` (self-detectado en `.tmux.conf`) | `pbcopy` | — |
| fzf | `/usr/share/doc/fzf/examples/` | `/opt/homebrew/opt/fzf/shell/` | `/usr/share/doc/fzf/examples/` |
| Homebrew | — | `os-macos` activa `brew shellenv` | — |
| Gestor de paquetes | apt (`os-wsl2`) | brew (`os-macos`) | apt (`os-linux`) |

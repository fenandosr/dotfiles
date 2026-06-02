# dotfiles

Configuración personal para **WSL2 + Windows Terminal** y **macOS + iTerm2**.

---

## Herramientas

### Shell
| Herramienta | Descripción |
|---|---|
| [zsh](https://zsh.org) | Shell principal |
| [zsh-files](https://github.com/fenandosr/zsh-files) | Configuración zsh propia — aliases, paths, historial, prompt, ssh-agent |
| [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) | Sugerencias basadas en historial |
| [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) | Highlighting de comandos en tiempo real |
| [zsh-z](https://github.com/agkozak/zsh-z) | Navegación rápida por directorios frecuentes |
| [zsh-completions](https://github.com/zsh-users/zsh-completions) | Completions adicionales para zsh |
| [fzf](https://github.com/junegunn/fzf) | Búsqueda fuzzy — `Ctrl+R` historial, `Ctrl+T` archivos, `Alt+C` directorios |
| [peco](https://github.com/peco/peco) | Filtro interactivo — fallback de `Ctrl+R` en macOS sin fzf |

### Terminal
| Herramienta | Descripción |
|---|---|
| [tmux](https://github.com/tmux/tmux) | Multiplexor de terminal — prefix `C-q` |
| [ranger](https://github.com/ranger/ranger) | Explorador de archivos en terminal |
| [wtfutil](https://wtfwidget.com) | Dashboard en terminal |
| [direnv](https://direnv.net) | Carga automática de variables de entorno por directorio |

### Editores
| Herramienta | Descripción |
|---|---|
| [vim](https://vim.org) | Editor principal — plugins via Vundle |

### Python / Data
| Herramienta | Descripción |
|---|---|
| [uv](https://docs.astral.sh/uv/) | Gestión de entornos y paquetes Python |
| [micromamba](https://mamba.readthedocs.io) | Entornos conda ligeros |

### Scripts en `~/bin/`
| Script | Descripción |
|---|---|
| `add-ssh-key` | Genera llave SSH e imprime la pública para GitHub |
| `aws_perms_check` | Verifica auth de AWS CLI y permisos de Route53 |
| `r53_add_record` | Agrega un registro a una hosted zone de Route53 |
| `r53_zone_or_buy` | Crea hosted zone o muestra info de compra si el dominio está disponible |
| `init-sudo` | Configura sudoers sin contraseña para el usuario actual |

---

## Instalación

### Prerequisitos

**WSL2 / Linux**
```bash
sudo apt install zsh tmux vim fzf ranger direnv
```

**macOS**
```bash
brew install zsh tmux vim fzf ranger direnv
```

**Plugins de zsh** (misma ruta en ambos sistemas):
```bash
mkdir -p ~/.zsh
git clone https://github.com/fenandosr/zsh-files                ~/.zsh/zsh-files
git clone https://github.com/zsh-users/zsh-autosuggestions      ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting   ~/.zsh/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z                       ~/.zsh/zsh-z
git clone https://github.com/zsh-users/zsh-completions           ~/.zsh/zsh-completions
```

> `zsh-files` es el repo propio con aliases, paths de apps, historial, prompt y ssh-agent.
> El `.zshrc` lo carga con `source ~/.zsh/zsh-files/init.zsh`.

**peco** (fallback de `Ctrl+R` en macOS si no está fzf):
```bash
brew install peco
```

**wtfutil**
```bash
# Linux (descarga el binario desde https://github.com/wtfutil/wtf/releases)
# macOS
brew install wtfutil
```

**Vundle** (plugins de vim):
```bash
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
```

### Clonar los dotfiles

El repo usa `~` como worktree. Para no pisar archivos existentes, clona así:

```bash
cd ~
git init
git remote add origin git@github.com:fenandosr/dotfiles.git
git fetch --all

# Respalda cualquier archivo que ya exista
mkdir -p ~/.dotfiles-backup
for f in $(git ls-tree --name-only origin/main); do
  [[ -f "$HOME/$f" ]] && mv "$HOME/$f" ~/.dotfiles-backup/
done

git checkout main
```

> Los archivos respaldados quedan en `~/.dotfiles-backup/`.

### Post-instalación

**Instalar plugins de vim:**
```
vim +PluginInstall +qall
```

**Configurar shell por defecto:**
```bash
chsh -s $(which zsh)
```

**Recargar configuración de tmux** (si ya hay una sesión activa):
```
C-q r
```

---

## Estructura

```
~
├── .tmux.conf              # Multiplexor — prefix C-q, vi mode, cross-platform clipboard
├── .vimrc                  # Vim — Vundle, cyberpunk theme, airline
├── .zshrc                  # Zsh — plugins, fzf, detección de plataforma
├── .bash_aliases           # Aliases compartidos (sourced desde .bashrc y .zshrc)
├── .gitconfig              # Git global — aliases, autocrlf, defaultBranch
├── .config/
│   ├── direnv/direnvrc     # Layouts: uv, python-venv, pyenv, poetry
│   ├── ranger/rc.conf      # Muestra archivos ocultos
│   └── wtf/
│       ├── config.yml      # Dashboard: git, disco, memoria, feeds de genómica
│       └── todo.txt        # Lista de pendientes del dashboard
└── bin/                    # Scripts de utilidad (AWS, SSH, sudo)
```

---

## Plataformas

| Característica | WSL2 | macOS |
|---|---|---|
| Clipboard tmux | `clip.exe` | `pbcopy` |
| fzf | `/usr/share/doc/fzf/examples/` | `/opt/homebrew/opt/fzf/shell/` |
| Homebrew | — | activado automáticamente en `.zshrc` |
| `default-terminal` tmux | `tmux-256color` | `tmux-256color` |

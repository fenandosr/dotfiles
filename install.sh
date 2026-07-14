#!/usr/bin/env bash
set -euo pipefail

# Bootstrapea dotfiles en un host nuevo componiendo ramas de git:
#   base + os-<os> + shell-<shell> [+ profile-full]
#
# El repo usa $HOME como worktree (cada rama trae sus propios archivos
# reales a $HOME, no symlinks). Correr desde dentro de ese worktree.

usage() {
  cat <<EOF
Uso: install.sh --os {wsl2|macos|linux} --shell {zsh|bash} [--profile {minimal|full}]

  --os        Rama os-<os> a componer.
  --shell     Rama shell-<shell> a componer.
  --profile   minimal (default) u full (agrega profile-full: plugins
              pesados de zsh, direnv, wtf, tooling de jupyter/genómica).

Ejemplo:
  ./install.sh --os wsl2 --shell zsh --profile full
EOF
  exit 1
}

OS="" SHELL_CHOICE="" PROFILE="minimal"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --os) OS="$2"; shift 2 ;;
    --shell) SHELL_CHOICE="$2"; shift 2 ;;
    --profile) PROFILE="$2"; shift 2 ;;
    -h|--help) usage ;;
    *) echo "Flag desconocida: $1" >&2; usage ;;
  esac
done

[[ -z "$OS" || -z "$SHELL_CHOICE" ]] && usage
case "$OS" in wsl2|macos|linux) ;; *) echo "OS inválido: $OS" >&2; usage ;; esac
case "$SHELL_CHOICE" in zsh|bash) ;; *) echo "shell inválido: $SHELL_CHOICE" >&2; usage ;; esac
case "$PROFILE" in minimal|full) ;; *) echo "profile inválido: $PROFILE" >&2; usage ;; esac

cd "$HOME"

if [[ ! -d .git ]]; then
  echo "==> No hay repo git en \$HOME. Inicializando."
  git init
  git remote add origin git@github.com:fenandosr/dotfiles.git
fi

echo "==> git fetch --all"
git fetch --all --quiet

BRANCHES=(base "os-$OS" "shell-$SHELL_CHOICE")
[[ "$PROFILE" == full ]] && BRANCHES+=(profile-full)
echo "==> Componiendo: ${BRANCHES[*]}"

# Respalda archivos reales (no trackeados aún por este repo) que choquen
# con lo que van a traer las ramas, antes de tocar nada.
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
BACKED_UP=0
for b in "${BRANCHES[@]}"; do
  while IFS= read -r f; do
    [[ -z "$f" ]] && continue
    if [[ -e "$f" && ! -L "$f" ]] && ! git ls-files --error-unmatch "$f" &>/dev/null; then
      mkdir -p "$BACKUP_DIR/$(dirname "$f")"
      mv "$f" "$BACKUP_DIR/$f"
      echo "  backup: $f -> $BACKUP_DIR/$f"
      BACKED_UP=1
    fi
  done < <(git ls-tree -r --name-only "origin/$b" 2>/dev/null || true)
done
[[ "$BACKED_UP" == 1 ]] && echo "==> Archivos respaldados en $BACKUP_DIR"

HOST_BRANCH="host/$(hostname)"
if git show-ref --verify --quiet "refs/heads/$HOST_BRANCH"; then
  git checkout "$HOST_BRANCH"
else
  git checkout -b "$HOST_BRANCH" "origin/base"
fi

echo "==> git merge ${BRANCHES[*]}"
git merge --no-edit "${BRANCHES[@]/#/origin/}"

if [[ "$SHELL_CHOICE" == zsh && "$PROFILE" == full ]]; then
  echo "==> Inicializando submodules de zsh"
  git submodule update --init --recursive
fi

echo "==> Instalando paquetes"
PKG_FILES=(.dotfiles/packages.txt .dotfiles/packages-shell.txt)
[[ "$PROFILE" == full ]] && PKG_FILES+=(.dotfiles/packages-full.txt)
PACKAGES=()
for pf in "${PKG_FILES[@]}"; do
  [[ -f "$pf" ]] || continue
  while IFS= read -r line; do
    line="${line%%#*}"
    line="$(echo "$line" | xargs)"
    [[ -n "$line" ]] && PACKAGES+=("$line")
  done < "$pf"
done

if [[ ${#PACKAGES[@]} -gt 0 ]]; then
  case "$OS" in
    wsl2|linux) sudo apt-get update && sudo apt-get install -y "${PACKAGES[@]}" ;;
    macos) brew install "${PACKAGES[@]}" ;;
  esac
else
  echo "  (nada que instalar)"
fi

mkdir -p "$HOME/bin"
chmod +x "$HOME"/bin/* 2>/dev/null || true
chmod +x "$HOME"/.local/bin/* 2>/dev/null || true

cat > "$HOME/.dotfiles-host" <<HOSTEOF
os=$OS
shell=$SHELL_CHOICE
profile=$PROFILE
bootstrapped=$(date -Iseconds)
HOSTEOF

echo ""
echo "==> Listo. Rama activa: $HOST_BRANCH ($(git rev-parse --short HEAD))"
echo "Config de host guardada en ~/.dotfiles-host (usada por bin/dotfiles-update)."
echo ""
echo "Pendientes manuales:"
echo "  - vim +PluginInstall +qall"
[[ "$SHELL_CHOICE" == zsh ]] && echo "  - chsh -s \$(which zsh)"
echo "  - config específica de esta máquina va en ~/.zshrc.local, ~/.bashrc.local, ~/.gitconfig.local"

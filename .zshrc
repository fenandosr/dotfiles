# -----------------------------
# Locale
# -----------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en_US.UTF-8}"
# Avoid forcing LC_ALL unless needed:
export LC_ALL=en_US.UTF-8

# -----------------------------
# Editor
# -----------------------------
export EDITOR="${EDITOR:-vim}"

# -----------------------------
# Environment (PATH, etc.)
# -----------------------------
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# -----------------------------
# OS detection
# -----------------------------
case "$OSTYPE" in
  darwin*)
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    ;;
  linux-gnu*)
    if [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
      # WSL: interop PATH cleanup (keeps Windows tools available but at the end)
      export PATH="$PATH:/mnt/c/Windows/System32"
    fi
    ;;
esac

# -----------------------------
# Completions
# -----------------------------
if [[ -d "$HOME/.zsh/zsh-completions/src" ]]; then
  fpath=("$HOME/.zsh/zsh-completions/src" $fpath)
fi

autoload -Uz compinit
# Use a cached dump file for speed
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# -----------------------------
# Plugins (safe sourcing)
# -----------------------------
# fzf: paths differ between Debian/Ubuntu (apt) and macOS (Homebrew)
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

if [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -f "$HOME/.zsh/zsh-z/zsh-z.plugin.zsh" ]]; then
  source "$HOME/.zsh/zsh-z/zsh-z.plugin.zsh"
fi

if [[ -f "$HOME/.zsh/zsh-files/init.zsh" ]]; then
  source "$HOME/.zsh/zsh-files/init.zsh"
fi

# Syntax highlighting (load last)
if [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi


# -----------------------------
# Locale
# -----------------------------
export LANG="${LANG:-en_US.UTF-8}"
export LANGUAGE="${LANGUAGE:-en_US.UTF-8}"
# Avoid forcing LC_ALL unless needed:
# export LC_ALL=en_US.UTF-8

# -----------------------------
# Editor
# -----------------------------
export EDITOR="${EDITOR:-vim}"

# -----------------------------
# Environment (PATH, etc.)
# -----------------------------
[[ -r "$HOME/.local/bin/env" ]] && source "$HOME/.local/bin/env"

# -----------------------------
# OS detection (hooks)
# -----------------------------
case "$OSTYPE" in
  darwin*)
    # macOS-specific (optional)
    # Homebrew shellenv (uncomment if you use brew)
    # if [[ -x /opt/homebrew/bin/brew ]]; then
    #   eval "$(/opt/homebrew/bin/brew shellenv)"
    # elif [[ -x /usr/local/bin/brew ]]; then
    #   eval "$(/usr/local/bin/brew shellenv)"
    # fi
    ;;
  linux-gnu*)
    # Linux-specific (optional)
    # WSL detection example:
    # if [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
    #   :
    # fi
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


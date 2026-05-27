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
# OS detection (hooks)
# -----------------------------
case "$OSTYPE" in
  darwin*)
    for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      [[ -x "$brew_path" ]] && eval "$("$brew_path" shellenv)" && break
    done
    ;;
  linux-gnu*)
    if [[ -r /proc/version ]] && grep -qi microsoft /proc/version; then
      alias pbcopy='clip.exe'
      alias pbpaste='powershell.exe -command "Get-Clipboard" 2>/dev/null | tr -d "\r"'
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
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  #source /usr/share/doc/fzf/examples/completion.zsh
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


# >>> mamba initialize >>>
# !! Contents within this block are managed by 'micromamba shell init' !!
export MAMBA_EXE="$HOME/.local/bin/micromamba"
export MAMBA_ROOT_PREFIX="$HOME/micromamba"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

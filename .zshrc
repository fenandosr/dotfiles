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
# OS-specific env (os-wsl2 / os-macos / os-linux branches)
# -----------------------------
for f in "$HOME"/.shell.d/*.sh(N); do
  source "$f"
done

# -----------------------------
# Shared aliases
# -----------------------------
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"

# -----------------------------
# zsh fragments: core (this branch) + plugins (profile-full branch, if merged)
# Numeric prefix controls load order; syntax-highlighting must load last.
# -----------------------------
for f in "$HOME"/.zsh.d/*.zsh(N); do
  source "$f"
done

# iTerm2 shell integration (macOS only — install via iTerm2 > Install Shell Integration)
[[ -f "$HOME/.iterm2_shell_integration.zsh" ]] && source "$HOME/.iterm2_shell_integration.zsh"

# Machine-specific overrides
[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

# Core zsh setup: completions + compinit. No plugins here —
# plugin fragments (zsh-autosuggestions, etc.) live in .zsh.d/50-*
# and only exist when the profile-full branch is merged in.
if [[ -d "$HOME/.zsh/zsh-completions/src" ]]; then
  fpath=("$HOME/.zsh/zsh-completions/src" $fpath)
fi

autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

# fzf: paths differ between Debian/Ubuntu (apt) and macOS (Homebrew)
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

# Core zsh setup: completions + compinit. No plugins here —
# plugin fragments (zsh-autosuggestions, etc.) live in .zsh.d/50-*
# and only exist when the profile-full branch is merged in.
if [[ -d "$HOME/.zsh/zsh-completions/src" ]]; then
  fpath=("$HOME/.zsh/zsh-completions/src" $fpath)
fi

autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
# compinit won't create the directory; without it the dump is never written
# and -C falls back to a full rebuild on every shell.
[[ -d "${_zcompdump:h}" ]] || mkdir -p "${_zcompdump:h}"
compinit -C -d "$_zcompdump"
unset _zcompdump

# fzf: paths differ between Debian/Ubuntu (apt) and macOS (Homebrew)
if [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
elif [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
fi

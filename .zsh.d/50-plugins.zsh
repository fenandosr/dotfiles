# Heavy zsh UX plugins. This fragment (and the submodules it sources)
# only exists on hosts bootstrapped with --profile full.
if [[ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -f "$HOME/.zsh/zsh-z/zsh-z.plugin.zsh" ]]; then
  source "$HOME/.zsh/zsh-z/zsh-z.plugin.zsh"
fi

if [[ -f "$HOME/.zsh/zsh-files/init.zsh" ]]; then
  source "$HOME/.zsh/zsh-files/init.zsh"
fi

# Syntax highlighting must load last among plugins.
if [[ -f "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

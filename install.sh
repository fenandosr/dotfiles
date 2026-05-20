#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$DOTFILES_DIR/$1" dst="$HOME/$1"
  mkdir -p "$(dirname "$dst")"
  ln -sf "$src" "$dst"
  echo "  linked $dst"
}

echo "==> Linking dotfiles from $DOTFILES_DIR"
link .bashrc
link .bash_aliases
link .zshrc
link .gitconfig
link .tmux.conf
link .vimrc
link .config/direnv/direnvrc
link .config/ranger/rc.conf

echo "==> Linking bin scripts"
mkdir -p "$HOME/bin"
for f in "$DOTFILES_DIR"/bin/*; do
  name="$(basename "$f")"
  ln -sf "$f" "$HOME/bin/$name"
  chmod +x "$f"
  echo "  linked ~/bin/$name"
done

echo ""
echo "Done. Machine-specific config goes in:"
echo "  ~/.zshrc.local   ~/.bashrc.local   ~/.gitconfig.local"

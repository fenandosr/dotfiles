# OS-specific environment, sourced by both .bashrc and .zshrc.
# On the `main` branch this stays runtime-detected (works on any host).
# The os-wsl2 / os-macos / os-linux branches each ship a pinned
# replacement of this file with no detection needed.
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

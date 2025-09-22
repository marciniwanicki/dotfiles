#!/usr/bin/env zsh -e

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Upgrade any already-installed casks
brew upgrade --cask

# Casks (GUI apps) and fonts
casks=(
  iterm2                     # Install iTerm2 for a better terminal experience
  font-meslo-lg-nerd-font    # Install Meslo LG Nerd Font for terminal and editor
  font-jetbrains-mono        # Install JetBrains Mono font for coding
)

# Formulae (CLI tools)
formulae=(
  python3                  # Install Python for scripting and development
  go                       # Install Go for programming
  starship                 # Install starship for a fast shell prompt
  zsh-syntax-highlighting  # Install must-have Zsh extensions
  stow                     # Install stow for .dotfiles linking
  zoxide                   # Install zoxide for easier navigation
  fzf                      # Install fzf for better fuzzy finding
  wget                     # Install wget for downloading files from the web
  dpkg                     # Install dpkg for managing Debian packages
  npm                      # Install npm for managing Node.js packages
  cloc                     # Install cloc for counting lines of code
  jq                       # Install jq for processing JSON
  gh                       # Install gh for GitHub CLI
  ripgrep                  # Install ripgrep for searching files
  fd                       # Install fd for a simple, fast and user-friendly alternative to 'find'
  mc                       # Install mc for a modern replacement for 'ls'
  tree                     # Install tree for displaying directory structures
  tmux                     # Install tmux for terminal multiplexing
  neovim                   # Install neovim for a modern text editor
  bat                      # Install bat for a cat clone with syntax highlighting and Git integration
  tldr                     # Install tldr for simplified and community-driven man pages
  speedtest-cli            # Install speedtest-cli for testing internet bandwidth
)

# Install missing casks only
for pkg in "${casks[@]}"; do
    brew list --cask "$pkg" >/dev/null 2>&1 || brew install --cask "$pkg"
done

# Install missing formulae only
for pkg in "${formulae[@]}"; do
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
done

# Cleanup outdated versions
brew cleanup

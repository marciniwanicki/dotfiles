#!/usr/bin/env zsh -e

# Load brew configurations
source $HOME/.brew
source $HOME/.brew.local

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Upgrade any already-installed casks
brew upgrade --cask

# Casks (GUI apps) and fonts
all_casks=("${casks[@]}" "${local_casks[@]}")

# Formulae (CLI tools)
all_formulae=("${formulae[@]}" "${local_formulae[@]}")

# Install missing casks only
for pkg in "${all_casks[@]}"; do
    brew list --cask "$pkg" >/dev/null 2>&1 || brew install --cask "$pkg"
done

# Install missing formulae only
for pkg in "${all_formulae[@]}"; do
    brew list "$pkg" >/dev/null 2>&1 || brew install "$pkg"
done

# Cleanup outdated versions
brew cleanup

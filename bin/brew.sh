#!/usr/bin/env bash -e

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install starship for a fast shell prompt
brew install starship

# Install must have zsh extensions
brew install zsh-syntax-highlighting

# Install stow for .dotfiles linking
brew install stow

# Install zoxide for easier navigation
brew install zoxide

# Install fzf for better fuzzy finding
brew install fzf

# Install wget for downloading files from the web
brew install wget

# Install dpkg for managing Debian packages
brew install dpkg

# Install npm for managing Node.js packages
brew install npm

# Install cloc for counting lines of code
brew install cloc

# Install jq for processing JSON
brew install jq

# Install gh for GitHub CLI
brew install gh

# Remove outdated versions from the cellar.
brew cleanup

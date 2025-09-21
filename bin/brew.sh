#!/usr/bin/env bash -e

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

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

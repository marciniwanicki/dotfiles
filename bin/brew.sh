#!/usr/bin/env zsh -e

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install fonts for iTerm2
brew install --cask font-meslo-lg-nerd-font
brew install --cask font-jetbrains-mono

# Install iTerm2 for a better terminal experience
brew install iterm2

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

# Install ripgrep for searching files
brew install ripgrep

# Install fd for a simple, fast and user-friendly alternative to 'find'
brew install fd

# Install tree for displaying directory structures
brew install tree

# Install tmux for terminal multiplexing
brew install tmux

# Install neovim for a modern text editor
brew install neovim

# Remove outdated versions from the cellar
brew cleanup

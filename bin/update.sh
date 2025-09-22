#!/usr/bin/env zsh -e

pushd $HOME/.dotfiles
  # Update dotfiles repository
  git pull
  
  # Update fzf-git
  pushd vendor/fzf-git.sh
    git pull
  popd

  # Update zsh-autosuggestions
  pushd vendor/zsh-autosuggestions
    git pull
  popd

  # Update fzf-tab
  pushd vendor/fzf-tab
    git pull
  popd

  # Update brew packages
  ./bin/brew.sh

  # Relink stowed files
  stow -D .
  stow .
popd

exec zsh

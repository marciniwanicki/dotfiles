#!/usr/bin/env zsh

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

  # Update brew packages
  ./bin/brew.sh
popd

exec zsh

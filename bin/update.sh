#!/usr/bin/env zsh

pushd $HOME/.dotfiles
  git pull

  ./bin/brew.sh
popd
exec zsh

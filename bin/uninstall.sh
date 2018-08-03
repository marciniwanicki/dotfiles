#!/usr/bin/env zsh

read -p "Are you sure you want to remove all .dotfiles? " $REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Uninstall oh-my-zsh_history
  uninstall_oh_my_zsh 2> /dev/null

  # TODO: Think about some backup...

  # Remove all synbolic links
  for file in $HOME/.dotfiles/home/.*; do
    rm -rf $HOME/$(basename $file) 2> /dev/null
  done;

  # Remove old .dotfiles
  rm -rf ~/.dotfiles
  rm -rf ~/.dotfiles-local
  rm -rf ~/.zshrc

  echo ".dotfiles have been uninstalled"
fi


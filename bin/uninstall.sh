#!/usr/bin/env zsh

source .common

# Uninstall oh-my-zsh_history
uninstall_oh_my_zsh 2> /dev/null

# Remove all synbolic links
for file in $HOME/.dotfiles/home/.*; do
  rm -rf $HOME/$(basename $file) 2> /dev/null
done;

# Remove old .dotfiles
rm -rf ~/.dotfiles
rm -rf ~/.zshrc

print ".dotfiles have been uninstalled"
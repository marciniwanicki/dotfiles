#!/usr/bin/env zsh

read -q "$REPLY?Are you sure you want to remove all .dotfiles? [y/N] "
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]
then
  # Unlink
  pushd $HOME/.dotfiles
    stow . -D
  popd

  # Uninstall oh-my-zsh
  if [ -d "${ZSH:-$HOME/.oh-my-zsh}" ]; then
    RUNZSH=no CHSH=no sh ~/.oh-my-zsh/tools/uninstall.sh
 fi
 
  # Remove old .dotfiles
  rm -rf ~/.dotfiles
  rm -f ~/.zshrc
 
  echo "Your .dotfiles have been uninstalled"
fi

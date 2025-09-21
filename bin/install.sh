#!/usr/bin/env sh

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_oh_my_zsh {
  export ZSH="$HOME/.oh-my-zsh"

  if [ -d "$ZSH" ]; then
    echo "Error: You already have Oh My Zsh installed. You'll need to remove $ZSH if you want to re-install."
    exit 1
  fi

  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function install_brew_packages() {
  ./brew.sh
}

function setup() {
  cd ~/.dotfiles/bin
  source .common
  install_homebrew
  install_oh_my_zsh
  install_brew_packages
}

function clone() {
  git clone https://github.com/marciniwanicki/dotfiles.git ~/.dotfiles
}

function main() {
  set -e
  clone
  setup
}

main

#!/usr/bin/env zsh -e

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_oh_my_zsh {
  export ZSH="$HOME/.oh-my-zsh"

  if [ -d "$ZSH" ]; then
    echo "Error: You already have Oh My Zsh installed. You'll need to remove $ZSH if you want to re-install."
    exit 1
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" _errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  command -v git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }

  echo "Cloning Oh My Zsh..."
  env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    echo "Error: git clone of oh-my-zsh repo failed"
    exit 1
  }
}

function install_brew_packages() {
  ./brew.sh
}

function install_fzf_git() {
  pushd $HOME/.dotfiles/vendor
  git clone https://github.com/junegunn/fzf-git.sh.git
  popd
}

function install_fzf_tab() {
  pushd $HOME/.dotfiles/vendor
  git clone https://github.com/Aloxaf/fzf-tab.git
  popd
}

function install_zsh_autosuggestions() {
  pushd $HOME/.dotfiles/vendor
  git clone https://github.com/zsh-users/zsh-autosuggestions.git
  popd
}

function setup() {
  pushd $HOME/.dotfiles/bin
  install_homebrew
  install_oh_my_zsh
  install_brew_packages
  install_fzf_git
  install_fzf_tab
  install_zsh_autosuggestions
  popd
  
  pushd $HOME/.dotfiles
  stow .
  popd
  
  echo "Installation complete!"

  exec zsh
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

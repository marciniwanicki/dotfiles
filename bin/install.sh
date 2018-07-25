#!/usr/bin/env zsh

source .common

function uninstall() {
  if [ -d "$HOME/.dotfiles" ]; then
      ./uninstall.sh 2> /dev/null
  fi
}

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_oh_my_zsh {
  export ZSH="$HOME/.dotfiles/oh-my-zsh"

  # Only enable exit-on-error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if ! command -v zsh >/dev/null 2>&1; then
    .error "Zsh is not installed! Please install zsh first!"
    exit
  fi

  if [ -d "$ZSH" ]; then
    .error "You already have Oh My Zsh installed."
    .error "You'll need to remove $ZSH if you want to re-install."
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  .print "Cloning Oh My Zsh..."
  command -v git >/dev/null 2>&1 || {
    .error "git is not installed"
    exit 1
  }
  # The Windows (MSYS) Git is not compatible with normal use on cygwin
  if [ "$OSTYPE" = cygwin ]; then
    if git --version | grep msysgit > /dev/null; then
      .error "Windows/MSYS Git is not supported on Cygwin"
      .error "Make sure the Cygwin git package is installed and is first on the path"
      exit 1
    fi
  fi
  env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    .error "git clone of oh-my-zsh repo failed\n"
    exit 1
  }


  .print "Looking for an existing zsh config..."
  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    .print "Found ~/.zshrc.Backing up to ~/.zshrc.pre-oh-my-zsh";
    mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
  fi

  .print "Using the Oh My Zsh template file and adding it to ~/.zshrc"
  cp "$ZSH"/templates/zshrc.zsh-template ~/.dotfiles/home/.zshrc
  sed "/^export ZSH=/ c\\
  export ZSH=\"$ZSH\"
  " ~/.dotfiles/home/.zshrc > ~/.zshrc-omztemp
  mv -f ~/.zshrc-omztemp ~/.dotfiles/home/.zshrc
  ln -s ~/.dotfiles/home/.zshrc ~/.zshrc

  for file in $HOME/.dotfiles/home/.{exports,aliases,commands,functions,history}; do
    echo "source $file" >> ~/.dotfiles/home/.zshrc
  done;

  # If this user's login shell is not already "zsh", attempt to switch.
  TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
  if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    # If this platform provides a "chsh" command (not Cygwin), do it, man!
    if hash chsh >/dev/null 2>&1; then
      .print "Time to change your default shell to zsh!\n"
      chsh -s $(grep /zsh$ /etc/shells | tail -1)
    # Else, suggest the user do so manually.
    else
      .print "I can't change your shell automatically because this system does not have chsh.\n"
      .print "Please manually change your default shell to zsh!\n"
    fi
  fi

  for file in $HOME/.dotfiles/home/.*; do
    filename=$(basename $file)
    if [ $filename = ".zshrc" ] || [ $filename = "." ] || [ $filename = ".." ]; then
      continue
    fi
    ln -s $file $HOME/$(basename $file)
  done;

  .print 'Oh My Zsh is now installed'
}

function install_or_rather_brew() {
  read "REPLY?Do you want to brew some great programs? "
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    ./brew.sh
  fi
}

function launch_zsh() {
  .print "Launching zsh..."
  env zsh -l
}

function setup() {
  install_homebrew
  install_oh_my_zsh
  install_or_rather_brew
}

function clone() {
  # sh -c "$(curl -fsSL https://bitbucket.org/marciniwanicki/dotfiles/raw/master/bin/install.sh)"
  git clone git@bitbucket.org:marciniwanicki/dotfiles.git ~/.dotfiles
  cd ~/dotfiles/bin
}

function copy() {
  rm -rf ~/.dotfiles 2> /dev/null
  mkdir ~/.dotfiles
  cp -r .. ~/.dotfiles/
}

function main() {
  .print "Started .dotfiles installation"
  uninstall
  if git rev-parse --git-dir > /dev/null 2>&1; then
    copy
  else
    clone
  fi
  setup
  launch_zsh
}

main

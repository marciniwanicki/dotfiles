#!/usr/bin/env sh

function uninstall() {
  if [ -d "$HOME/.dotfiles" ]; then
      cd ~/.dotfiles/bin
      ./uninstall.sh 2> /dev/null
  fi
}

function install_homebrew() {
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_oh_my_zsh {
  export ZSH="$HOME/.dotfiles/oh-my-zsh"

  # Only enable exit-on-_error after the non-critical colorization stuff,
  # which may fail on systems lacking tput or terminfo
  set -e

  if ! command -v zsh >/dev/null 2>&1; then
    _error "Zsh is not installed! Please install zsh first!"
    exit
  fi

  if [ -d "$ZSH" ]; then
    _error "You already have Oh My Zsh installed."
    _error "You'll need to remove $ZSH if you want to re-install."
    exit
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" _errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  _print "Cloning Oh My Zsh..."
  command -v git >/dev/null 2>&1 || {
    _error "git is not installed"
    exit 1
  }
 
  env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    _error "git clone of oh-my-zsh repo failed\n"
    exit 1
  }

  _print "Looking for an existing zsh config..."
  if [ -f ~/.zshrc ] || [ -h ~/.zshrc ]; then
    _print "Found ~/.zshrc, backing up to ~/.zshrc.pre-oh-my-zsh";
    mv ~/.zshrc ~/.zshrc.pre-oh-my-zsh;
  fi

  # If this user's login shell is not already "zsh", attempt to switch.
  TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
  if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    # If this platform provides a "chsh" command (not Cygwin), do it, man!
    if hash chsh >/dev/null 2>&1; then
      _print "Time to change your default shell to zsh!\n"
      chsh -s $(grep /zsh$ /etc/shells | tail -1)
    # Else, suggest the user do so manually.
    else
      _print "I can't change your shell automatically because this system does not have chsh.\n"
      _print "Please manually change your default shell to zsh!\n"
    fi
  fi

  for file in $HOME/.dotfiles/home/.*; do
    filename=$(basename $file)
    if [ $filename = "." ] || [ $filename = ".." ]; then
      continue
    fi
    ln -s $file $HOME/$(basename $file)
  done;

  mkdir $HOME/.dotfiles-local 2> /dev/null
  cp ../templates/aliases.template $HOME/.dotfiles-local/.aliases 2> /dev/null
  cp ../templates/functions.template $HOME/.dotfiles-local/.functions 2> /dev/null

  # Install poverlevel9k
  git clone https://github.com/bhilburn/powerlevel9k.git $HOME/.dotfiles/oh-my-zsh/custom/themes/powerlevel9k

  # Install required fonts
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  ./install.sh
  cd ..
  rm -rf fonts

  _print 'Oh My Zsh is now installed'
}

function install_or_rather_brew() {
  read -p "Do you want to brew some great programs? " $REPLY
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    ./brew.sh
  fi
}

function launch_zsh() {
  _print "Launching zsh..."
  env zsh -l
}

function setup() {
  cd ~/.dotfiles/bin
  source .common
  install_homebrew
  install_oh_my_zsh
  install_or_rather_brew
}

function clone() {
  # sh -c "$(curl -fsSL https://bitbucket.org/marciniwanicki/dotfiles/raw/master/bin/install.sh)"
  git clone git@bitbucket.org:marciniwanicki/dotfiles.git ~/.dotfiles
}

function copy() {
  rm -rf ~/.dotfiles 2> /dev/null
  mkdir ~/.dotfiles
  cp -r .. ~/.dotfiles/
}

function main() {
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

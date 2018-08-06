#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Tap extra repositories
brew tap caskroom/cask
brew tap caskroom/versions
brew tap caskroom/fonts
brew tap facebook/fb

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install must have zsh extensions
brew install zsh-syntax-highlighting

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
# https://www.gnu.org/software/coreutils/coreutils.html
brew install coreutils

# Install some other useful utilities like `sponge`.
# sponge reads standard input and writes it out to the specified file.
# Unlike a shell redirect, sponge soaks up all its input before opening
# the output file. This allows constricting pipelines that read from and
# write to the same file.
brew install moreutils

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget`
brew install wget

# Install Java
brew cask install java8
brew install ant
brew install gradle
brew install maven

# Install Python
brew install python

# Install Editors
brew cask install visual-studio-code

# Install browsers
brew cask install google-chrome
brew cask install firefox
brew cask install opera

# Install font tools.
read -p "Do you want to install font tools? " $REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew tap bramstein/webfonttools
    brew install sfnt2woff
    brew install sfnt2woff-zopfli
    brew install woff2
    brew cask install font-source-code-pro
fi


# Install some CTF tools; see https://github.com/ctfs/write-ups.
read -p "Do you want to install CFT tools? " $REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install aircrack-ng
    brew install bfg
    brew install binutils
    brew install binwalk
    brew install cifer
    brew install dex2jar
    brew install dns2tcp
    brew install fcrackzip
    brew install foremost
    brew install hashpump
    brew install hydra
    brew install john
    brew install knock
    brew install netcat
    brew install netpbm
    brew install nmap
    brew install pngcheck
    brew install socat
    brew install sqlmap
    brew install tcpflow
    brew install tcpreplay
    brew install tcptrace
    brew install ucspi-tcp # `tcpserver` etc.
    brew install xpdf
    brew install xz
fi

# Install other useful binaries.
read -p "Do you want to install other useful binaries? " $REPLY
if [[ $REPLY =~ ^[Yy]$ ]]
then
    brew install ack
    brew install git
    brew install git-lfs
    brew install imagemagick --with-webp
    brew install lua
    brew install lynx
    brew install p7zip
    brew install pigz
    brew install pv
    brew install rename
    brew install rlwrap
    brew install ssh-copy-id
    brew install tree
    brew install vbindiff
    brew install zopfli
    brew install watchman
fi

# iterm2
brew cask install iterm2
ln -sf ~/.dotfiles/config/iterm2/iterm2-shared.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/iterm2-shared.json"

# Fzf (hacky :/)
brew install fzf
echo "Y Y Y" | /usr/local/opt/fzf/install
rm ~/.fzf.bash
mv ~/.fzf.zsh ~/.dotfiles/home/.fzf.zsh
ln -s ~/.dotfiles/home/.fzf.zsh ~/.fzf.zsh

# Ruby
gem install bundler

# Remove outdated versions from the cellar.
brew cleanup

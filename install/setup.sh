#!/bin/sh

export DOTFILES=$HOME/dotfiles

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if ! [ -d $HOME/.oh-my-zsh ]; then
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Symlink all dotfiles
ln -sf $DOTFILES/dotfiles/.Brewfile $HOME/.Brewfile
ln -sf $DOTFILES/dotfiles/.gitconfig $HOME/.gitconfig
ln -sf $DOTFILES/dotfiles/.gitignore_global $HOME/.gitignore_global
ln -sf $DOTFILES/dotfiles/.hushlogin $HOME/.hushlogin
ln -sf $DOTFILES/dotfiles/.inputrc $HOME/.inputrc
ln -sf $DOTFILES/dotfiles/.zshrc $HOME/.zshrc
ln -sf $DOTFILES/dotfiles/aliases.zsh $HOME/aliases.zsh
ln -sf $DOTFILES/dotfiles/path.zsh $HOME/path.zsh

# Add autosuggestion for zsh and Make zsh default shell
chsh -s $(which zsh)

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --global -v

# Create a Sites directory
# This is a default directory for macOS user accounts but doesn't comes pre-installed
mkdir -p $HOME/Code

# Set macOS preferences - we will run this last because this will reload the shell
source $DOTFILES/install/macos.sh

# Reload to apply changes
reload

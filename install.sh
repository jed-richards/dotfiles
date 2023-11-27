#!/usr/bin/env bash

# dotfiles directory
dotfiles_dir=~/dotfiles
log_file=~/dotfiles_install.log

# Array of packages to install
packages=(git tmux vim zsh curl npm node python3 i3 alacritty)

for package in ${packages[*]}; do
    echo "Installing $package"
    sudo apt-get install $package -y
    if type -p $package > /dev/null; then
        echo "$package installed" >> $log_file
    else
        echo "ERROR: $package failed to install" >> $log_file
    fi
done

# Install oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create symlinks
#for dir in dotfiles_dir; do
#    echo "Creating symlink for $dir"
#    ln -sf $dotfiles_dir/$dir ~/.$dir
#done
# ln -sf $dotfiles_dir/.vimrc ~/.vimrc
# ln -sf $dotfiles_dir/.tmux.conf ~/.tmux.conf
# ln -sf $dotfiles_dir/.zshrc ~/.zshrc
# ln -sf $dotfiles_dir/.i3 ~/.i3
# ln -sf $dotfiles_dir/.alacritty.yml ~/.alacritty.yml
# ln -sf $dotfiles_dir/.gitconfig ~/.gitconfig

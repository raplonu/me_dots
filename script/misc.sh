#!/bin/bash

. common.sh

local pk=$(get_package_manager)


# install bat https://github.com/sharkdp/bat#installation
case "$pk" in
    pacman)     sudo pacman -S bat      ;;
    apt-get)    sudo apt install bat    ;;
esac

# fzf https://github.com/junegunn/fzf
case "$pk" in
    pacman)     sudo pacman -S fzf      ;;
    apt-get)    sudo apt install fzf    ;;
esac

# ranger https://github.com/ranger/ranger
case "$pk" in
    pacman)     sudo pacman -S ranger      ;;
    apt-get)    sudo apt install ranger    ;;
esac


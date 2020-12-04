#!/bin/bash

. common.sh

local pk=$(get_package_manager)

# install fish https://fishshell.com/
case "$pk" in
    pacman)     sudo pacman -S fish ;;
    apt-get)
                sudo apt-add-repository ppa:fish-shell/release-3
                sudo apt-get update
                sudo apt-get install fish   ;;
esac

# instal oh my fish https://github.com/oh-my-fish/oh-my-fish
curl -L https://get.oh-my.fish | fish

# install fisher https://github.com/jorgebucaran/fisher
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# install spacefish theme https://github.com/matchai/spacefish
omf install spacefish

# install virtual fish https://github.com/justinmayer/virtualfish
python3 -m pip install virtualfish
vf install
vf addplugins auto_activation projects

# set fish as default shell
local fish_location=$(which fish)
usermod --shell $fish_location $USER

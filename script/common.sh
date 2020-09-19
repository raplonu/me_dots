#!/bin/bash

function get_package_manager {
    if [ -x "$(command -v pacman)" ]; then
        echo pacman
        exit 0
    fi
    if [ -x "$(command -v apt-get)" ]; then
        echo apt-get
        exit 0
    fi
}
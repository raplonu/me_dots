# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

if [[ $- == *i* ]]
then
    if [[ -z ${bash_no_fish} ]]
    then
        fish
        exit
    fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#
# ~/.bashrc
#

[[ $- != *i* ]] && return

colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}"
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we don't have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias np='nano -w PKGBUILD'
alias more=less

xhost +local:root > /dev/null 2>&1

complete -cf sudo

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# export QT_SELECT=4

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

#
# # ex - archive extractor
# # usage: ex <file>
ex() {
    local c e i

    (($#)) || return

    for i; do
        c=''
        e=1

        if [[ ! -r $i ]]; then
            echo "$0: file is unreadable: \`$i'" >&2
            continue
        fi

        case $i in
              # *.t@(gz|lz|xz|b@(2|z?(2))|a@(z|r?(.@(Z|bz?(2)|gz|lzma|xz)))))
              #        c=(bsdtar xvf);;
            *.7z)  c=(7z x);;
            *.Z)   c=(uncompress);;
            *.bz2) c=(bunzip2);;
            *.exe) c=(cabextract);;
            *.gz)  c=(gunzip);;
            *.rar) c=(unrar x);;
            *.xz)  c=(unxz);;
            *.zip) c=(unzip);;
            *)     echo "$0: unrecognized file extension: \`$i'" >&2
                   continue;;
        esac

        command "${c[@]}" "$i"
        ((e = e || $?))
    done
    return "$e"
}

EC() {
	echo -e '\e[1;33m'code $?'\e[m'
}

# Show every error code
trap EC ERR

cl() {
	local dir="$1"
	local dir="${dir:=$HOME}"
	if [[ -d "$dir" ]]; then
		cd "$dir" >/dev/null; ls
	else
		echo "bash: cl: $dir: Directory not found"
	fi
}

calc() {
    python -c "print($@)"
}

function swap()
{
  local TMPFILE=tmp.$$
  mv "$1" $TMPFILE && mv "$2" "$1" && mv $TMPFILE "$2"
}

function chcc {
  case "$1" in
    --unset)        unset CC ; unset CXX ;;

    clang)          export CC=clang ; export CXX=clang++         ;;
    clang-*)        export CC=$1    ; export CXX=clang++-${1#*-} ;;
    gcc)            export CC=gcc   ; export CXX=g++             ;;
    gcc-*)          export CC=$1    ; export CXX=g++-${1#*-}     ;;

    # ex) chcc -m32
    -*)         [ "$CC" = "" ] || export CC="$CC $1"             ;;

    /*)         local option=$( echo "$1" | sed 's/./-/' )
                [ "$CXX" = "" ] || export CXX="$CC $option"
                ;;

                # ex) chcc +ccache
    +*)         local prefix=$( echo "$1" | sed 's/.//' )
                [ "$CC"  = "" ] || export CC="$prefix $CC"
                [ "$CXX" = "" ] || export CXX="$prefix $CXX"
                ;;

    "")         ;;

    *)          echo "invalid argument: '$1'" 1>&2 ;;
  esac

  echo "CC=$CC"
  echo "CXX=$CXX"
}

function wcc {
  echo "$CC & $CXX"
}

## Overclocking

function set_governor {
  sudo cpupower frequency-set --governor $1 > /dev/null
  echo "set mode to $1"
}

alias fire="set_governor performance"
alias oldfire="set_governor powersave"


export LOCAL="$HOME/.local"
export WORKON_HOME="$LOCAL/envs"
export WORKSPACE="$HOME/workspace"
export PATH="$LOCAL/bin:$PATH"
export EDITOR="code"

## Python

export ANACONDA_PATH="$LOCAL/anaconda"
export PATH="$ANACONDA_PATH/bin:$PATH"

source $ANACONDA_PATH/bin/virtualenvwrapper.sh

# Return the actual python version
function wpy {
  basename $(readlink -f $ANACONDA_PATH)
}

# Set python version
function pyset {
  rm $ANACONDA_PATH
  ln -s $LOCAL/anaconda$1 $ANACONDA_PATH
  echo "set to $(wpy)"
}

## JAVA

# Return the actual java version
function wja {
  archlinux-java get
}

# Set the java version
# Need sudo
function jaset {
  sudo archlinux-java set java-$1-openjdk && \
  echo "set to $(wja)"
}

alias py="ipython -i"
alias o="xdg-open"

alias ll="ls -l"
alias la="ls -a"

alias editrc="$EDITOR ~/.bashrc"

alias cdo="cd $WORKSPACE/other/"
alias cdp="cd $WORKSPACE/perso/"

export BASH_LOCAL="$HOME/.bashrc_local"

if test -f "$BASH_LOCAL"; then
  source "$BASH_LOCAL";
fi

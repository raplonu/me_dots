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
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
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

export LOCAL="$HOME/.local"
export PATH="$LOCAL/bin:$PATH"

export ANDROID_SDK_ROOT="$HOME/Android/Sdk"

export ANACONDA_PATH="$LOCAL/anaconda"

export PATH="$ANACONDA_PATH/bin:$PATH"

function wpy {
  basename $(readlink -f $ANACONDA_PATH)
}

function pyset {
  rm $ANACONDA_PATH
  ln -s $LOCAL/anaconda$1 $ANACONDA_PATH
  echo "set to $(wpy)"
}

function wja {
  archlinux-java get
}

function jaset {
  sudo archlinux-java set java-$1-openjdk && \
  echo "set to $(wja)"
}

function do_test_suite()
{
  echo "Will run test suite on IP $1"

  echo "removing gadle cache"
  rm -rf "$HOME/.gradle/caches"

  export ANDROID_HOME="$LOCAL/android-studio/plugins/android-ndk/"
  export JAVA_HOME="$LOCAL/android-studio/jre"

  echo "Connect to robot"
  adb connect $1:5555 && adb wait-for-device
  sleep 1
  echo "Keep it busy..."
  adb shell ping www.google.com > /dev/null &
  adb devices

  cd "$HOME/workspace/wt/testsuite/testsuite-java-libqi"
  git pull
  ./gradlew connectedAndroidTest \
    -Pandroid.testInstrumentationRunnerArguments.annotation=com.softbankrobotics.javalibqitests.annotations.Sanity\
    -Pandroid.testInstrumentationRunnerArguments.password=nao\
    -PlibqiJavaVersion=daily
  adb disconnect $1

  unset ANDROID_HOME
  unset JAVA_HOME

  echo "FINISHED"
}

alias py="ipython -i"
alias o="xdg-open"

alias ll="ls -l"
alias la="ls -a"

alias editrc="code ~/.bashrc"

alias lg1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias lg2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"

function set_governor {
  sudo cpupower frequency-set --governor $1 > /dev/null
  echo "set mode to $1"
}

alias fire="set_governor performance"
alias oldfire="set_governor powersave"

alias cdd="cd $HOME/workspace/wt/develop/sdk/"
alias cdo="cd $HOME/workspace/other/"
alias cdp="cd $HOME/workspace/perso/"
alias cdb="cd $HOME/workspace/bench/"

chcc gcc-5 >> /dev/null

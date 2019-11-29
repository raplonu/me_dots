
function swap
  set TMPFILE (mktemp -u)
  mv "$argv[1]" $TMPFILE && mv "$argv[2]" "$argv[1]" && mv $TMPFILE "$argv[2]"
end

function set_governor
  sudo cpupower frequency-set --governor $argv[1] > /dev/null
  echo "set mode to $argv[1]"
end

alias fire "set_governor performance"
alias oldfire "set_governor powersave"

set LOCAL $HOME/.local
set PATH $LOCAL/bin $PATH

set ANACONDA_PATH $LOCAL/anaconda
set PATH $ANACONDA_PATH/bin $PATH

function wpy
  basename (readlink -f $ANACONDA_PATH)
end

function pyset
  rm $ANACONDA_PATH
  ln -s $LOCAL/anaconda$argv[1] $ANACONDA_PATH
  echo "set to "(wpy)
end

function wja
  archlinux-java get
end

function jaset
  sudo archlinux-java set java-$argv[1]-openjdk && \
  echo "set to "(wja)
end

function chcc 
  switch ($argv[1]) in
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
end

function wcc
  echo "$CC & $CXX"
end

alias editfs "code $HOME/.config/fish/config.fish"

alias py "ipython -i"
alias o  "xdg-open"

alias lg1 "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'"
alias lg2 "git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'"

chcc gcc-5 >> /dev/null
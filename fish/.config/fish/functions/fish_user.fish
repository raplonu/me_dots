
function try_source
  test -e $argv[1]
    and source $argv[1]
end

function set_governor
  sudo cpupower frequency-set --governor $argv[1] > /dev/null
  echo "set mode to $argv[1]"
end

function fire
    set_governor performance
end

function oldfire
    set_governor powersave
end

function swap
  set TMPFILE (mktemp -u)
  mv "$argv[1]" $TMPFILE && mv "$argv[2]" "$argv[1]" && mv $TMPFILE "$argv[2]"
end

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

# function chcc 
#   switch ($argv[1]) in
#     --unset)        unset CC ; unset CXX ;;

#     clang)          export CC=clang ; export CXX=clang++         ;;
#     clang-*)        export CC=$1    ; export CXX=clang++-${1#*-} ;;
#     gcc)            export CC=gcc   ; export CXX=g++             ;;
#     gcc-*)          export CC=$1    ; export CXX=g++-${1#*-}     ;;

#     # ex) chcc -m32
#     -*)         [ "$CC" = "" ] || export CC="$CC $1"             ;;

#     /*)         local option=$( echo "$1" | sed 's/./-/' )
#                 [ "$CXX" = "" ] || export CXX="$CC $option"
#                 ;;

#                 # ex) chcc +ccache
#     +*)         local prefix=$( echo "$1" | sed 's/.//' )
#                 [ "$CC"  = "" ] || export CC="$prefix $CC"
#                 [ "$CXX" = "" ] || export CXX="$prefix $CXX"
#                 ;;

#     "")         ;;

#     *)          echo "invalid argument: '$1'" 1>&2 ;;
#   esac

#   echo "CC=$CC"
#   echo "CXX=$CXX"
# end

function wcc
  echo "$CC & $CXX"
end

function editfs
    $EDITOR $FISH_LOCAL/config.fish
end

function cdg
    cd (git rev-parse --show-toplevel)
end

alias py "ipython -i"
alias o  "xdg-open"
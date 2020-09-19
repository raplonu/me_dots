# function wpy
#   basename (readlink -f $ANACONDA_PATH)
# end

# function pyset
#   rm $ANACONDA_PATH

#   if [ $argv[1] = "system" ]
#     ln -s system $ANACONDA_PATH
#   else
#     ln -s $LOCAL/anaconda$argv[1] $ANACONDA_PATH
#   end

#   echo "set to "(wpy)
# end

# function wja
#   archlinux-java get
# end

# function jaset
#   sudo archlinux-java set java-$argv[1]-openjdk && \
#   echo "set to "(wja)
# end

# function chcc

#   switch $argv[1]
#     case --unset
#       set -e CC; set -e CXX
#     case clang
#       set
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

# function get_bind
#   echo ssh -N -f -L $argv[2]:$argv[1]:22 styx.obspm.fr
# end

# function bind_ssh
#   if not test (count $argv) = 2
#     echo 'Give the sever and a port to bind to ( bind_ssh server.com 1234 ).'
#     return -1
#   end

#   if contains $argv $__SSH_BIND_LIST
#     echo $argv[1] 'already binded.'
#     return -1
#   end

#   if eval (get_bind $argv)
#     set -agx __SSH_BIND_LIST $argv[2]:$argv[1]
#     echo $argv[1] 'binded on localhost:4321.'
#   end
# end

# function unbind_ssh
#   if test $argv[1]
#     set ssh_bind $argv[1]
#   else if test $__SSH_BIND_LIST[-1]
#     set ssh_bind $__SSH_BIND_LIST[-1]
#     set -e __SSH_BIND_LIST[-1]
#   end

#   if not test $ssh_bind
#     echo 'Could not guess the server name to unbind.'
#     echo 'Provide server name ( unbind_ssh server.com ).'
#     return -1
#   end

#   echo 'Unbinding '$ssh_bind '...'

#   set ssh_procs (ps x | grep -E "ssh.*$ssh_bind" | grep -v "grep")

#   for proc in $ssh_procs
#     echo "Killing $proc"
#     set ssh_pid (string split ' ' -- $proc)[2]
#     if not kill $ssh_pid
#       echo 'kill fail, try kill -9'
#       read_confirm
#       kill -9 $ssh_pid
#     end
#   end

#   echo 'Unbinding done.'
# end
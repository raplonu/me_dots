# Defined in /home/jbernard/.config/fish/functions/fish_user.fish @ line 1
function try_source
  test -e $argv[1]
    and source $argv[1]
end

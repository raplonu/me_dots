# Defined in /home/jbernard/.config/fish/functions/fish_user.fish @ line 1
function doc
  switch $argv[1]
    case fish
      o file:///usr/share/doc/fish/index.html
    case cpp
      o file:///usr/share/doc/cppreference/en/index.html
  end
end

# Defined in /home/jbernard/.config/fish/functions/fish_user.fish @ line 1
function swap
  set TMPFILE (mktemp -u)
  mv "$argv[1]" $TMPFILE && mv "$argv[2]" "$argv[1]" && mv $TMPFILE "$argv[2]"
end

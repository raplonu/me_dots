function set_governor
  sudo cpupower frequency-set --governor $argv[1] > /dev/null
  echo "set mode to $argv[1]"
end
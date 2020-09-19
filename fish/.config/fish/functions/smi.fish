# Defined in - @ line 1
function smi --wraps=nvidia-smi --description 'alias smi nvidia-smi'
  nvidia-smi  $argv;
end

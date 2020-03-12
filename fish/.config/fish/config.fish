set -gx LOCAL $HOME/.local
set -gx FISH_LOCAL $HOME/.config/fish
set -gx WORKSPACE $HOME/workspace

set -gx PATH $LOCAL/bin $PATH

set -gx EDITOR "code"

set -gx ANACONDA_PATH $LOCAL/anaconda
set -gx PATH $ANACONDA_PATH/bin $PATH

# spacefish
set -gx SPACEFISH_PROMPT_ADD_NEWLINE false
set -gx SPACEFISH_PROMPT_SEPARATE_LINE false

. ~/.config/fish/functions/fish_user.fish

try_source $FISH_LOCAL/config.local.fish
try_source $FISH_LOCAL/functions/fish_user.local.fish
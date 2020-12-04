set -gx LOCAL $HOME/.local
set -gx FISH_LOCAL $HOME/.config/fish
set -gx WORKSPACE $HOME/workspace
set -gx VIRTUALFISH_HOME $LOCAL/envs
set -gxp fish_user_paths $LOCAL/bin

set -gx me_hostname $hostname
set -gx SPACEFISH_USER_SHOW needed

set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT "-c"

set -gx EDITOR "code"

# rust
set -gx CARGO_PATH $HOME/.cargo
set -gxp fish_user_paths $CARGO_PATH/bin

# spacefish
set -gx SPACEFISH_PROMPT_ADD_NEWLINE false
set -gx SPACEFISH_PROMPT_SEPARATE_LINE false

bind \cx 'ranger-cd; commandline -f execute'
bind \cs 'cd -; commandline -f execute'

export LC_ALL=C

try_source $FISH_LOCAL/config.local.fish
try_source $FISH_LOCAL/functions/fish_user.local.fish

# fish_ssh_agent
# ssh-add ^ /dev/null

set -gx bash_no_fish "true"

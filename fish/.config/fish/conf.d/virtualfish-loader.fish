set -g VIRTUALFISH_VERSION 2.3.0
set -g VIRTUALFISH_PYTHON_EXEC /usr/bin/python
source /home/jbernard/.local/lib/python3.8/site-packages/virtualfish/virtual.fish
source /home/jbernard/.local/lib/python3.8/site-packages/virtualfish/auto_activation.fish
emit virtualfish_did_setup_plugins
set -gx VIRTUALFISH_HOME $LOCAL/envs
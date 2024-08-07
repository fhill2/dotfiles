############### 2023 Python Installation ##################3
# tools used:
# pyenv -> install multiple python versions on the system, and replace the system installed python (homebrew installed or pacman installed) with a pyenv virtualenv.
# poetry -> install/maintain project dependencies and create virtual environments from pyenv installed python version.
# direnv -> to switch virtual env based on shell's cwd

# on osx, python is installed with xcode command line tools, this is /usr/bin/python3
# when pyenv is installed, python from xcode command line tools is replaced with pyenv python on PATH.
# note, ensure `pyenv init --path` is added to ~/.zshrc and PYENV exports too, for this to work.

# do not use python installed via homebrew. why?
# - cannot change python versions easily.
# - easier to reinit the system python environment with pyenv. with pyenv, delete the python virtualenv.

# eg im not using PYENV_ROOT folder to store venvs, I store them with the each specific project.

# What about my custom / personal scripts?
# all custom / personal scripts exist within a directory with a dedicated install script
# this install script creates a virtualenv in

# why use
# bin files / bin wrappers to python functions are symlinked from python_lib/bin -> ~/.local/bin. by keeping , I can set the shebang on these scripts to #!$
# source: https://stackoverflow.com/a/71321123

# function load_pyenv() {
#   eval "$(pyenv init -)"
#   eval "$(pyenv virtualenv-init -)"
# }

# function install_python() {
# 	brew install pyenv
# 	brew install pyenv-virtualenv
#
# 	# latest=$(pyenv latest)
# 	# TODO, pyenv latest does not retrieve latest stable python release?
# 	pyenv install -s 3.11.0
# 	pyenv global 3.11.0
#
# 	# symlink custom python library into pyenv global virtual environment
# 	# might not need this, as im doing all personal / custom scripts and code inside my own virtual environment
# 	# local pyenv_global_site_packages=($(pyenv which python) -c "import site; print(site.getsitepackages()[0])")
# 	# symlink_dotfile config/python_lib "$pyenv_global_site_packages/f"
# 	pip install poetry
# 	# this was needed to remove the config warning message on each invocation
# 	# mv ~/Library/Preferences/pypoetry/config.toml ~/Library/Application\ Support/pypoetry/config.toml
#
# 	# https://github.com/alencarandre/pyenv-autoenv
#
# 	# build my python_lib virtual environment
# 	mkdir -p ~/.venv
#
# 	# create ~/.venv/python_lib virtual environment and install dependencies for personal projects into it
# 	$HOME/dev/python_lib/setup.sh
#
# }

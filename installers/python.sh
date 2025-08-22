#!/usr/bin/env sh
# BOOTSTRAP A NEW PYENV INSTALLATION ON DEBIAN
#
# On Debian, pyenv requires a different installation method than OSX
# 1) Install pyenv using pyenv-installer
# as there is no Debian package to install pyenv into the system environment
# https://github.com/pyenv/pyenv-installer
# Install pyenv initially using pyenv-installer
# curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

# 2) Install debian packages so pyenv can build new python versions
# https://github.com/pyenv/pyenv/wiki#suggested-build-environment
# sudo apt update
# sudo apt install build-essential libssl-dev zlib1g-dev \
# 	libbz2-dev libreadline-dev libsqlite3-dev curl git \
# 	libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

# 3) Install the python versions I need using pyenv
# https://github.com/pyenv/pyenv/issues/65#issuecomment-30998608
# Important that pyenv installs python with --enable-shared to build the libpython3.11.so file for pytower to build
# PYTHON_CONFIGURE_OPTS="--enable-shared" $HOME/.pyenv/bin/pyenv install 3.11.0
# $HOME/.pyenv/bin/pyenv global 3.11.0
# which python -> ~/.pyenv/shims
# which python3 -> /usr/bin/python
# which pip ~/.pyenv/shims

# Fixes: python -m venv .venv errors as it cant find ensurepip in the pyenv installed global python
# pip install upgrade-ensurepip
#
# 2025: Python Installation for Ubuntu + Debian

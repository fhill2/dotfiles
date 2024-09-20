# This only needs to be installed on f-server debian install...
PWD=$(dirname "$0") # set pwd to SCRIPT DIR
root="$(git rev-parse --show-toplevel)" # use PWD to find the git root
_symlink="$root/bin/_symlink" # import the symlink shell script


# bootstraps qmk on a new computer
# make sure pyenv is installed first
mkdir -p ~/.venvs # to store global venvs
python3 -m venv ~/.venvs/qmk_venv # create a global venv to use for qmk
source ~/.venvs/qmk/bin/activate
pip install qmk
qmk setup # installs qmk_firmware to ~/qmk_firmware
qmk config user.keyboard=gmmk/pro/rev1/ansi

mkdir -p ~/.config/qmk
$_symlink $root/debian/config/qmk/qmk.ini ~/.config/qmk/qmk.ini

# symlink the keymap for the gmmk pro into the qmk_firmware folder
$_symlink $root/debian/config/qmk/fhill2_keymap ~/qmk_firmware/keyboards/gmmk/pro/rev1/ansi/keymaps/fhill2






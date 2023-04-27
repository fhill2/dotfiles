#!/bin/bash

# http://ignorantguru.github.io/spacefm/spacefm-manual-en.html#exvar
$fm_import
# notify-send "$fm_file"
echo "$fm_file" | nc -N -U "$HOME/tmp/previewer.sock"

# TPM is deprecated
# tpack init is an alternative but did not show a UI when I tested on OSX

if [ "$HOST" = "Darwin" ]; then
  brew install tmuxpack/tpack/tpack
else
  echo "install tmuxpack/tpack"
fi

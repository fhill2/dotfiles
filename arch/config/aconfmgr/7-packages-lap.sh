if [[ "$HOST" == "arch-lap" ]]
then
  AddPackage networkmanager
  AddPackage nvidia
  # optimus-manager-git needs to be used if you want to use optimus-manager with qtile
  AddPackage --foreign optimus-manager-git
fi

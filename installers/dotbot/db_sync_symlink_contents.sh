#!/usr/bin/sh
# $1 = SOURCE FOLDER - abs path to dotbot source folder
# BASEDIR="/home/f1/dot"
# SOURCE_CONTENTS="$BASEDIR/$1"
sync_symlink_contents() {
cd "$1"
for filename in *; do
  source="$1/$filename"
  target="$2/$filename"
  if [ ! -e "$target" ]; then
    ln -sv "${source}" "${target}"
    # echo "${source}" "${target}"
  fi
done
}

sync_symlink_contents "$1" "$2"

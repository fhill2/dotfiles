#!/usr/bin/env bash
pushd ~ > /dev/null || exit

pick_random_file() {
fd -a --max-results 25 -e ".$1" . | shuf -n 1
}

exts=(jpg gif mp4 mp3 ttf docx zip epub pdf gz md html 7z bin)



DATE="$(date +%Y-%m-%d_%H-%M-%S)"
ROOT="$HOME/tmp/preview_test_$DATE"
mkdir -p $ROOT
ln -s $HOME/dev/app "$ROOT/app-directory"

for ext in "${exts[@]}"; do
FILE="$(pick_random_file $ext)"
if [ -n "$FILE" ]; then
echo "======= NEW RESULT $ext ======="
echo "$FILE"
DEST_FILENAME=$(echo "$FILE" | f_normalise_filename.py | xargs -0 basename)
echo "$DEST_FILENAME"
ln -s "$FILE" "$ROOT/$DEST_FILENAME"
else
echo "======= NO FILE FOUND UNDER HOME: $ext ======="
fi
done

popd > /dev/null || return

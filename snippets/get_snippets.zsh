snippets=$(cat me-json/zsh-tui.json \
  | sed -E 's/\[("[^"]*")\]/\1/' \
  | jq '[.[]] | map({snippets: "\(.body):::::\(.description)"}) | map(join(.snippets)) | join("\n")' \
  | sed -E 's/^"(.*)"$/\1/g')
echo -e $snippets

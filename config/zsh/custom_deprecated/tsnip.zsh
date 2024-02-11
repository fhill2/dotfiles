



tsnip-show() {
snippets=$(cat ~/dev/cl/snippets/me-json/zsh-tui.json \
  | sed -E 's/\[("[^"]*")\]/\1/' \
  | jq '[.[]] | map({snippets: "\(.description)\t\(.body)"}) | map(join(.snippets)) | join("\n")')
  
  
snippets=$(printf "$snippets" | awk -F '\t' '{printf "%-40s%-10s%-50s\n", $1, "\t", $2}')
  
snippets=$(printf "$snippets" | fzf --height=40% --layout=reverse --info=inline --border | awk -F '\t' '{printf $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')

LBUFFER=${LBUFFER}${snippets}

}
zle -N tsnip-show
#bindkey '^T' tsnip-show





tsnip-save-snippet() {

# prompt for input (description) inside zle widget, 
zle -I
#echo -n "Enter description: "
read -r "?Enter description: " < /dev/tty
desc=$REPLY
BUFFER=$BUFFER



# find length of json array and + 1 to it
length_int=$(jq length ~/dev/cl/snippets/me-json/zsh-tui.json)
length_int=$(($length_int + 1))

# save new snippet into shell variable
save_snip=$(jq -R --arg length_int $length_int 'split(":") | {"\($length_int)": {body: .[0],description: .[1]}}' <<< "$BUFFER:$desc") 


# append new snippet into snippet file
cat <<< $(jq --argjson save_snip "$save_snip" '. += $save_snip' ~/dev/cl/snippets/me-json/zsh-tui.json) > ~/dev/cl/snippets/me-json/zsh-tui.json

echo "snippet saved:"
echo "$save_snip" | jq

BUFFER=
}

zle -N tsnip-save-snippet
#bindkey '^[s' tsnip-save-snippet


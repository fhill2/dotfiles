# unecessary unless git needs to be setup before cloning the dotfiles (private repo)
# setup_user_gitconfig() {
# 	# if [ ! -f ~/.gitconfig.user ]; then
# 	printf "What is your GitHub username? > "
# 	read github_user
# 	git config --global github.user "$github_user"
#
# 	printf "What is your full name for commit messages (e.g. Jane Smith)? > "
# 	read git_name
# 	git config --global user.name "$git_name"
#
# 	printf "What is your email address? > "
# 	read git_email
# 	git config --global user.email "$git_email"
# 	# fi
# }
# set_github_ssh_key() {
# 	local sshKeyFileName="$HOME/.ssh/github"
#
# 	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# 	# If there is already a file with that
# 	# name, generate another, unique, file name.
#
# 	if [ -f "$sshKeyFileName" ]; then
# 		sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
# 	fi
# add_ssh_configs() {
# 	printf "%s\n" \
# 		"Host github.com" \
# 		"  IdentityFile $1" \
# 		"  LogLevel ERROR" >>~/.ssh/config
#
# 	print_result $? "Add SSH configs"
# }
#
# test_ssh_connection() {
# 	while true; do
# 		ssh -T git@github.com &>/dev/null
# 		[ $? -eq 1 ] && break
#
# 		sleep 5
# 	done
# }
#
# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# setup_ssh_keys() {
# 	print_header "Set up GitHub SSH keys"
#
# 	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# 	ssh -T git@github.com &>/dev/null
#
# 	if [ $? -ne 1 ]; then
# 		set_github_ssh_key
# 	fi
#
# 	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# 	print_result $? "Set up GitHub SSH keys"
# }

copy_public_ssh_key_to_clipboard() {
	if cmd_exists "pbcopy"; then
		pbcopy <"$1"
		echo "Copied public SSH key to clipboard"
	elif cmd_exists "xclip"; then
		xclip -selection clip <"$1"
		echo "Copied public SSH key to clipboard"
	else
		echo "Please manually copy the public SSH key ($1) to clipboard"
	fi
}

# Step 1: Generate SSH Key
printf "Provide Email Address for ssh key"
read email_address
printf "Provide filename of key"
read filename
declare -r SSH_KEY_PATH="$HOME/.ssh/$(filename)"
ssh-keygen -t rsa -b 4096 -C "$(email_address)" -f "$SSH_KEY_PATH"

## Step 3: Open Github in Web browser
declare -r GITHUB_SSH_URL="https://github.com/settings/ssh"
# The order of the following checks matters
# as on Ubuntu there is also a utility called `open`.
if cmd_exists "xdg-open"; then
	xdg-open "$GITHUB_SSH_URL"
elif cmd_exists "open"; then
	open "$GITHUB_SSH_URL"
else
	echo "Please add the public SSH key to GitHub ($GITHUB_SSH_URL)"
fi

copy_public_ssh_key_to_clipboard "$SSH_KEY_PATH"

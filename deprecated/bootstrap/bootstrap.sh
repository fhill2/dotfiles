# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ask() {
	print_question "$1"
	read -r
}

print_question() {
	print_in_yellow "   [?] $1"
}

get_answer() {
	printf "%s" "$REPLY"
}

cmd_exists() {
	command -v "$1" &>/dev/null
}

set_trap() {
	trap -p "$1" | grep "$2" &>/dev/null ||
		trap '$2' "$1"
}

print_header() {
	print_in_purple "\n • $1\n\n"
}

print_result() {
	if [ "$1" -eq 0 ]; then
		print_success "$2"
	else
		print_error "$2"
	fi

	return "$1"
}
kill_all_subprocesses() {
	local i=""

	for i in $(jobs -p); do
		kill "$i"
		wait "$i" &>/dev/null
	done
}
# this isnt working
# clear_password_policies() {
# 	echo "clearing osx default password policies (minimum password length req)..."
# 	sudo pwpolicy -clearaccountpolicies
# 	# change user pass temporarily
# 	sudo dscl . -merge /Users/f1 UserShellInfo:. .
# }
show_spinner() {
	local -r FRAMES='/-\|'

	# shellcheck disable=SC2034
	local -r NUMBER_OR_FRAMES=${#FRAMES}

	local -r CMDS="$2"
	local -r MSG="$3"
	local -r PID="$1"

	local i=0
	local frameText=""

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Note: In order for the Travis CI site to display
	# things correctly, it needs special treatment, hence,
	# the "is Travis CI?" checks.

	if [ "$TRAVIS" != "true" ]; then
		# Provide more space so that the text hopefully
		# doesn't reach the bottom line of the terminal window.
		#
		# This is a workaround for escape sequences not tracking
		# the buffer position (accounting for scrolling).
		#
		# See also: https://unix.stackexchange.com/a/278888

		printf "\n\n\n"
		tput cuu 3

		tput sc
	fi

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Display spinner while the commands are being executed.

	while kill -0 "$PID" &>/dev/null; do
		frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		# Print frame text.

		if [ "$TRAVIS" != "true" ]; then
			printf "%s\n" "$frameText"
		else
			printf "%s" "$frameText"
		fi

		sleep 0.2

		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		# Clear frame text.

		if [ "$TRAVIS" != "true" ]; then
			tput rc
		else
			printf "\r"
		fi

	done
}
execute() {
	local -r CMDS="$1"
	local -r MSG="${2:-$1}"
	local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

	local exitCode=0
	local cmdsPID=""

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# If the current process is ended,
	# also end all its subprocesses.

	set_trap "EXIT" "kill_all_subprocesses"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Execute commands in background

	eval "$CMDS" \
		&>/dev/null \
		2>"$TMP_FILE" &

	cmdsPID=$!

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Show a spinner if the commands
	# require more time to complete.

	show_spinner "$cmdsPID" "$CMDS" "$MSG"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Wait for the commands to no longer be executing
	# in the background, and then get their exit code.

	wait "$cmdsPID" &>/dev/null
	exitCode=$?

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Print output based on what happened.

	print_result $exitCode "$MSG"

	if [ $exitCode -ne 0 ]; then
		print_error_stream <"$TMP_FILE"
	fi

	rm -rf "$TMP_FILE"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	return $exitCode
}

print_success() {
	print_in_green "   [✔] $1\n"
}

print_error() {
	print_in_red "   [✖] $1 $2\n"
}

print_in_color() {
	printf "%b" \
		"$(tput setaf "$2" 2>/dev/null)" \
		"$1" \
		"$(tput sgr0 2>/dev/null)"
}

print_in_green() {
	print_in_color "$1" 2
}

print_in_purple() {
	print_in_color "$1" 5
}

print_in_red() {
	print_in_color "$1" 1
}

print_in_yellow() {
	print_in_color "$1" 3
}

# DO NOT install xcode command line tools on a fresh system
# it installs python which I'd rather install using pyenv
# are_xcode_command_line_tools_installed() {
#   xcode-select --print-path &> /dev/null
# }

# install_xcode_command_line_tools() {
#   # If necessary, prompt user to install
#   # the `Xcode Command Line Tools`.

#   xcode-select --install &> /dev/null

#   # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#   # Wait until the `Xcode Command Line Tools` are installed.

#   execute \
#     "until are_xcode_command_line_tools_installed; do \
#     sleep 5; \
#   done" \
#   "Xcode Command Line Tools"
# }

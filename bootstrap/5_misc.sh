setup_hostname() {
	print_header "Set computer hostname"

	if [[ $(scutil --get HostName 2>/dev/null) == "" ]]; then
		ask "Please enter a hostname: "
		local new_hostname=$(get_answer)

		sudo scutil --set ComputerName "$new_hostname"
		sudo scutil --set LocalHostName "$new_hostname"
		sudo scutil --set HostName "$new_hostname"

		dscacheutil -flushcache

		print_success "Set hostname to $new_hostname"
	else
		print_success "Already set hostname to $(hostname)!"
	fi
}

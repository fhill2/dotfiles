setup_hostname() {
	echo "Set computer hostname"


		local new_hostname=$(get_answer)

    printf "Enter hostname..."
    read new_hostname

    if [[ $(scutil --get HostName 2>/dev/null) == "$new_hostname" ]]; then
      echo "Already set hostname to $(hostname)!"
      exit
    fi

		sudo scutil --set ComputerName "$new_hostname"
		sudo scutil --set LocalHostName "$new_hostname"
		sudo scutil --set HostName "$new_hostname"

		dscacheutil -flushcache

		echo "Set hostname to $new_hostname"
	else
	fi
}

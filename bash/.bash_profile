if [ -n "$BASH_VERSION" ]; then
	if [ -f "$HOME/.config/bash/.bashrc" ]; then
		. "$HOME/.config/bash/.bashrc"
	fi
fi

#sleep 5

#plymouth quit --retain-splash

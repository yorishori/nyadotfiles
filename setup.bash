#!/bin/bash
BOLD='\033[1m'
NC='\033[0m'

APPS="nvim bash hypr"
VERBOSITY=3

case "$1" in
	"" | "-h" | "--help")
		echo -e "${BOLD}Welcome to the config setup :)${NC}"
		echo " --start     to start stowing"
		echo " --reload    to refresh those links"
		echo " --remove    to get rid of your configs"
		;;
	"--start")
		echo -e "${BOLD}Starting...${NC}"
		stow --no-folding -t $HOME -S --verbose=$VERBOSITY $APPS 
		;;
	"--reload")
		echo -e "${BOLD}Reloading...${NC}"
		stow -t $HOME -R --verbose=$VERBOSITY $APPS
		;;
	"--remove")
		echo -e "${BOLD}Removing...${NC}"
		stow -t $HOME -D --verbose=$VERBOSITY $APPS
		;;
	*)
		echo -e "Hi! ${BOLD}(^^)${NC}"
		;;
esac

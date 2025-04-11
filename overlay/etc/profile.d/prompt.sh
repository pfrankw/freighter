BLUE='\[\e[34m\]'
RESET='\[\e[0m\]' # Reset color and attributes

export PS1="\u@\h:\w\$ [${BLUE}$?${RESET}] > "

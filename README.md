# random
Random files. Literally just a bunch of stuff I wanted to be able to move between computers. Mostly linux bash stuff.

# Monitoring:
    # network
    nload
    # processes and other bits and bobs (love you htop)
    top or htop
    # memory details
    while sleep 0.25; do tput setaf 10; echo " - - - - vmstat - - - - "; tput setaf 14; vmstat -a -S M 1 1; tput sgr0; done
    # io / drive usage
    iotop
    # git status of current directory every 5 seconds
    while sleep 5; do output=$(git status); clear; echo "$output"; tput setaf 6; echo " - - - - Main Pi Vagrant Box Git Status - - - - "; tput sgr0; done


# Other singleline bash
    # pointless but fancy git window for current directory
    while true; do tput setaf 10; printf "\n - - - - Git Management - - - - \n"; tput setaf 14; printf "Input git command: "; tput sgr0; read command; clear; tput setaf 14; printf "Running: "; tput sgr0; printf "git $command\n\n"; eval "git $command"; done

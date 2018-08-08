# random
Random files

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



# random
Random files

# Monitoring:
    nload
    top or htop
    tput setaf 10; while sleep 0.25; do echo " - - - - vmstat - - - - "; vmstat -a -S M 1 1; done
    iotop
    while sleep 5; do for i in `seq 1 20`; do printf "\n"; done; git status; tput setaf 6; echo " - - - - Main Pi Vagrant Box Git Status - - - - "; tput sgr0; done

#!/bin/bash
#github-action genshdoc
#
# @file catchmentOS-install-script
# @brief Entrance script that launches children scripts for each phase of installation.

# Find the name of the folder the scripts are in
set -a
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
SCRIPTS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/scripts
CONFIGS_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"/configs
set +a
echo -ne "
-------------------------------------------------------------------------------
                                                              #######  #####  
  ####    ##   #####  ####  #    # #    # ###### #    # ##### #     # #     # 
 #    #  #  #    #   #    # #    # ##  ## #      ##   #   #   #     # #       
 #      #    #   #   #      ###### # ## # #####  # #  #   #   #     #  #####  
 #      ######   #   #      #    # #    # #      #  # #   #   #     #       # 
 #    # #    #   #   #    # #    # #    # #      #   ##   #   #     # #     # 
  ####  #    #   #    ####  #    # #    # ###### #    #   #   #######  #####  
-------------------------------------------------------------------------------
                               Linux Installer
-------------------------------------------------------------------------------
"
    ( bash $SCRIPT_DIR/scripts/startup.sh )|& tee startup.log
      source $CONFIGS_DIR/setup.conf
    ( bash $SCRIPT_DIR/scripts/0-preinstall.sh )|& tee 0-preinstall.log
    ( arch-chroot /mnt $HOME/catchmentOS-install-script/scripts/1-setup.sh )|& tee 1-setup.log
    if [[ ! $DESKTOP_ENV == server ]]; then
      ( arch-chroot /mnt /usr/bin/runuser -u $USERNAME -- /home/$USERNAME/catchmentOS-install-script/scripts/2-user.sh )|& tee 2-user.log
    fi
    ( arch-chroot /mnt $HOME/catchmentOS-install-script/scripts/3-post-setup.sh )|& tee 3-post-setup.log
    cp -v *.log /mnt/home/$USERNAME

echo -ne "
-------------------------------------------------------------------------------
                                                              #######  #####  
  ####    ##   #####  ####  #    # #    # ###### #    # ##### #     # #     # 
 #    #  #  #    #   #    # #    # ##  ## #      ##   #   #   #     # #       
 #      #    #   #   #      ###### # ## # #####  # #  #   #   #     #  #####  
 #      ######   #   #      #    # #    # #      #  # #   #   #     #       # 
 #    # #    #   #   #    # #    # #    # #      #   ##   #   #     # #     # 
  ####  #    #   #    ####  #    # #    # ###### #    #   #   #######  #####                                                                              
-------------------------------------------------------------------------------
                               Linux Installer
-------------------------------------------------------------------------------
                Done - Please Eject Install Media and Reboot
"

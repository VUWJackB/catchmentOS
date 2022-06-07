#!/usr/bin/env bash
#github-action genshdoc
#
# @file User
# @brief User customizations and AUR package installation.
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
                    Automated Arch Linux Installer
                        SCRIPTHOME: catchmentOS-install-script
-------------------------------------------------------------------------------

Installing AUR Softwares
"
source $HOME/catchmentOS-install-script/configs/setup.conf

  cd ~
  mkdir "/home/$USERNAME/.cache"


if [[ ! $AUR_HELPER == none ]]; then
  cd ~
  git clone "https://aur.archlinux.org/$AUR_HELPER.git"
  cd ~/$AUR_HELPER
  makepkg -si --noconfirm
  # sed $INSTALL_TYPE is using install type to check for MINIMAL installation, if it's true, stop
  # stop the script and move on, not installing any more packages below that line
  sed -n '/'$INSTALL_TYPE'/q;p' ~/catchmentOS-install-script/pkg-files/aur-pkgs.txt | while read line
  do
    if [[ ${line} == '--END OF MINIMAL INSTALL--' ]]; then
      # If selected installation type is FULL, skip the --END OF THE MINIMAL INSTALLATION-- line
      continue
    fi
    echo "INSTALLING: ${line}"
    $AUR_HELPER -S --noconfirm --needed ${line}
  done
fi

export PATH=$PATH:~/.local/bin
mkdir $HOME/.config/
cp -r $HOME/catchmentOS-install-script/configs/.config/* $HOME/.config/
cp $HOME/catchmentOS-install-script/configs/.bashrc $HOME/
chmod +x $HOME/.config/qtile/autostart.sh
pip install psutil

echo -ne "
-------------------------------------------------------------------------
                    SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------
"
exit

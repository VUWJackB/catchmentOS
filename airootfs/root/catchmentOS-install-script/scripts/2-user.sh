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
Installing AUR Softwares
"
source $HOME/catchmentOS-install-script/configs/setup.conf

  cd ~
  mkdir "/home/$USERNAME/.cache"



cd ~
git clone "https://aur.archlinux.org/paru.git"
cd ~/paru
makepkg -si --noconfirm
sed -n '/'$INSTALL_TYPE'/q;p' ~/catchmentOS-install-script/pkg-files/aur-pkgs.txt | while read line
do
  if [[ ${line} == '--END AUR--' ]]; then
    echo "AUR packages installed"
  else
    echo "INSTALLING: ${line}"
    paru -S --noconfirm --needed ${line}
  fi
done

export PATH=$PATH:~/.local/bin
mkdir $HOME/.config/
cp -r $HOME/catchmentOS-install-script/configs/.config/* $HOME/.config/
cp $HOME/catchmentOS-install-script/configs/.bashrc $HOME/
chmod +x $HOME/.config/qtile/autostart.sh
pip install psutil

echo -ne "
-------------------------------------------------------------------------------
SYSTEM READY FOR 3-post-setup.sh
-------------------------------------------------------------------------------
"
exit

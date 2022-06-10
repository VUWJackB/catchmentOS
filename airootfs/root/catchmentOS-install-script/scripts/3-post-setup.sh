#!/usr/bin/env bash
#github-action genshdoc
#
# @file Post-Setup
# @brief Finalizing installation configurations and cleaning up after script.
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
Final Setup and Configurations
GRUB EFI Bootloader Install & Check
-------------------------------------------------------------------------------
"
source ${HOME}/catchmentOS-install-script/configs/setup.conf

if [[ -d "/sys/firmware/efi" ]]; then
    grub-install --efi-directory=/boot ${DISK}
fi

echo -ne "
-------------------------------------------------------------------------------
Creating Grub Boot Menu
-------------------------------------------------------------------------------
"
# set kernel parameter for decrypting the drive
if [[ "${FS}" == "luks" ]]; then
sed -i "s%GRUB_CMDLINE_LINUX_DEFAULT=\"%GRUB_CMDLINE_LINUX_DEFAULT=\"cryptdevice=UUID=${ENCRYPTED_PARTITION_UUID}:ROOT root=/dev/mapper/ROOT %g" /etc/default/grub
fi
echo -e "Updating grub..."
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/Arch Linux/catchmentOS/g' /boot/grub/grub.cfg
echo -e "All set!"

echo -ne "
-------------------------------------------------------------------------------
Enabling (and Theming) Login Display Manager
-------------------------------------------------------------------------------
"
systemctl enable ly.service

echo -ne "
-------------------------------------------------------------------------------
Enabling Essential Services
-------------------------------------------------------------------------------
"
systemctl enable cups.service
echo "  Cups enabled"
ntpd -qg
systemctl enable ntpd.service
echo "  NTP enabled"
systemctl disable dhcpcd.service
echo "  DHCP disabled"
systemctl stop dhcpcd.service
echo "  DHCP stopped"
systemctl enable NetworkManager.service
echo "  NetworkManager enabled"
systemctl enable bluetooth
echo "  Bluetooth enabled"
systemctl enable avahi-daemon.service
echo "  Avahi enabled"

if [[ "${FS}" == "luks" || "${FS}" == "btrfs" ]]; then
echo -ne "
-------------------------------------------------------------------------------
Creating Snapper Config
-------------------------------------------------------------------------------
"

SNAPPER_CONF="$HOME/catchmentOS-install-script/configs/etc/snapper/configs/root"
mkdir -p /etc/snapper/configs/
cp -rfv ${SNAPPER_CONF} /etc/snapper/configs/

SNAPPER_CONF_D="$HOME/catchmentOS-install-script/configs/etc/conf.d/snapper"
mkdir -p /etc/conf.d/
cp -rfv ${SNAPPER_CONF_D} /etc/conf.d/

fi

echo -ne "
-------------------------------------------------------------------------------
Cleaning
-------------------------------------------------------------------------------
"

# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

rm -r $HOME/catchmentOS-install-script
rm -r $HOME/$AUR_HELPER
rm -r /home/$USERNAME/catchmentOS-install-script

# Replace in the same state
cd $pwd

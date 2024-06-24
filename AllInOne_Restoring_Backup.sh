clear
echo -e "\n\t\t>>>>>            Starting Script            <<<<<\n"
mkdir AllInOne_Folder
mount -t ext4 /dev/$(lsblk -lf | grep sda | grep ext4 | awk '{print $1}') AllInOne_Folder
if ls AllInOne_Backup_* 1> /dev/null 2>&1; then
  rm -r AllInOne_Folder/*
  tar -xzf $(ls | grep AllInOne_Backup_) --preserve-permissions --same-owner --ignore-failed-read --overwrite -C AllInOne_Folder
  rm $(ls | grep AllInOne_Backup_)
else
  cd AllInOne_Folder
  mv $(find . -name "AllInOne_Backup_*" -print -quit) .
  find . -not -name "AllInOne_Backup_*" -delete
  tar -xzf $(ls | grep AllInOne_Backup_) --preserve-permissions --same-owner --ignore-failed-read --overwrite
  rm $(ls | grep AllInOne_Backup_)
  cd
fi
mv AllInOne_Folder/vfat.tar.gz .
mv AllInOne_Folder/FS_Data.txt .
tar -xzf AllInOne_Folder/ext4.tar.gz --preserve-permissions --same-owner --ignore-failed-read --overwrite
rm AllInOne_Folder/ext4.tar.gz
rm -r AllInOne_Folder/root/AllInOne_Folder
for config_file in AllInOne_Folder/etc/cloud/cloud.cfg.d/*.cfg; do
    if grep -q "network:" "$config_file"; then
        rm $config_file
    fi
done
INT=$(ip route | awk '/^default via/ {print $5}' | head -n 1)
if [ -f "/etc/cloud/cloud.cfg.d/$INT.cfg" ]; then
    cp /etc/cloud/cloud.cfg.d/$INT.cfg AllInOne_Folder/etc/cloud/cloud.cfg.d/
else
    cp /etc/cloud/cloud.cfg.d/* AllInOne_Folder/etc/cloud/cloud.cfg.d/
fi
umount AllInOne_Folder
mkfs.vfat -F 32 -i $(sed -n '1p' FS_Data.txt) /dev/$(lsblk -lf | grep sda | grep vfat | awk '{print $1}') 2>/dev/null
mount -t vfat /dev/$(lsblk -lf | grep sda | grep vfat | awk '{print $1}') AllInOne_Folder
tar -xzf vfat.tar.gz --preserve-permissions --same-owner --ignore-failed-read --overwrite
umount AllInOne_Folder
e2fsck -p -f /dev/$(lsblk -lf | grep sda | grep ext4 | awk '{print $1}')
tune2fs -U $(sed -n '2p' FS_Data.txt) /dev/$(lsblk -lf | grep sda | grep ext4 | awk '{print $1}')
fatlabel /dev/$(lsblk -lf | grep sda | grep vfat | awk '{print $1}') $(sed -n '3p' FS_Data.txt)
LABEL=$(sed -n '4p' FS_Data.txt)
if [ -z "$LABEL" ]; then
  e2label /dev/$(lsblk -lf | grep sda | grep ext4 | awk '{print $1}') ""
else
  e2label /dev/$(lsblk -lf | grep sda | grep ext4 | awk '{print $1}') $LABEL
fi
rm vfat.tar.gz
rm FS_Data.txt
rm -r AllInOne_Folder
rm AllInOne_Restoring_Backup.sh
echo -e "\t\t>>>>>      Restoring Backup Successful      <<<<<"
reboot

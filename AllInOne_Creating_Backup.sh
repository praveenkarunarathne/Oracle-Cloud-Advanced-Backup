clear
echo -e "\n\t\t>>>>>         Starting Script           <<<<<"
mkdir AllInOne_Folder
mount -t vfat /dev/$(lsblk -lf | grep sda | grep vfat | awk '{print $1}') AllInOne_Folder
tar -czpf vfat.tar.gz --preserve-permissions --ignore-failed-read --same-owner AllInOne_Folder 2>/dev/null
umount AllInOne_Folder
mount -t ext4 /dev/$(lsblk -lf | grep sda | grep ext4 | awk '{print $1}') AllInOne_Folder
tar -czpf ext4.tar.gz --exclude='AllInOne_Creating_Backup.sh' --exclude='vfat.tar.gz' --exclude='ext4.tar.gz' --preserve-permissions --ignore-failed-read --same-owner AllInOne_Folder 2>/dev/null
echo "$(lsblk -lf -o NAME,FSTYPE,UUID | grep sda | grep vfat | awk '{print $3}' | sed 's/-//g')" > FS_Data.txt
echo "$(lsblk -lf -o NAME,FSTYPE,UUID | grep sda | grep ext4 | awk '{print $3}')" >> FS_Data.txt
echo "$(lsblk -lf -o NAME,FSTYPE,LABEL | grep sda | grep vfat | awk '{print $3}')" >> FS_Data.txt
echo "$(lsblk -lf -o NAME,FSTYPE,LABEL | grep sda | grep ext4 | awk '{print $3}')" >> FS_Data.txt
tar -czpf AllInOne_Backup_$(date -u +"%Y-%m-%d_%H-%M-%S").tar.gz --preserve-permissions --same-owner ext4.tar.gz vfat.tar.gz FS_Data.txt
rm ext4.tar.gz
rm vfat.tar.gz
rm FS_Data.txt
umount AllInOne_Folder
rm -r AllInOne_Folder
rm AllInOne_Creating_Backup.sh
echo -e "\t\t>>>>>    Creating Backup Successful     <<<<<"

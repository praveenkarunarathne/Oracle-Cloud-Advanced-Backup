# Oracle-Cloud-Advanced-Backup

## Creating Backup

### Root Access

```
sudo -i
```

### Creating Screen

```
screen
```

### Running Creating Backup Script

```
wget https://raw.githubusercontent.com/praveenkarunarathne/Oracle-Cloud-Advanced-Backup/main/AllInOne_Creating_Backup.sh && bash AllInOne_Creating_Backup.sh
```

## Restoring Backup

### Root Access

```
sudo -i
```

### Downloading UEFI iPXE Bootloader

```
wget https://raw.githubusercontent.com/praveenkarunarathne/Downloading-UEFI-iPXE-Bootloader/main/UEFIiPXEBootloader.sh && bash UEFIiPXEBootloader.sh && rm UEFIiPXEBootloader.sh
```

### Fix DNS Error

```
echo "DNS=8.8.8.8 8.8.4.4" >> /etc/systemd/resolved.conf && systemctl restart systemd-resolved
```

### Running Restoring Backup Script

```
wget https://raw.githubusercontent.com/praveenkarunarathne/Oracle-Cloud-Advanced-Backup/main/AllInOne_Restoring_Backup.sh && bash AllInOne_Restoring_Backup.sh
```

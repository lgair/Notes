#!/bin/bash

# Create the directories if they don't exist
sudo mkdir -p /etc/systemd/system/
sudo mkdir -p /etc/smb/

# Create the mount-script.sh file
cat <<EOF > /mount-script.sh
#!/bin/bash

smb_directory="/media/smb"

# Give the correct permissions to the /calibration partition
# Uncomment the following line if the service is for the calibration image not the host
chmod 777 /calibration/

# Check if the SMB directory already exists
if [ ! -d "$smb_directory" ]; then
    mkdir -p "$smb_directory"
fi

# Check if the drive is already mounted
if mountpoint -q "$smb_directory"; then
    exit 0
fi

# Mount the drive
mount "$smb_directory"
if [ $? -eq 0 ]; then
    exit 0
else
    exit -1
fi
EOF

#Make the mount-script executable
sudo chmod +x /mount-script.sh

# Create the mount-smb.service file
cat <<EOF > /etc/systemd/system/mount-smb.service
[Unit]
Description=Mount SMB Share
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/bin/bash -c "/mount-script.sh"
User=root
Group=root
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

# Create the smb-credentials file
cat <<EOF > /etc/smb/smb-credentials
username=Production
password=Jacked-Fissure3
EOF

# Modify /etc/fstab to contain the smb share details
echo "//192.168.1.121/4k12 /media/smb cifs credentials=/etc/smb/smb-credentials,nofail,noauto,rw,uid=1000,gid=1000,vers=3.0 0 0" | sudo tee -a /etc/fstab

# Set the permissions of smb-credentials to be accessible only by root
sudo chmod 600 /etc/smb/smb-credentials

# Reload systemd daemon to pick up the new service
sudo systemctl daemon-reload

# Enable and start the mount-smb service
sudo systemctl enable mount-smb.service
sudo systemctl start mount-smb.service


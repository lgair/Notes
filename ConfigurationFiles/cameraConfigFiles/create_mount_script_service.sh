#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -u <username> -p <password> -a <ip_address>"
    exit 1
}

# Initialize variables
username=""
password=""
ip_address=""

# Parse command line arguments
while getopts "u:p:a:" opt; do
    case $opt in
        u) username="$OPTARG" ;;
        p) password="$OPTARG" ;;
        a) ip_address="$OPTARG" ;;  # Changed 'addr' to 'a'
        *) usage ;;
    esac
done

# Check if all required arguments are provided
if [ -z "$username" ] || [ -z "$password" ] || [ -z "$ip_address" ]; then
    usage
fi

# Create necessary directories
sudo mkdir -p /etc/systemd/system/ /etc/smb/

# Create the mount-script.sh file in /usr/bin
cat <<'EOF' | sudo tee /usr/bin/mount-script.sh > /dev/null
#!/bin/bash

smb_directory="/media/smb"

# Check if the calibration directory exists and update permissions if it does
if [ -d "/calibration/" ]; then
    chmod 777 /calibration/
fi

# Create SMB directory if it doesn't exist
mkdir -p "$smb_directory"

# Exit if already mounted
if mountpoint -q "$smb_directory"; then
    exit 0
fi

# Mount the drive
if mount "$smb_directory"; then
    exit 0
else
    exit 1
fi
EOF

# Make the mount-script executable
sudo chmod +x /usr/bin/mount-script.sh

# Create the mount-smb.service file
cat <<EOF | sudo tee /etc/systemd/system/mount-smb.service > /dev/null
[Unit]
Description=Create & mount SMB share on device.
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=/usr/bin/mount-script.sh
User=root
Group=root
Type=oneshot
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF

# Create the smb-credentials file with provided arguments
echo -e "username=$username\npassword=$password" | sudo tee /etc/smb/smb-credentials > /dev/null

# Set permissions for smb-credentials
sudo chmod 600 /etc/smb/smb-credentials

# Modify /etc/fstab to contain the smb share details
# Remove old instances of the smb share details
sudo sed -i.bak "/\/\/${ip_address}\/4k12/d" /etc/fstab

# Add the new smb share entry
echo "//${ip_address}/4k12 /media/smb cifs credentials=/etc/smb/smb-credentials,nofail,noauto,rw,uid=1000,gid=1000,vers=3.0 0 0" | sudo tee -a /etc/fstab > /dev/null

# Reload systemd daemon to pick up the new service
sudo systemctl daemon-reload

# Enable and start the mount-smb service
sudo systemctl enable --now mount-smb.service

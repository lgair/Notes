#!/bin/bash

# Check for the correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

SOURCE_DIR="$1"
DEST_DIR="$2"

# Create the copy_config_files.sh script
cat << 'EOF' | sudo tee /usr/local/bin/copy_config_files.sh > /dev/null
#!/bin/bash

# Define the source and destination directories
SOURCE_DIR="$1"
DEST_DIR="$2"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Copy the specified files and directory
cp "$SOURCE_DIR/.bashrc" "$DEST_DIR/"
cp "$SOURCE_DIR/.bash_aliases" "$DEST_DIR/"
cp "$SOURCE_DIR/.vimrc" "$DEST_DIR/"
cp -r "$SOURCE_DIR/bash_functions/" "$DEST_DIR/"

echo "Files and directories have been copied to $DEST_DIR"
EOF

# Make the script executable
sudo chmod +x /usr/local/bin/copy_config_files.sh

# Create the systemd service file
cat << EOF | sudo tee /etc/systemd/system/copy-config.service > /dev/null
[Unit]
Description=Copy configuration files from home directory

[Service]
Type=oneshot
ExecStart=/usr/local/bin/copy_config_files.sh $SOURCE_DIR $DEST_DIR

[Install]
WantedBy=multi-user.target
EOF

# Create the systemd timer file
cat << EOF | sudo tee /etc/systemd/system/copy-config.timer > /dev/null
[Unit]
Description=Run copy-config.service nightly

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Reload systemd to recognize the new service and timer
sudo systemctl daemon-reload

# Enable the service and timer
sudo systemctl enable copy-config.service
sudo systemctl enable copy-config.timer

echo "Service and timer installed successfully."

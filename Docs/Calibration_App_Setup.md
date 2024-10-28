# chronos5-calibration

Chronos5 calibration repository contains the code to talk to and control a sensor calibration jig for the gsprint sensor
within the chronos 4k12 model camera and later models.

## Dependencies

The following dependencies are required for running the calibration GUI:

```bash
sudo apt-get install exiftool qtcreator qtbase5-dev qttools5-dev sshpass cifs-utils
```

## Setting up Serial Communication

To enable the system to communicate to the calibration jig via UART the following steps need to be taken:

1) Connect to the jig via serial usb (UART)
    1) Run `lsusb` and look for the vendor & product ID's in the returned string `Bus 002 Device 003: ID 2341:0043
       Arduino Uno R4 minima (CDC ACM)`
    2) in this example, the Vendor ID is 2341 & the Product ID is 0043.
2) Create an udev rules file
    1) `sudo vim /etc/udev/rules.d/99-usb-serial.rules`
    2) [An example udev rules file for USB](scripts/99-usb-serial.rules)
3) Add the user to the `plugdev` & `dialout` groups
    1) `sudo usermod -aG plugdev $USER`
    2) `sudo usermod -aG dialout $USER`

## Mount SMB on Host.

To create a service on the host machine `mount-smb.service` run [create mount script service](scripts/create_mount_script_service.sh) on the host or target machine.

### Script Overview:

- Creates the directories /etc/systemd/system/ and /etc/smb/ if they don't already exist.
- Creates the mount-smb.service file in the /etc/systemd/system/ directory with the specified configuration.
- Creates the mount-script.sh file in the root directory with the specified configuration.
- Creates the smb-credentials file in the /etc/smb/ directory with the specified username and password.
- Sets the permissions of the smb-credentials file to be accessible only by root (chmod 600).
- Reloads the systemd daemon to pick up the new service configuration.
- Enables and starts the mount-smb service using systemctl.

### Useage:
`sudo ./create_mount_script_service.sh -u <username> -p <password> -a <IP>`

### To Manually Mount a Shared Drive;

```bash
sudo mkdir /media/<share_name>
#get gid & uid from id
sudo mount -t cifs //<NAS_IP>/<shared_dir> /media/<share_name>/ -o username=USER,password=PASSWORD,uid=1000,
gid=1000
```

## Calibration GUI

To modify the calibration GUI elements or layout of the GUI, open the QT Designer tool using the command:

```
designer
```

Open the `GUI/ui/main_window.ui` file inside QT Designer and modify the GUI layout as needed.

Once the UI file is modified, we need to re-run cmake in the root directory of this repository to
generate the C++ header file that contains the GUI elements. Alternatively, you can run the following
command manually:

```
uic gui/ui/main_window.ui -o gui/ui/ui_main_window.h
```

To compile the calibration GUI, run:

```
# cmake -DSENSOR_FILTER=COLOR .
cmake -DDEBUG_MODE=ON --no-warn-unused-cli -DGSPRINT_GET_CALIB=/path/to/gsprint_get_calib
make calibration_gui
```

Please note that the file `gsprint_get_calib` is independent of this repo and that the filepath to the relevant
version (v4) is included the path should be something like `/media/smb/Cal_supporting_files/gsprint_get_calib`

The `DEBUG_MODE` cmake option is there to toggle console output.
The application will always log to a file.
The GUI executable is then located at `./calibration_gui`.

## Install the Exec to Desktop

On the Calibration workstation, to install the calibration gui application as a clickable desktop icon
execute the [install as application](scripts/Install_As_Application.sh) script.

### Useage:
`sudo ./Install_As_Application.sh -s <source_executable_path> -d <destination_insall_path> -i <icon_file (optional)>`


## Cleaning up SMB share (NAS)

In order to manage the storage of the NAS the calibration process only retains the flat frame footage (DNG's) for 28
days. If a calibration is older than the retaining period, the flat frames are deleted. The calibration.data file
and the offset calculation CSV's are retained in case the calibration data file needs to be replaced or rebuilt.

The following script, `cleanup_old_subfolders.sh` is run once weekly as a Cron job on the fourkcalibration workstation
fridays at 8pm PST. It logs an entry for every folder deleted, with a timestamp & reports the total time it took for
deletion along with the total number & size of directories deleted. the logfile is located in
`/home/fourkcalibration/SMBCleanup.log`

```bash
#!/bin/bash

# Configuration
MAIN_DIRECTORY="/media/smb" # Change this to your NAS path
DAYS_OLD=28 # Set the age limit in days
DRY_RUN=false # Default to false
TIME_REPORT=false # Default to false
DELETE_JOBS=4 # Number of concurrent delete jobs
LOGFILE="/media/smb/Logs/Cleanup.log" # Change this to your desired log file path

# Parse command-line options
while getopts "nt" opt; do
    case $opt in
        n)
            DRY_RUN=true
            ;;
        t)
            TIME_REPORT=true
            ;;
        *)
            echo "Usage: $0 [-n] [-t]"
            exit 1
            ;;
    esac
done

# Function to get the current timestamp
function timestamp {
    echo "["$(date +"%Y-%m-%d %H:%M:%S")"]"
}

# Function to convert size to human-readable format
function human_readable_size {
    local size_kb=$1
    if (( size_kb >= 1073741824)); then
        echo "$(bc <<< "scale=2; $size_kb / (1024*1024*1024)") TB"
    elif (( size_kb >= 1048576 )); then
        echo "$(bc <<< "scale=2; $size_kb / (1024*1024)") GB"
    else
        echo "${size_kb} KB"
    fi
}

# Function to log messages to both console and logfile
function log {
    echo "$1" | tee -a "$LOGFILE"
}

# Function to display directories that would be deleted
function dry_run {
    log "$(timestamp) Dry run: The following subdirectories would be deleted:"
    count=0
    total_size=0

    # Find and list directories older than the specified days
    while IFS= read -r dir; do
        while read -r subdir; do
            if [[ $(find "$subdir" -mtime +"$DAYS_OLD" -print) ]]; then
                log "$(timestamp) $subdir"
                dir_size=$(du -s "$subdir" | awk '{print $1}')
                total_size=$((total_size + dir_size))
                ((count++))
            fi
        done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d)
    done < <(find "$MAIN_DIRECTORY" -mindepth 1 -maxdepth 1 -type d -name '[0-9][0-9][0-9][0-9][0-9]*')

    log "$(timestamp) Total directories that would be deleted: $count"
    log "$(timestamp) Total size of directories that would be deleted: $(human_readable_size $total_size)"
}

# Start timing if reporting time is enabled
if [ "$TIME_REPORT" = true ]; then
    START_TIME=$(date +%s)
fi

if [ "$DRY_RUN" = true ]; then
    dry_run
else
    count=0
    total_size=0
    # Use background processes for multithreading
    while IFS= read -r dir; do
        while read -r subdir; do
            if [[ $(find "$subdir" -mtime +"$DAYS_OLD" -print) ]]; then
                # Delete the subdirectory
                log "$(timestamp) Deleting: $subdir" # Display which directory is being deleted
                dir_size=$(du -s "$subdir" | awk '{print $1}')
                total_size=$((total_size + dir_size))
                rm -rf "$subdir" &

                ((count++))

                # Limit the number of concurrent jobs
                while [ "$(jobs -r -p | wc -l)" -ge "$DELETE_JOBS" ]; do
                    wait -n
                done
            fi
        done < <(find "$dir" -mindepth 1 -maxdepth 1 -type d)
    done < <(find "$MAIN_DIRECTORY" -mindepth 1 -maxdepth 1 -type d -name '[0-9][0-9][0-9][0-9][0-9]*')
    
    wait # Wait for any remaining jobs to complete
    log "$(timestamp) Total directories deleted: $count"
    log "$(timestamp) Total size of directories deleted: $(human_readable_size $total_size)"
fi

# End timing and report if enabled
if [ "$TIME_REPORT" = true ]; then
    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME - START_TIME))
    log "$(timestamp) Total time taken for cleanup: $TOTAL_TIME seconds"
fi
```

Make the file executable with `sudo chmod +x cleanup_old_subfolders.sh`

to set up the Cron job run `crontab -e` & append `#0 20 * * 5 cleanup_old_subfolders.sh >> /SMBCleanup 2>&1
0 20 * * 5 /home/fourkcalibration/cleanup_old_subfolders.sh -t >> /home/fourkcalibration/SMBCleanup.log 2>&1
` to the end of the file. 

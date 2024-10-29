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

# Function to get total size of the drive and utilized size of the main folder
function report_drive_usage {
    local drive_size=$(df "$MAIN_DIRECTORY" | awk 'NR==2 {print $2}')
    local drive_filesystem=$(df -h "$MAIN_DIRECTORY" | awk 'NR==2 {print $1}')
    local utilized_size=$(du -s "$MAIN_DIRECTORY" | awk '{print $1}')
    
    # Calculate the percentage of utilized space
    local utilization_percentage=$(( utilized_size * 100 / drive_size ))

    log "$(timestamp) \"$MAIN_DIRECTORY\" on \"$drive_filesystem\" is utilizing: $(human_readable_size $utilized_size) ($utilization_percentage%) out of $(human_readable_size $drive_size) available."
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

# Report drive usage
report_drive_usage


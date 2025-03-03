function cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}

# Function for complex commands
function mkcd() {
  mkdir -p "$1" && cd "$1"           # Create a directory and navigate into it
}

# Backup a file by copying it with a timestamp
function backup() {
    cp "$1" "${1}-$(date +%Y%m%d%H%M%S).bak" || echo "File '$1' not found."
}

# Show disk usage in a human-readable format
function dusage() {
    du -sh "$1" || echo "Directory not found."
}

# Check the exit status of the most recent bash command
function last_status {
    echo "Last command exited with status: $?"
}

# Create a quick note
function note() {
    echo "$1" >> ~/notes.txt && echo "Note added."
}

# Extract files based on extension
function extract() {
    case "$1" in
        *.tar.bz2)  tar xjf "$1" ;;
        *.tar.gz)   tar xzf "$1" ;;
        *.tar.xz)   tar xf "$1" ;;
        *.zip)      unzip "$1" ;;
        *.rar)      unrar x "$1" ;;
        *.7z)       7z x "$1" ;;
        *)          echo "Unsupported file type." ;;
    esac
}

# Function to select all files with a specified extension in the given source directory with a specified depth
function find_ext() {
    local src_dir="."  # Default to current directory
    local ext="$1"  # The first argument is the file extension
    local depth="$2"  # The second argument is the search depth

    # Check if the first argument is actually a directory
    if [[ -d "$1" ]]; then
        src_dir="$1"  # If it's a directory, set it as the source directory
        ext="$2"  # The second argument is the file extension
        depth="$3"  # The third argument is the search depth
    fi

    # Validate the extension
    if [[ -z "$ext" ]]; then
        echo "Usage: find_ext [source_directory] <extension> [depth]"
        return 1
    fi

    # Set depth to a default value if not provided
    depth="${depth:-1}"  # Default to 1 if depth is not specified

    # Use find to search for files with the specified extension and depth
    find "$src_dir" -maxdepth "$depth" -type f -name "*.${ext}"
}

# Usage examples
# find_ext /path/to/source txt
# find_ext ./relative/path txt  # This will search in the specified relative directory
# find_ext txt  # This will search in the current directory

function MarkdownViewer () {
    if [ -z "$1" ]; then
        echo "Usage: view_markdown <markdown_file>"
        return 1
    fi

    if [ ! -f "$1" ]; then
        echo "File '$1' not found."
        return 1
    fi

    pandoc "$1" | lynx -stdin
}

function compress_file() {
    # Check if the correct number of arguments is provided
    if [ $# -lt 1 ]; then
        echo "Usage: compress_file <file_or_directory_to_compress> [threads]"
        return 1
    fi

    # Assign the first argument to input_path
    input_path="$1"
    
    # Check if the path exists
    if [ ! -e "$input_path" ]; then
        echo "Error: Path '$input_path' not found!"
        return 1
    fi

    # Assign the second argument to threads, defaulting to 4 if not provided
    threads="${2:-4}"

    # Create the tar.xz file name
    tar_file="${input_path}.tar.xz"

    # Start time
    start_time=$(date +%s)

    # Get the size of the input path for progress calculation
    input_size=$(du -sb "$input_path" | awk '{print $1}')

    # Compress the file or directory using pv and pixz
    echo "Compressing '$input_path' using $threads threads with pixz..."
    
    tar -cf - -C "$(dirname "$input_path")" "$(basename "$input_path")" | pv -s "$input_size" | pixz -p "$threads" -o "$tar_file"

    # End time
    end_time=$(date +%s)

    # Calculate total time taken
    total_time=$((end_time - start_time))

    # Convert total time to hh:mm:ss format
    printf -v formatted_time "%02d:%02d:%02d" $((total_time / 3600)) $((total_time % 3600 / 60)) $((total_time % 60))

    echo "Compression complete: '$tar_file'"
    echo "Total time taken: $formatted_time"
}

function count_dirs() {
    # Function to count directories in a specified path and depth

    # Function to display usage
    usage() {
        echo "Usage: count_dirs [path] [depth]"
        echo "  path  - (optional) Path to count directories in (default: current directory)"
        echo "  depth - (optional) Depth level (default: 1)"
        return 1
    }

    # Check for the correct number of arguments
    if [[ "$#" -gt 2 ]]; then
        usage
        return 1
    fi

    # Set the path and depth
    local path="${1:-.}"  # Default to current directory
    local depth="${2:-1}" # Default depth level

    # Convert '.' to the absolute path if current working directory is specified
    if [[ "$path" == "." ]]; then
        path=$(pwd)
    fi

    # Check if the path exists
    if [[ ! -d "$path" ]]; then
        echo "Error: '$path' is not a valid directory."
        return 1
    fi

    # Count directories
    if [[ "$depth" -eq 1 ]]; then
        dir_count=$(ls -l "$path" | grep ^d | wc -l)
    else
        dir_count=$(find "$path" -maxdepth "$depth" -type d | wc -l)
        # Subtract one to exclude the parent directory itself
        dir_count=$((dir_count - 1))
    fi

    # Print the result without depth if it's the default
    if [[ "$depth" -eq 1 ]]; then
        echo "Number of directories in '$path': $dir_count"
    else
        echo "Number of directories in '$path' at depth '$depth': $dir_count"
    fi
}

function clipFile() {
    if [[ -z "$1" ]]; then
        echo "Usage: copy_to_clipboard <filename>"
        return 1
    fi

    if [[ -f "$1" ]]; then
        cat "$1" | pbcopy
        echo "Contents of '$1' copied to clipboard."
    else
        echo "File '$1' does not exist."
        return 1
    fi
}

function FetchIPFromMac() {
    if [ -z "$1" ]; then
        echo "Usage: FetchIPFromMac <MAC_ADDRESS>"
        return 1
    fi

    local mac_address=$(echo "$1" | tr '[:upper:]' '[:lower:]')
    
    # Function to fetch the IP address based on the MAC address
    function find_ip() {
        sudo arp-scan --localnet | grep -i "$mac_address" | awk '{print $1}'
    }

    # Check the ARP cache for the IP associated with the given MAC address
    local ip_address=$(find_ip)

    if [ -n "$ip_address" ]; then
        echo "IP address for MAC $mac_address: $ip_address"
    else
        echo "Unable to find an IP address for MAC $mac_address."
    fi
}

parse_image_header() {
    local image_file="$1"
    local file_type="$2"
    local header_size=0

    case "$file_type" in
        image/jpeg)
            header_size=2  # Start with SOI marker
            while true; do
                local marker_length=$(dd if="$image_file" bs=1 skip=$((header_size)) count=2 2>/dev/null | hexdump -e '1/1 "%02x"')
                marker_length=$(printf "%d" "0x$marker_length")
                if [[ $marker_length -le 0 ]]; then
                    break
                fi
                header_size=$((header_size + 2))  # Skip marker bytes
                local segment_length=$(dd if="$image_file" bs=1 skip=$((header_size)) count=2 2>/dev/null | hexdump -e '1/1 "%02x"')
                segment_length=$(printf "%d" "0x$segment_length")
                header_size=$((header_size + 2 + segment_length))  # Add segment length and marker bytes
                dd if="$image_file" bs=1 count=$segment_length >/dev/null 2>&1
                if [[ $(printf "%02x" $segment_length) == "da" ]]; then
                    break  # End of image data
                fi
            done
            ;;
        image/png)
            header_size=8  # PNG header size
            ;;
        image/bmp)
            header_size=54  # BMP header size
            ;;
        image/gif)
            header_size=6  # GIF header size
            ;;
        image/tiff | image/x-tiff)
            local byte_order=$(dd if="$image_file" bs=1 count=2 2>/dev/null | hexdump -e '1/1 "%02x"')
            if [[ "$byte_order" == "49" ]]; then
                # Little-endian (II)
                header_size=8
                local ifd_offset=$(dd if="$image_file" bs=1 skip=4 count=4 2>/dev/null | hexdump -e '1/1 "%02x"')
                ifd_offset=$(printf "%d" "0x$ifd_offset")
                header_size=$((header_size + ifd_offset))
            elif [[ "$byte_order" == "4d" ]]; then
                # Big-endian (MM)
                header_size=8
                local ifd_offset=$(dd if="$image_file" bs=1 skip=4 count=4 2>/dev/null | hexdump -e '1/1 "%02x"')
                ifd_offset=$(printf "%d" "0x$ifd_offset")
                header_size=$((header_size + ifd_offset))
            else
                echo "Warning: Unknown byte order in TIFF file."
                header_size=64  # Default size if unknown
            fi
            ;;
        image/dng)
            local byte_order=$(dd if="$image_file" bs=1 count=2 2>/dev/null | hexdump -e '1/1 "%02x"')
            if [[ "$byte_order" == "49" ]]; then
                header_size=8
                local ifd_offset=$(dd if="$image_file" bs=1 skip=4 count=4 2>/dev/null | hexdump -e '1/1 "%02x"')
                ifd_offset=$(printf "%d" "0x$ifd_offset")
                header_size=$((header_size + ifd_offset))
            elif [[ "$byte_order" == "4d" ]]; then
                header_size=8
                local ifd_offset=$(dd if="$image_file" bs=1 skip=4 count=4 2>/dev/null | hexdump -e '1/1 "%02x"')
                ifd_offset=$(printf "%d" "0x$ifd_offset")
                header_size=$((header_size + ifd_offset))
            else
                echo "Warning: Unknown byte order in DNG file."
                header_size=64  # Default size if unknown
            fi
            ;;
        *)
            echo "Warning: Unknown image type '$file_type'. Using default size of 64 bytes."
            header_size=64  # Default size if unknown
            ;;
    esac

    echo "$header_size"
}

dump_image_header() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: dump_image_header <image_file>"
        return 1
    fi

    local image_file="$1"

    if [[ ! -f "$image_file" ]]; then
        echo "Error: File '$image_file' not found."
        return 1
    fi

    # Determine the file type
    local file_type=$(file --mime-type -b "$image_file")

    # Parse the header to find its size
    local header_size=$(parse_image_header "$image_file" "$file_type")

    # Check for errors in header size
    if [[ $? -ne 0 ]]; then
        echo "Failed to parse header size."
        return 1
    fi
    # Dump the header based on the determined size
    echo "Header of image file '$image_file':"
    hexdump -C "$image_file" | head -n $((header_size / 16 + 1))
}

function copySMBPassword() {
    local file="/etc/smb/smb-credentials"

    # Check if the credentials file exists
    if [[ ! -f "$file" ]]; then
        echo "Error: File $file does not exist."
        return 1
    fi

    # Default to line 2 if no argument is provided
    local line=${1:-2}

    # Extract the password from the specified line and copy to clipboard
    local password
    password=$(sudo awk -F'=' "NR==$line {gsub(/^ +| +$/, \"\", \$2); print \$2}" "$file")

    if [[ -z "$password" ]]; then
        echo "Error: No password found on line $line."
        return 1
    fi

    echo -n "$password" | pbcopy
    echo "Password from line $line copied to clipboard."
}

check_branches() {
    # Check if any branch names were provided
    if [ "$#" -eq 0 ]; then
        echo "Usage: check_branches <branch1> <branch2> ... <branchN>"
        return 1
    fi

    # Iterate over the list of branches provided as command line arguments
    for branch in "$@"; do
        # Check if the branch exists in the local repository
        if git show-ref --verify --quiet refs/heads/"$branch"; then
            echo "Branch '$branch' exists locally."
        # Check if the branch exists in the remote repository
        elif git ls-remote --heads origin "$branch" | grep -q "$branch"; then
            echo "Branch '$branch' exists in remote."
        else
            echo "Branch '$branch' does not exist."
        fi
    done
}

# Example usage:
# dump_image_header path/to/your/image.tiff

function dump_pixels() {
    # Check if the image file is provided
    if [ "$#" -ne 1 ]; then
        echo "Usage: dump_pixels <image_file>"
        return 1
    fi

    # Assign the input argument to a variable
    local image_file="$1"

    # Check if the file exists and is a regular file
    if [ ! -f "$image_file" ]; then
        echo "Error: File '$image_file' not found."
        return 1
    fi

    # Check if ImageMagick's 'convert' command is available
    if ! command -v convert &> /dev/null; then
        echo "Error: ImageMagick is not installed. Please install it to proceed."
        return 1
    fi

    # Get the image dimensions
    local dimensions
    dimensions=$(identify -format "%wx%h" "$image_file")
    if [ -z "$dimensions" ]; then
        echo "Error: Unable to read image dimensions."
        return 1
    fi

    IFS='x' read -r width height <<< "$dimensions"

    local start_time=$(date +%s)

    for ((i = 0; i < 100; i++)); do
        local x=$((RANDOM % width))
        local y=$((RANDOM % height))

        # Get the RGBA value of the pixel
        rgba=$(convert "$image_file" -crop 1x1+"$x"+"$y" -format "%[pixel:p{0,0}]" info:-)
        # Strip unwanted characters and convert the RGBA value to decimal
        rgba=$(echo "$rgba" | tr -d 'rgba()' | tr ',' ' ' | tr -d 's')
        read -r R G B A <<< "$rgba"

        # Ensure R, G, B, A are valid numbers
        if [[ ! $R =~ ^[0-9]+$ || ! $G =~ ^[0-9]+$ || ! $B =~ ^[0-9]+$ || ! $A =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid RGBA values at ($x, $y): $rgba"
            continue
        fi

        printf "Coordinates: (%-4d, %-4d), RGBA: (%-3d, %-3d, %-3d, %-3d)\n" "$x" "$y" "$R" "$G" "$B" "$A"
    done

    # End timer
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))

    echo "Total time taken: $total_time seconds"
}

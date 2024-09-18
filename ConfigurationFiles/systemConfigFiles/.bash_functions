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

# Function to select all files with a specified extension in the given source directory
function find_ext() {
    local src_dir="."  # Default to current directory
    local ext="$1"  # The first argument is the file extension

    # Check if the first argument is actually a directory
    if [[ -d "$1" ]]; then
        src_dir="$1"  # If it's a directory, set it as the source directory
        ext="$2"  # The second argument is the file extension
    fi

    # Validate the extension
    if [[ -z "$ext" ]]; then
        echo "Usage: find_ext [source_directory] <extension>"
        return 1
    fi

    # Use ls -lah and grep to filter files by regex, then return the list
    ls -lah "$src_dir" | grep -E ".*\.${ext}$" | awk '{print $9}'
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

count_dirs() {
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

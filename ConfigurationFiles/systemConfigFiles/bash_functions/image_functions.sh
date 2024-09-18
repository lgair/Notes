#!/bin/sh

parse_tiff_header() {
    local image_file="$1"
    local header_size=8  # Initial header size
    local ifd_offset=0
    local num_entries=0
    local entry_size=12  # Each IFD entry is typically 12 bytes

    # Read byte order (first 2 bytes)
    local byte_order=$(od -An -t x2 -N 2 "$image_file" | tr -d ' ')

    # Get the first two characters
    byte_order="${byte_order:0:2}"

    # Print byte order for debugging
    printf "Byte Order: %s\n" "$byte_order" >&2

    # Determine endianness and read IFD offset
    if [[ "$byte_order" == "49" ]]; then
        # Little-endian (II)
        ifd_offset=$(od -An -t u4 -j 4 -N 4 "$image_file")
    elif [[ "$byte_order" == "4d" ]]; then
        # Big-endian (MM)
        ifd_offset=$(od -An -t u4 -j 4 -N 4 "$image_file" | awk '{print $1}' | xxd -r -p | od -An -t u4)
    else
        printf "Warning: Unknown byte order '%s'\n" "$byte_order" >&2
        return
    fi

    # Print IFD offset for debugging
    printf "IFD Offset: %d\n" "$ifd_offset" >&2

    # Read the number of IFD entries
    num_entries=$(od -An -t u2 -j "$ifd_offset" -N 2 "$image_file")

    # Calculate total header size
    local ifd_size=$(( num_entries * entry_size ))
    local true_header_size=$(( header_size + ifd_offset + ifd_size ))

    # Print true header size for debugging
    printf "True Header Size: %d bytes\n" "$true_header_size" >&2

    # Output the true header size
    echo "$true_header_size"
}

get_ifd_entry_sizes() {
    local image_file="$1"
    local ifd_offset=0
    local num_entries=0

    # Read byte order and IFD offset
    local byte_order=$(od -An -t x2 -N 2 "$image_file" | tr -d ' ')
    byte_order="${byte_order:0:2}"

    if [[ "$byte_order" == "49" ]]; then
        ifd_offset=$(od -An -t u4 -j 4 -N 4 "$image_file")
    elif [[ "$byte_order" == "4d" ]]; then
        ifd_offset=$(od -An -t u4 -j 4 -N 4 "$image_file" | awk '{print $1}' | xxd -r -p | od -An -t u4)
    fi

    # Read the number of entries
    num_entries=$(od -An -t u2 -j "$ifd_offset" -N 2 "$image_file")

    echo "Number of IFD Entries: $num_entries"

    # Read each entry
    for (( i=0; i<num_entries; i++ )); do
        local entry_offset=$(( ifd_offset + 2 + i * 12 ))
        
        # Read the tag, field type, number of values
        local tag=$(od -An -t u2 -j "$entry_offset" -N 2 "$image_file")
        local field_type=$(od -An -t u2 -j "$(( entry_offset + 2 ))" -N 2 "$image_file")
        local num_values=$(od -An -t u4 -j "$(( entry_offset + 4 ))" -N 4 "$image_file")

        # Determine size based on field type
        case $field_type in
            1) size=1 ;;    # BYTE
            2) size=1 ;;    # SBYTE
            3) size=2 ;;    # SHORT
            4) size=2 ;;    # SSHORT
            5) size=4 ;;    # LONG
            6) size=4 ;;    # SLONG
            7) size=1 ;;    # UNDEFINED
            8) size=4 ;;    # FLOAT
            9) size=8 ;;    # DOUBLE
            10) size=8 ;;   # RATIONAL
            11) size=8 ;;   # SRATIONAL
            *) size=0 ;;    # Unknown type
        esac

        # Calculate total size for the entry
        local total_entry_size=$(( size * num_values + 12 ))  # Entry size + 12 bytes for the entry itself
        printf "Entry %d: Tag: %d, Field Type: %d, Number of Values: %d, Total Size: %d bytes\n" \
               "$i" "$tag" "$field_type" "$num_values" "$total_entry_size"
    done
}


get_ifd_tags_and_values() {
    local image_file="$1"
    local ifd_offset=0
    local num_entries=0

    # Define a mapping of TIFF tags
    declare -A tag_names
    tag_names=(
        [254]="NewSubfileType"
        [256]="ImageWidth"
        [257]="ImageLength"
        [258]="BitsPerSample"
        [259]="Compression"
        [262]="PhotometricInterpretation"
        [271]="Make"
        [272]="Model"
        [273]="StripOffsets"
        [277]="SamplesPerPixel"
        [278]="RowsPerStrip"
        [279]="StripByteCounts"
        [282]="XResolution"
        [283]="YResolution"
        [284]="PlanarConfiguration"
        [296]="ResolutionUnit"
        [305]="Software"
        [337]="TargetPrinter"
        [338]="ExtraSamples"
        [34665]="ExifIFDPointer"  # Example for Exif tag
    )

    # Read byte order and IFD offset
    local byte_order=$(od -An -t x2 -N 2 "$image_file" | tr -d ' ')
    byte_order="${byte_order:0:2}"

    if [[ "$byte_order" == "49" ]]; then
        ifd_offset=$(od -An -t u4 -j 4 -N 4 "$image_file")
    elif [[ "$byte_order" == "4d" ]]; then
        ifd_offset=$(od -An -t u4 -j 4 -N 4 "$image_file" | awk '{print $1}' | xxd -r -p | od -An -t u4)
    fi

    # Read the number of entries
    num_entries=$(od -An -t u2 -j "$ifd_offset" -N 2 "$image_file")

    echo "Number of IFD Entries: $num_entries"

    # Read each entry and print tag names and values
    for (( i=0; i<num_entries; i++ )); do
        local entry_offset=$(( ifd_offset + 2 + i * 12 ))

        # Read the tag, field type, number of values
        local tag=$(od -An -t u2 -j "$entry_offset" -N 2 "$image_file" | xargs)
        local field_type=$(od -An -t u2 -j "$(( entry_offset + 2 ))" -N 2 "$image_file" | xargs)
        local num_values=$(od -An -t u4 -j "$(( entry_offset + 4 ))" -N 4 "$image_file" | xargs)
        local value_offset=$(od -An -t u4 -j "$(( entry_offset + 8 ))" -N 4 "$image_file" | xargs)

        # Read value based on field type
        local value=""
        case $field_type in
            1) value=$(od -An -t u1 -j "$(( value_offset ))" -N "$num_values" "$image_file" | tr -d ' ' | tr '\n' ' ') ;;  # BYTE
            2)
                # For STRING (2), read it directly as ASCII
                if (( num_values == 1 )); then
                    value=$(od -An -t u1 -j "$(( value_offset ))" -N 4 "$image_file" | tr -d ' ' | xxd -r -p)
                else
                    value=$(od -An -t u1 -j "$(( value_offset ))" -N "$num_values" "$image_file" | tr -d ' ' | xxd -r -p)
                fi
                ;;
            3) value=$(od -An -t u2 -j "$(( value_offset ))" -N "$(( num_values * 2 ))" "$image_file" | tr -d ' ' | tr '\n' ' ') ;;  # SHORT
            5)
                # For LONG (5), read as 4 bytes
                if (( num_values == 1 )); then
                    value=$(od -An -t u4 -j "$(( value_offset ))" -N 4 "$image_file")
                else
                    value=$(od -An -t u4 -j "$(( value_offset ))" -N "$(( num_values * 4 ))" "$image_file" | tr -d ' ')
                fi
                ;;
            7) value=$(od -An -t u1 -j "$(( value_offset ))" -N "$num_values" "$image_file" | tr -d ' ' | tr '\n' ' ') ;;  # UNDEFINED
            8) value=$(od -An -t f4 -j "$(( value_offset ))" -N "$(( num_values * 4 ))" "$image_file" | tr -d ' ' | tr '\n' ' ') ;;  # FLOAT
            9) value=$(od -An -t d8 -j "$(( value_offset ))" -N "$(( num_values * 8 ))" "$image_file" | tr -d ' ' | tr '\n' ' ') ;;  # DOUBLE
            *) value="Unknown type" ;;
        esac

        # Get the tag name from the mapping or mark as unknown
        local tag_name=${tag_names[$tag]:-"Unknown Tag"}

        # Print the tag and its value
        printf "Entry %d: %s (Tag: %d) = %s\n" "$i" "$tag_name" "$tag" "$value"
    done
}

dump_tiff_header() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: dump_tiff_header <tiff_file>"
        return 1
    fi

    local image_file="$1"

    if [[ ! -f "$image_file" ]]; then
        echo "Error: File '$image_file' not found." >&2
        return 1
    fi

    # Parse the header to find its size
    local header_size=$(parse_tiff_header "$image_file")

    # Check for errors in header size
    if [[ $? -ne 0 ]]; then
        echo "Failed to parse header size." >&2
        return 1
    fi

    # Dump the header based on the determined size
    echo "Header of TIFF file '$image_file':"
    hexdump -C "$image_file" | head -n $((header_size / 12 + 1))
}

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

    # Split dimensions into width and height
    IFS='x' read -r width height <<< "$dimensions"

    local start_time=$(date +%s)

    for ((i = 0; i < 100; i++)); do
        local x=$((RANDOM % width))
        local y=$((RANDOM % height))

        # Get the RGBA value of the pixel
        rgba=$(convert "$image_file" -crop 1x1+"$x+$y" -format "%[pixel:p{0,0}]" info:-)
        # Strip unwanted characters and convert the RGBA value to decimal
        rgba=$(echo "$rgba" | tr -d 'rgba()' | tr ',' ' ' | tr -d 's')

        # Use a pipe to read the values
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

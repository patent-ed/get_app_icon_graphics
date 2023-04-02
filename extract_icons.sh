#!/bin/bash

# Set the source and destination directories
src_dir="/Applications"
dest_dir="$HOME/Desktop/application_icons"

# Create the destination directory if it doesn't exist
mkdir -p "$dest_dir"

# Function to extract icons from .icns files and convert them to .png format
extract_icon() {
    local icns_path="$1"
    local output_path="$2"
    sips -s format png --out "$output_path" "$icns_path" >/dev/null 2>&1
}

# Iterate through the applications in the source directory
find "$src_dir" -maxdepth 3 -type d -iname '*.app' | while read -r app_path; do
    app_name="$(basename "$app_path" .app)"
    icon_file="$(defaults read "$app_path/Contents/Info" CFBundleIconFile 2>/dev/null)"
    icon_file="${icon_file%.icns}.icns"

    # If the icon file is found, extract and save it
    if [[ -n "$icon_file" && -e "$app_path/Contents/Resources/$icon_file" ]]; then
        extract_icon "$app_path/Contents/Resources/$icon_file" "$dest_dir/$app_name.png"
    fi
done

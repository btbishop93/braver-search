#!/bin/bash

# Generate iOS icons (square)
IOS_ASSET_PATH="Braver Search/Shared (App)/Assets.xcassets/AppIcon.appiconset"
for size in 16 20 29 32 40 48 60 64 76 83.5 96 128 256 512 1024 2048; do
  /opt/homebrew/bin/rsvg-convert -w ${size%.*} -h ${size%.*} braver.svg > "$IOS_ASSET_PATH/icon-${size}.png"
done

for size in 20 29 40 60 76; do
  /opt/homebrew/bin/rsvg-convert -w $((size*2)) -h $((size*2)) braver.svg > "$IOS_ASSET_PATH/icon-${size}@2x.png"
done

for size in 20 29 40 60; do
  /opt/homebrew/bin/rsvg-convert -w $((size*3)) -h $((size*3)) braver.svg > "$IOS_ASSET_PATH/icon-${size}@3x.png"
done

/opt/homebrew/bin/rsvg-convert -w 167 -h 167 braver.svg > "$IOS_ASSET_PATH/icon-83.5@2x.png"

# Add missing iOS sizes
declare -a ios_sizes=(
    "16" "20" "29" "32" "40" "48" "60" "64" 
    "76" "83.5" "96" "128" "256" "512" "1024" "2048"
)

# Add retina validation
for size in 20 29 40 60 76; do
    if [ ! -f "$IOS_ASSET_PATH/icon-${size}@2x.png" ]; then
        echo "Error: Missing iOS icon ${size}@2x"
        exit 1
    fi
done

# Generate macOS icons (rounded)
MAC_ASSET_PATH="Braver Search/Shared (App)/Assets.xcassets/AppIcon.appiconset"
declare -a mac_sizes=("16" "32" "64" "128" "256" "512" "1024")

# Generate 1x and 2x sizes
for size in "${mac_sizes[@]}"; do
  # 1x scale
  /opt/homebrew/bin/rsvg-convert -w $size -h $size braver-rounded.svg > "$MAC_ASSET_PATH/mac-${size}.png"
  # 2x scale
  double_size=$((size*2))
  /opt/homebrew/bin/rsvg-convert -w $double_size -h $double_size braver-rounded.svg > "$MAC_ASSET_PATH/mac-${size}@2x.png"
done

# Special case for 16x16@2x (32x32)
/opt/homebrew/bin/rsvg-convert -w 32 -h 32 braver-rounded.svg > "$MAC_ASSET_PATH/mac-16@2x.png"

# Generate 512@2x (1024x1024) separately to avoid duplication
/opt/homebrew/bin/rsvg-convert -w 1024 -h 1024 braver-rounded.svg > "$MAC_ASSET_PATH/mac-512@2x.png"

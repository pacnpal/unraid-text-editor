#!/bin/bash
# Build script for text-editor plugin (macOS version)

# Enable error checking
set -e

# Plugin information
plugin="text-editor"
version=$(date +"%Y.%m.%d")
tmpdir="/tmp/tmp.$(jot -r 1 1000 9999)"
current_dir=$(pwd)

echo "Starting build process..."
echo "Plugin: $plugin"
echo "Version: $version"
echo "Working directory: $current_dir"

# Clean up any previous builds
echo "Cleaning previous builds..."
rm -rf "$tmpdir"
mkdir -p "$tmpdir"
rm -rf "archive"
mkdir -p "archive"

# Create plugin package structure
echo "Creating plugin structure..."
mkdir -p "$tmpdir/usr/local/emhttp/plugins/$plugin"/{images,event,include}

# First create required files and directories if they don't exist
echo "Setting up source directories..."
mkdir -p "source/usr/local/emhttp/plugins/$plugin"/{images,event,include}

# Copy files
echo "Copying files..."
cp "source/usr/local/emhttp/plugins/$plugin/$plugin.page" "$tmpdir/usr/local/emhttp/plugins/$plugin/"
cp "source/usr/local/emhttp/plugins/$plugin/include/fileop.php" "$tmpdir/usr/local/emhttp/plugins/$plugin/include/"

# Rename and copy Dynamix event file
mv "source/usr/local/emhttp/plugins/$plugin/event/dynamix.file.menu.php" \
   "source/usr/local/emhttp/plugins/$plugin/event/dynamix_context_menu.php" 2>/dev/null || true
cp "source/usr/local/emhttp/plugins/$plugin/event/dynamix_context_menu.php" \
   "$tmpdir/usr/local/emhttp/plugins/$plugin/event/"

# Set permissions
echo "Setting permissions..."
find "$tmpdir" -type d -exec chmod 755 {} \;
find "$tmpdir" -type f -exec chmod 644 {} \;

# Create the package
echo "Creating package..."
cd "$tmpdir"
XZ_OPT=-9 tar -cJf "$current_dir/archive/$plugin-$version.txz" ./usr
cd "$current_dir"

# Verify package was created
if [ ! -f "archive/$plugin-$version.txz" ]; then
    echo "Error: Package file was not created!"
    exit 1
fi

# Calculate MD5
echo "Calculating MD5..."
md5_hash=$(md5 -q "archive/$plugin-$version.txz")
echo "$md5_hash" > "archive/$plugin-$version.md5"

# Clean up
echo "Cleaning up..."
rm -rf "$tmpdir"

echo ""
echo "Build completed successfully!"
echo "Package: archive/$plugin-$version.txz"
echo "Size: $(ls -lh "archive/$plugin-$version.txz" | awk '{print $5}')"
echo "MD5: $md5_hash"
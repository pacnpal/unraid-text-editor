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

# Create empty files if they don't exist
for file in \
    "source/usr/local/emhttp/plugins/$plugin/$plugin.page" \
    "source/usr/local/emhttp/plugins/$plugin/include/fileop.php" \
    "source/usr/local/emhttp/plugins/$plugin/event/dynamix.file.menu.php"
do
    if [ ! -f "$file" ]; then
        echo "Creating empty file: $file"
        touch "$file"
    fi
done

# Copy files
echo "Copying files..."
cp "source/usr/local/emhttp/plugins/$plugin/$plugin.page" "$tmpdir/usr/local/emhttp/plugins/$plugin/"
cp "source/usr/local/emhttp/plugins/$plugin/include/fileop.php" "$tmpdir/usr/local/emhttp/plugins/$plugin/include/"
cp "source/usr/local/emhttp/plugins/$plugin/event/dynamix.file.menu.php" "$tmpdir/usr/local/emhttp/plugins/$plugin/event/"

# Set permissions
echo "Setting permissions..."
chmod -R 755 "$tmpdir"
find "$tmpdir" -type f -exec chmod 644 {} \;

# Create the package
echo "Creating package..."
cd "$tmpdir"
tar -czf "$current_dir/archive/$plugin-$version.txz" ./*
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

# Create or update plugin file
if [ ! -f "$plugin.plg" ]; then
    echo "Creating .plg file..."
    cat > "$plugin.plg" << EOF
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE PLUGIN [
<!ENTITY name "text-editor">
<!ENTITY author "Your Name">
<!ENTITY version "&version;">
<!ENTITY launch "Settings/TextEditor">
<!ENTITY pluginURL "https://raw.githubusercontent.com/&github;/master/&name;.plg">
<!ENTITY source "/boot/config/plugins/&name;/&name;-&version;.txz">
<!ENTITY MD5 "&md5_hash;">
<!ENTITY github "username/repository">
]>
<PLUGIN name="&name;" author="&author;" version="&version;" launch="&launch;" pluginURL="&pluginURL;" min="6.9.2">
</PLUGIN>
EOF
fi

echo "Updating plugin file..."
sed -i '' -e "s/\&version\;/$version/g" \
         -e "s/\&MD5\;/$md5_hash/g" \
         "$plugin.plg"

# Clean up
echo "Cleaning up..."
rm -rf "$tmpdir"

# Final verification
if [ -f "archive/$plugin-$version.txz" ] && [ -f "archive/$plugin-$version.md5" ]; then
    echo ""
    echo "Build completed successfully!"
    echo "Package: archive/$plugin-$version.txz"
    echo "Size: $(ls -lh "archive/$plugin-$version.txz" | awk '{print $5}')"
    echo "MD5: $md5_hash"
    echo ""
else
    echo "Error: Build process failed!"
    exit 1
fi
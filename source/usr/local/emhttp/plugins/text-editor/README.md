# Universal Text Editor Plugin for Unraid

A simple yet powerful text editor plugin for Unraid that allows you to edit any text file directly from the web interface. Integrates with Dynamix File Manager for easy access.

## Features

- Edit any text file directly from Unraid's web interface
- Integrated with Dynamix File Manager (right-click context menu)
- Syntax highlighting for common file types:
  - PHP
  - JavaScript
  - CSS
  - HTML/XML
  - Shell scripts
- Keyboard shortcuts (Ctrl+S to save)
- Security-focused with proper permission checking
- Compatible with Unraid 6.9.2+

## Installation

### From Community Applications
1. Open the Community Applications page in Unraid
2. Search for "Universal Text Editor"
3. Click "Install"

### Manual Installation
1. Download the .plg file
2. In Unraid webUI, go to Plugins -> Install Plugin
3. Provide the URL or local path to the .plg file
4. Click "Install"

## Usage

### From Tools Menu
1. Navigate to Tools -> Text Editor in Unraid's web interface
2. Enter the path to the file you want to edit
3. Click "Load" to open the file
4. Make your changes
5. Click "Save" or use Ctrl+S to save changes

### From File Manager
1. Navigate to your file in Dynamix File Manager
2. Right-click on any text file
3. Select "Edit in Text Editor"
4. Make your changes
5. Save using the Save button or Ctrl+S

## Building from Source

### Requirements
- Linux/macOS development system
- For Linux: `tar`, `xz-utils`
- For macOS: 
  ```bash
  brew install gnu-tar xz coreutils gnu-sed
  ```

### Build Steps
1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd text-editor
   ```

2. Make the build script executable:
   ```bash
   chmod +x pkg_build.sh
   ```

3. Run the build script:
   ```bash
   ./pkg_build.sh
   ```

4. The package will be created in the `archive` directory

## Security

The plugin implements several security measures:
- Authentication required for all operations
- File permission checking
- Protected path restrictions
- Input validation
- Proper error handling

## Support

For support:
- Visit the [support thread](https://forums.unraid.net/topic/YOUR-THREAD-ID) on the Unraid forums
- Create an issue on the [GitHub repository](https://github.com/YOUR-REPO)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This plugin is released under the MIT License. See the LICENSE file for details.

## Acknowledgments

- Thanks to Bergware for the Dynamix system that this integrates with
- Thanks to the Unraid team for their plugin system
- Built using CodeMirror for the text editing interface

## Changelog

### 2025.01.03
- Initial Release
  - Basic text editing functionality
  - Dynamix File Manager integration
  - Syntax highlighting
  - Security features
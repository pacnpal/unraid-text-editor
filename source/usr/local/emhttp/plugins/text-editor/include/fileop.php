<?PHP
$docroot = $docroot ?? $_SERVER['DOCUMENT_ROOT'] ?: '/usr/local/emhttp';

// Check authentication
require_once "$docroot/webGui/include/Wrappers.php";
require_once "$docroot/webGui/include/Helpers.php";
require_once "$docroot/webGui/include/Secure.php";

// Initialize response
header('Content-Type: application/json');

// Get parameters
$action = $_POST['action'] ?? '';
$file = $_POST['file'] ?? '';
$content = $_POST['content'] ?? '';

// Security checks
function validate_path($file) {
    if (!$file) return false;
    
    // Get real path, allowing for new files
    $dir = dirname($file);
    $realdir = realpath($dir);
    if ($realdir === false) return false;
    
    // Restricted paths
    $restricted = [
        '/boot/config/super.dat',
        '/boot/config/shadow',
        '/boot/config/secrets',
        '/etc/shadow',
        '/etc/passwd',
        '/etc/fstab',
    ];
    
    foreach ($restricted as $path) {
        if (strpos($realdir, dirname($path)) === 0) return false;
    }
    
    return true;
}

function check_permissions($file, $check_write = false) {
    $dir = dirname($file);
    
    if (!file_exists($dir)) {
        return ['error' => 'Directory does not exist'];
    }
    
    if (!is_dir($dir)) {
        return ['error' => 'Invalid directory path'];
    }
    
    if (file_exists($file)) {
        if (!is_readable($file)) {
            return ['error' => 'File is not readable'];
        }
        if ($check_write && !is_writable($file)) {
            return ['error' => 'File is not writable'];
        }
    } else {
        if (!is_writable($dir)) {
            return ['error' => 'Directory is not writable'];
        }
    }
    
    return ['success' => true];
}

// Validate input
if (!validate_path($file)) {
    die(json_encode(['error' => 'Invalid file path']));
}

// Process request
switch ($action) {
    case 'read':
        $check = check_permissions($file);
        if (isset($check['error'])) {
            die(json_encode($check));
        }
        
        if (!file_exists($file)) {
            die(json_encode(['error' => 'File does not exist']));
        }
        
        $content = file_get_contents($file);
        if ($content === false) {
            die(json_encode(['error' => 'Failed to read file']));
        }
        
        die(json_encode(['content' => $content]));
        
    case 'write':
        $check = check_permissions($file, true);
        if (isset($check['error'])) {
            die(json_encode($check));
        }
        
        // Create directory if it doesn't exist
        $dir = dirname($file);
        if (!file_exists($dir)) {
            if (!mkdir($dir, 0755, true)) {
                die(json_encode(['error' => 'Failed to create directory']));
            }
        }
        
        // Write file with proper permissions
        if (file_put_contents($file, $content) === false) {
            die(json_encode(['error' => 'Failed to write file']));
        }
        
        // Set proper permissions if new file
        if (!file_exists($file)) {
            chmod($file, 0644);
        }
        
        die(json_encode(['success' => true]));
        
    default:
        die(json_encode(['error' => 'Invalid action']));
}

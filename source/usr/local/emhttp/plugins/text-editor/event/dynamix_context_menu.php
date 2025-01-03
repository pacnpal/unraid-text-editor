<?PHP
$docroot = $docroot ?? $_SERVER['DOCUMENT_ROOT'] ?: '/usr/local/emhttp';
require_once "$docroot/webGui/include/Wrappers.php";

// Get the event name from the filename
$event = pathinfo(__FILE__, PATHINFO_FILENAME);
$event = str_replace('dynamix.', '', $event);

switch ($event) {
    case 'file.menu':
        // Only add menu item for files, not directories
        if (isset($type) && $type === 'f') {
            // Check if it's a text file
            $finfo = finfo_open(FILEINFO_MIME_TYPE);
            $mime_type = finfo_file($finfo, $path);
            finfo_close($finfo);
            
            $extension = strtolower(pathinfo($path, PATHINFO_EXTENSION));
            $is_text = strpos($mime_type, 'text/') === 0 || 
                      in_array($extension, ['txt', 'log', 'cfg', 'conf', 'ini', 'sh', 'php', 'css', 'js', 'xml', 'html']);
            
            if ($is_text) {
                $menu['Edit in Text Editor'] = [
                    'icon' => 'icon-edit',
                    'href' => '/Tools/TextEditor?file='.urlencode($path)
                ];
                
                if (isset($menu['Edit'])) {
                    // Move our entry after the default edit option
                    $edit = $menu['Edit'];
                    unset($menu['Edit']);
                    $menu = array_merge(
                        array_slice($menu, 0, 1),
                        ['Edit' => $edit],
                        ['Edit in Text Editor' => $menu['Edit in Text Editor']],
                        array_slice($menu, 1)
                    );
                }
            }
        }
        break;
}
<?PHP
$docroot = $docroot ?? $_SERVER['DOCUMENT_ROOT'] ?: '/usr/local/emhttp';
require_once "$docroot/webGui/include/Wrappers.php";

// Get the event name from the filename
$event = pathinfo(__FILE__, PATHINFO_FILENAME);
$event = str_replace('dynamix.', '', $event);

switch ($event) {
    case 'file.menu':
        // Add menu item for all files
        if (isset($type) && $type === 'f') {
            $menu['Edit in Text Editor'] = [
                'icon' => 'icon-edit',
                'href' => '/Tools/TextEditor?file='.urlencode($path)
            ];
        }
        break;
}
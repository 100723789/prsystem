<?php
require 'jwt_handler.php';
require 'db.php';

// Authenticate user (check JWT)
function authenticate() {
    $headers = getallheaders();
    if (!isset($headers['Authorization']) || !validateJWT(str_replace("Bearer ", "", $headers['Authorization']))) {
        http_response_code(403);
        echo json_encode(["error" => "Access Denied: Invalid or missing token."]);
        exit;
    }
}

// Handle file download request
if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['file'])) {
    // Authenticate user before serving the file
    authenticate();

    $filename = basename($_GET['file']);  // Get the filename safely
    $file_path = __DIR__ . "/uploads/" . $filename;

    // Check if the file exists
    if (file_exists($file_path)) {
        // Set headers to force download
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename="' . $filename . '"');
        header('Content-Length: ' . filesize($file_path));
        readfile($file_path);
        exit;
    } else {
        http_response_code(404);
        echo json_encode(["error" => "File not found"]);
        exit;
    }
}
?>

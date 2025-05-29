<?php
$host = 'sql204.infinityfree.com';
$db   = 'if0_39042580_prs_database';
$user = 'if0_39042580';
$pass = '2oATNDnCPR';

try {
    $conn = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "error" => "Database connection failed",
        "details" => $e->getMessage()
    ]);
    exit;
}
?>

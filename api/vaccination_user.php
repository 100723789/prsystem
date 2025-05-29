<?php
header("Content-Type: application/json");

require_once 'db.php';
require_once 'jwt_handler.php';

$headers = getallheaders();
$token = str_replace("Bearer ", "", $headers["Authorization"] ?? "");
$decoded = decode_jwt($token);

if (!$decoded) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$user_id = $decoded->data->id;
$role_id = $decoded->data->role_id;

if ($role_id != 3) {
    http_response_code(403);
    echo json_encode(["error" => "Forbidden"]);
    exit;
}

$stmt = $conn->prepare("SELECT username, vaccine_name, dose_number, date_administered, provider FROM vaccination_records WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$records = [];
while ($row = $result->fetch_assoc()) {
    $records[] = $row;
}

echo json_encode($records);
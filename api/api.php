<?php
ob_start(); // Prevent premature output
ini_set('display_errors', 0); // Disable error output in production
error_reporting(0);    
// Polyfill for getallheaders for non-Apache environments
if (!function_exists('getallheaders')) {
    function getallheaders() {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
            if (str_starts_with($name, 'HTTP_')) {
                $key = str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))));
                $headers[$key] = $value;
            }
        }
        return $headers;
    }
}

// Enable error reporting for debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
ob_clean(); // Clean any stray output buffer
// Headers for JSON and CORS
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

require 'db.php';
require 'jwt_handler.php';

// Helper: Validate JWT
function authenticate() {
    $headers = getallheaders();
    if (!isset($headers['Authorization']) || !validateJWT(str_replace("Bearer ", "", $headers['Authorization']))) {
        http_response_code(403);
        echo json_encode(["error" => "Access Denied: Invalid or missing token."]);
        exit;
    }
}
// Helper: Decode JWT payload
function decodeUser() {
    $token = str_replace("Bearer ", "", getallheaders()['Authorization'] ?? '');
    return decode_jwt($token);
}

function log_action($user_id, $action, $entity, $record_id = null) {
    global $conn;
    $stmt = $conn->prepare("INSERT INTO audit_logs (user_id, action, entity_affected, record_id, timestamp) VALUES (?, ?, ?, ?, NOW())");
    $stmt->execute([$user_id, $action, $entity, $record_id]);
}

$method = $_SERVER['REQUEST_METHOD'];

// Login
if ($method === 'POST' && isset($_GET['login'])) {
    $data = json_decode(file_get_contents("php://input"), true);
    if (empty($data['email']) || empty($data['password'])) {
        http_response_code(400);
        echo json_encode(["error" => "Email and password are required"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT user_id, email, password_hash, role_id FROM users WHERE email = ?");
    $stmt->execute([$data['email']]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user && password_verify($data['password'], $user['password_hash'])) {
        echo json_encode([
            "token" => createJWT($user['user_id'], $user['role_id'], $user['email']),
            "role" => $user['role_id'],
            "email" => $user['email']
        ]);
    } else {
        http_response_code(401);
        echo json_encode(["error" => "Invalid credentials"]);
    }
    exit;
}

// Register
if ($method === 'POST' && isset($_GET['users'])) {
    $data = json_decode(file_get_contents("php://input"), true);
    if (empty($data['username']) || empty($data['email']) || empty($data['password']) || !isset($data['role_id'])) {
        http_response_code(400);
        echo json_encode(["error" => "Missing required fields"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT COUNT(*) FROM users WHERE email = ?");
    $stmt->execute([$data['email']]);
    if ($stmt->fetchColumn() > 0) {
        echo json_encode(["status" => "error", "message" => "User already exists"]);
        exit;
    }

    $password_hash = password_hash($data['password'], PASSWORD_DEFAULT);
    $stmt = $conn->prepare("INSERT INTO users (username, email, password_hash, role_id) VALUES (?, ?, ?, ?)");
    if ($stmt->execute([$data['username'], $data['email'], $password_hash, $data['role_id']])) {
        $admin_id = $payload['data']['id'] ?? null;
log_action($admin_id, "Registered user", "users", $conn->lastInsertId());


        echo json_encode(["status" => "success", "message" => "User registered successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => "Failed to register user"]);
    }
    exit;
}

// Get all users (admin only)
if ($method === 'GET' && isset($_GET['users'])) {
    authenticate();
    $stmt = $conn->query("SELECT user_id, username, email, role_id, created_at FROM users");
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

// Admin/Merchant - Get all vaccination records
if ($method === 'GET' && array_key_exists('vaccination-records', $_GET)) {

    authenticate();
    $stmt = $conn->query("SELECT user_id, vaccine_name, dose_number, date_administered, provider FROM vaccination_records");
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

if ($method === 'GET' && isset($_GET['my-vaccinations'])) {
    authenticate();
    $payload = decodeUser();

    $role = is_array($payload) ? $payload['data']['role_id'] : $payload->data->role_id;
    $user_id = is_array($payload) ? $payload['data']['id'] : $payload->data->id;

    if ($role != 3) {
        http_response_code(403);
        echo json_encode(["error" => "Forbidden"]);
        exit;
    }

    $stmt = $conn->prepare("SELECT vaccine_name, dose_number, date_administered, provider FROM vaccination_records WHERE user_id = ?");
    $stmt->execute([$user_id]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

if ($method === 'POST' && isset($_GET['update-role'])) {
    authenticate();
    $payload = decodeUser();

    if ($payload['data']['role_id'] != 1) {
        http_response_code(403);
        echo json_encode(["error" => "Only admins can update roles."]);
        exit;
    }

    $data = json_decode(file_get_contents("php://input"), true);

    if (empty($data['user_id']) || !isset($data['new_role'])) {
        http_response_code(400);
        echo json_encode(["error" => "Missing user_id or new_role"]);
        exit;
    }

    $stmt = $conn->prepare("UPDATE users SET role_id = ? WHERE user_id = ?");
    if ($stmt->execute([$data['new_role'], $data['user_id']])) {
        echo json_encode(["status" => "success", "message" => "Role updated"]);
        log_action($payload['data']['id'], "Updated user role", "users", $data['user_id']);

    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to update role"]);
    }
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_GET['delete-user'])) {
    authenticate();
    $payload = decodeUser();
    if ($payload['data']['role_id'] != 1) {
        http_response_code(403);
        echo json_encode(["error" => "Only admins can delete users."]);
        exit;
    }

    $data = json_decode(file_get_contents("php://input"), true);
    if (empty($data['user_id'])) {
        http_response_code(400);
        echo json_encode(["error" => "Missing user_id"]);
        exit;
    }

    $stmt = $conn->prepare("DELETE FROM users WHERE user_id = ?");
    if ($stmt->execute([$data['user_id']])) {
        echo json_encode(["status" => "success", "message" => "User deleted"]);
        log_action($payload['data']['id'], "Deleted user", "users", $data['user_id']);

    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to delete user"]);
    }
    exit;
}



// Fetch list of uploaded files
if ($method === 'GET' && (isset($_GET['uploads']) || strpos($_SERVER['REQUEST_URI'], '/uploads') !== false)) {
    authenticate();
    $payload = decodeUser();

    $user_id = $payload['data']['id'];
    $role_id = $payload['data']['role_id'];

    if ($role_id == 1) {
        // Admin sees all files
        $stmt = $conn->query("SELECT file_path, uploaded_by, upload_date FROM documents ORDER BY upload_date DESC");
} elseif ($role_id == 2) {
    // Merchant sees their own and user-uploaded files
    $stmt = $conn->prepare("
        SELECT file_path, uploaded_by, upload_date 
        FROM documents 
        WHERE uploaded_by = :merchant_id
           OR uploaded_by IN (
               SELECT user_id FROM users WHERE role_id = 3
           )
        ORDER BY upload_date DESC
    ");
    $stmt->execute(['merchant_id' => $user_id]);
} else {
    // Regular user sees only their own
    $stmt = $conn->prepare("SELECT file_path, uploaded_by, upload_date FROM documents WHERE uploaded_by = ? ORDER BY upload_date DESC");
    $stmt->execute([$user_id]);
}

    $files = $stmt instanceof PDOStatement ? $stmt->fetchAll(PDO::FETCH_ASSOC) : [];
    echo json_encode($files);
    exit;
}


// Upload file
if ($method === 'POST' && isset($_GET['upload'])) {

    authenticate();
    $payload = decodeUser();
    $user_id = $payload['data']['id'];

    if (!isset($_FILES['file'])) {
        http_response_code(400);
        echo json_encode(["error" => "No file uploaded"]);
        exit;
    }

    $file = $_FILES['file'];
    $uploadDir = __DIR__ . '/uploads/';
    if (!file_exists($uploadDir)) {
        mkdir($uploadDir, 0755, true);
    }

    $filename = basename($file['name']);

    $targetPath = $uploadDir . $filename;

    if (move_uploaded_file($file['tmp_name'], $targetPath)) {
        $stmt = $conn->prepare("INSERT INTO documents (file_path, uploaded_by, upload_date) VALUES (?, ?, NOW())");
        $stmt->execute([$filename, $user_id]);
        log_action($user_id, "Uploaded file", "documents", $conn->lastInsertId());

        echo json_encode([
            "status" => "success",
            "message" => "File uploaded successfully",
            "file_path" => $filename
        ]);

    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to move uploaded file"]);
    }
    exit;
}




if ($method === 'POST' && isset($_GET['delete-upload'])) {
    file_put_contents(__DIR__ . '/debug_test.txt', "DELETE block reached\n", FILE_APPEND);

    authenticate();
    $payload = decodeUser();
    $role = $payload['data']['role_id'];

    if ($role != 1) {
        http_response_code(403);
        echo json_encode(["error" => "Only admins can delete files."]);
        exit;
    }

$rawPost = file_get_contents("php://input");
file_put_contents(__DIR__ . '/debug_delete_payload.log', "RAW JSON: $rawPost" . PHP_EOL, FILE_APPEND);

$data = json_decode($rawPost, true);


    if (empty($data['filename'])) {
        http_response_code(400);
        echo json_encode(["error" => "Missing filename"]);
        exit;
    }

    $filename = basename($data['filename']);
    file_put_contents(__DIR__ . '/debug_delete_payload.log', "Received filename: " . $filename . PHP_EOL, FILE_APPEND);

    $filePath = __DIR__ . '/uploads/' . $filename;

    if (file_exists($filePath)) {
        unlink($filePath);
    }

    $stmt = $conn->prepare("DELETE FROM documents WHERE file_path = ?");
    if ($stmt->execute([$filename])) {
        log_action($payload['data']['id'], "Deleted file", "documents", $filename);

        echo json_encode(["status" => "success", "message" => "File deleted"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to delete from database"]);
    }

    exit;
}






if (isset($_GET['audit-logs'])) {
    authenticate();
    $payload = decodeUser();
    $role = is_array($payload) ? $payload['data']['role_id'] : $payload->data->role_id;

    if ($role != 1) {
        http_response_code(403);
        echo json_encode(["error" => "Admins only"]);
        exit;
    }

   
    $stmt = $conn->query("SELECT user_id, action, entity_affected AS entity, record_id, timestamp FROM audit_logs ORDER BY timestamp DESC");
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}


if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['encryption-keys'])) {
    authenticate();
    $payload = decodeUser();

    $role = is_array($payload) ? $payload['data']['role_id'] : $payload->data->role_id;

    if ($role != 1) {
        http_response_code(403);
        echo json_encode(["error" => "Admins only"]);
        exit;
    }

    $stmt = $conn->query("SELECT key_type, owner, created_date FROM encryption_keys");
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_GET['change-password'])) {
    authenticate(); // verifies and sets user context
    $payload = decodeUser();
    $user_id = is_array($payload) ? $payload['data']['id'] : $payload->data->id;

    $data = json_decode(file_get_contents("php://input"), true);
    $old_password = $data['old_password'] ?? '';
    $new_password = $data['new_password'] ?? '';

    if (!$old_password || !$new_password) {
        http_response_code(400);
        echo json_encode(["error" => "Missing password fields"]);
        exit;
    }

    // Check old password
    $stmt = $conn->prepare("SELECT password_hash FROM users WHERE user_id = ?");
    $stmt->execute([$user_id]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$user || !password_verify($old_password, $user['password_hash'])) {
        http_response_code(403);
        echo json_encode(["error" => "Old password is incorrect"]);
        exit;
    }

    // Update to new password
    $new_hash = password_hash($new_password, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("UPDATE users SET password_hash = ? WHERE user_id = ?");
    $success = $stmt->execute([$new_hash, $user_id]);

    if ($success) {
        log_action($user_id, "Changed password", "users", $user_id);
        echo json_encode(["status" => "success", "message" => "Password updated"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to update password"]);
    }

    exit;
}

// Get audit logs for the logged-in user
if ($method === 'GET' && isset($_GET['my-audit'])) {
    authenticate();
    $payload = decodeUser();
    $user_id = is_array($payload) ? $payload['data']['id'] : $payload->data->id;

    $stmt = $conn->prepare("SELECT action, entity_affected AS entity, record_id, timestamp FROM audit_logs WHERE user_id = ? ORDER BY timestamp DESC");

    $stmt->execute([$user_id]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}
if ($method === 'GET' && isset($_GET['doctors'])) {
    $stmt = $conn->prepare("SELECT user_id, username FROM users WHERE role_id = 2");
    $stmt->execute();
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}

// Save appointment
if ($method === 'POST' && isset($_GET['book-appointment'])) {
    authenticate();
    $payload = decodeUser();
    $user_id = is_array($payload) ? $payload['data']['id'] : $payload->data->id;

    $data = json_decode(file_get_contents("php://input"), true);
$date = $data['date'] ?? null;
$time = $data['time'] ?? null;
$doctor_id = $data['doctor_id'] ?? null;

if (!$date || !$time || !$doctor_id) {
    http_response_code(400);
    echo json_encode(["error" => "Missing date, time, or doctor"]);
    exit;
}
$stmt = $conn->prepare("INSERT INTO appointments (user_id, appointment_date, appointment_time, doctor_id) VALUES (?, ?, ?, ?)");
$stmt->execute([$user_id, $date, $time, $doctor_id]);

    log_action($user_id, "Booked an appointment for $date at $time", "appointments", "$date $time");
    file_put_contents("debug.log", json_encode($data));
    echo json_encode(["status" => "success", "message" => "Appointment saved"]);
    exit;
}


if (isset($_GET['view-appointments'])) {
    authenticate();
    $payload = decodeUser();

    $user_id = is_array($payload) ? $payload['data']['id'] : $payload->data->id;
    $role = is_array($payload) ? $payload['data']['role_id'] : $payload->data->role_id;

    if ($role !== 2) {
        http_response_code(403);
        echo json_encode(["error" => "Access denied. Only doctors can view appointments."]);
        exit;
    }

    $stmt = $conn->prepare("
  SELECT 
    id,                            
    user_id AS patient_id,
    appointment_date AS date,
    appointment_time AS time,
    status 
  FROM appointments 
  WHERE doctor_id = ?
");

    $stmt->execute([$user_id]);
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
    exit;
}


// Get available time slots for a specific date and doctor
if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'available-times') {

    $data = json_decode(file_get_contents("php://input"), true);
    $date = $data['date'] ?? null;
    $doctor_id = $data['doctor_id'] ?? null;

    if (!$date || !$doctor_id) {
        http_response_code(400);
        echo json_encode(["error" => "Missing date or doctor_id"]);
        exit;
    }

    // Define fixed half-hour slots (09:00–17:00 as an example)
    $all_slots = [];
    $start = strtotime("09:00");
    $end = strtotime("17:00");
    while ($start < $end) {
        $all_slots[] = date("H:i", $start);
        $start += 30 * 60; // add 30 minutes
    }

    // Fetch booked slots
    $stmt = $conn->prepare("SELECT appointment_time FROM appointments WHERE appointment_date = ? AND doctor_id = ?");
    $stmt->execute([$date, $doctor_id]);
    $booked_raw = $stmt->fetchAll(PDO::FETCH_COLUMN);
$booked = array_map(fn($time) => substr($time, 0, 5), $booked_raw);
$current_date = date("Y-m-d");
$current_time = date("H:i");

if ($date === $current_date) {
    $all_slots = array_filter($all_slots, fn($slot) => $slot > $current_time);
}


    // Filter out booked slots
    $available = array_values(array_diff($all_slots, $booked));
    echo json_encode(["available_times" => $available]);
    exit;
}

if ($method === 'POST' && isset($_GET['action']) && $_GET['action'] === 'delete-appointment') {
    authenticate();
    $payload = decodeUser();

    $user_id = is_array($payload) ? $payload['data']['id'] : $payload->data->id;
    $role = is_array($payload) ? $payload['data']['role_id'] : $payload->data->role_id;

    $data = json_decode(file_get_contents("php://input"), true);
    $appointment_id = $data['appointment_id'] ?? null;

    if (!$appointment_id) {
        http_response_code(400);
        echo json_encode(["error" => "Missing appointment_id"]);
        exit;
    }

    // Allow doctors to delete only their own appointments or admins all
    $query = $role === 1
        ? "DELETE FROM appointments WHERE id = ?"
        : "DELETE FROM appointments WHERE id = ? AND doctor_id = ?";

    $stmt = $conn->prepare($query);
    $params = $role === 1 ? [$appointment_id] : [$appointment_id, $user_id];
    $stmt->execute($params);

    echo json_encode(["status" => "success", "message" => "Appointment deleted"]);
    exit;
}


if ($_SERVER['REQUEST_METHOD'] === 'POST' && $_GET['action'] === 'update-appointment-status') {
    authenticate();
    $payload = decodeUser();
    $user_id = $payload['data']['id'];
    $role = $payload['data']['role_id'];

    $data = json_decode(file_get_contents("php://input"), true);
    $appointment_id = $data['appointment_id'] ?? null;
    $status = $data['status'] ?? null;

    if (!$appointment_id || !$status) {
        http_response_code(400);
        echo json_encode(["error" => "Missing appointment_id or status"]);
        exit;
    }

    $stmt = $conn->prepare("UPDATE appointments SET status = ? WHERE id = ?" . ($role === 2 ? " AND doctor_id = ?" : ""));
    $params = $role === 2 ? [$status, $appointment_id, $user_id] : [$status, $appointment_id];

    if ($stmt->execute($params)) {
        log_action($user_id, "Updated appointment status to $status", "appointments", $appointment_id);
        echo json_encode(["status" => "success", "message" => "Appointment status updated"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to update appointment"]);
    }
    exit;
}




// 404 Fallback
http_response_code(404);
echo json_encode(["error" => "Invalid route"]);
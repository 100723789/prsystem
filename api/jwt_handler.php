<?php

// Encode data using base64 URL-safe format (for JWT parts)
function base64UrlEncode($text) {
    return rtrim(strtr(base64_encode($text), '+/', '-_'), '=');
}
function base64UrlDecode($input) {
    $remainder = strlen($input) % 4;
    if ($remainder) {
        $input .= str_repeat('=', 4 - $remainder);
    }
    return base64_decode(strtr($input, '-_', '+/'));
}

function decode_jwt($token) {
    $parts = explode('.', $token);
    if (count($parts) !== 3) return null;

    $payload = $parts[1];
    $decoded = base64_decode(strtr($payload, '-_', '+/'));
    return json_decode($decoded, true); // returns associative array
}


// Create a JWT containing user ID, role ID, and email
function createJWT($user_id, $role_id, $email) {
    // Define the JWT header
    $header = base64UrlEncode(json_encode(['alg' => 'HS256', 'typ' => 'JWT']));
    // Define the payload with issuer, issue time, expiration, and user data
    $payload = base64UrlEncode(json_encode([
        'iss' => 'PRS',
        'iat' => time(),
        'exp' => time() + 3600,
        'data' => [
            'id' => $user_id,
            'role_id' => $role_id,
            'email' => $email
        ]
    ]));

// Define a secret key
    $secret = '$p4nd3micResilience';
    $signature = base64UrlEncode(hash_hmac('sha256', "$header.$payload", $secret, true));
    // Return the final JWT token
    return "$header.$payload.$signature";
}
// Validate a given JWT token
function validateJWT($jwt) {
    $secret = '$p4nd3micResilience';

    // Split the JWT into header, payload, and signature
    $parts = explode('.', $jwt);
    if (count($parts) !== 3) return false;

    [$header, $payload, $signature] = $parts;

    // Recreate the signature and compare it with the one in the token
    $valid_signature = base64UrlEncode(hash_hmac('sha256', "$header.$payload", $secret, true));

    if (!hash_equals($valid_signature, $signature)) return false;
    
// Decode the payload and check for expiration
    $data = json_decode(base64UrlDecode($payload), true);
    return isset($data['exp']) && $data['exp'] > time();
}

?>

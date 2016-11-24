<?php
// Correr en modo de desarrollo con el comando: php -S 0.0.0.0:8000

$notifications = array();
for ($i = 1; $i < 10; $i++) {
  $notifications[] = array('id' => $i, 'message' => 'Este es el aviso con ID ' . $i);
}

// Descomentar una por una al hacer pruebas de app...
//$notifications[] = array('id' => 10, 'message' => 'Este es el aviso con ID 10');
//$notifications[] = array('id' => 11, 'message' => 'Este es otro aviso con ID 11');

$success = true;
$data = array(
  'notifications' => $notifications,
  'success' => $success
);
header('Content-Type: application/json');
echo json_encode($data);

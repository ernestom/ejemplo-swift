<?php
// Correr en modo de desarrollo con el comando: php -S 0.0.0.0:8000
$notifications = array();
$lipsum = 'Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation      ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in          voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non          proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor   tum poen legum odioque civiuda.';
for ($i = 1; $i < 10; $i++) {
    $notifications[] = array(
        'id' => "N$i",
        'title' => 'Este es el aviso con ID N' . $i,
        'message' => $lipsum
    );
}

//$notifications[] = array('id' => 'N10', 'title' => 'Este es el aviso con ID 10', 'message' => 'Nueva notificación!!! ' . $lipsum);
//$notifications[] = array('id' => 'N11', 'title' => 'Este es otro aviso con ID 11', 'message' => 'Otra más!!! ' . $lipsum);

$success = true;
$data = array(
  'notifications' => $notifications,
  'success' => $success
);
header('Content-Type: application/json');
echo json_encode($data);

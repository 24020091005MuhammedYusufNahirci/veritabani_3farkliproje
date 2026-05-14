<?php
require_once 'baglanti.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id > 0) {
    // Filmi veritabanından sil
    $sorgu = $db->prepare("DELETE FROM Filmler WHERE ID = :id");
    $sorgu->execute(['id' => $id]);
}

// İşlem bitince yönetim sayfasına geri dön
header("Location: yonetim.php");
exit;
?>
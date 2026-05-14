<?php
$host = 'localhost';
$dbname = 'mini_imdb';
$username = 'root'; 
$password = 'yusuf';      

try {
    // PDO nesnesini oluşturma ve UTF-8 karakter setini ayarlama
    $db = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    
    // Hata modunu Exception olarak ayarlama
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
} catch(PDOException $e) {
    echo "Veritabanı bağlantı hatası: " . $e->getMessage();
    exit;
}
?>
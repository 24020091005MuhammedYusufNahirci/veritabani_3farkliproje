<?php
require_once 'baglanti.php';

$id = isset($_GET['id']) ? (int)$_GET['id'] : 0;

if ($id === 0) {
    die("Geçersiz ID.");
}

// Form gönderildiyse (POST işlemi) veritabanını güncelle
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $filmAdi = $_POST['filmAdi'];
    $yayinYili = (int)$_POST['yayinYili'];
    $ozet = $_POST['ozet'];
    $poster = $_POST['poster']; // Formdan gelen yeni poster linki

    // UPDATE sorgusuna Poster alanını da ekledik
    $guncelleSorgu = $db->prepare("UPDATE Filmler SET FilmAdi = :adi, YayinYili = :yil, Ozet = :ozet, Poster = :poster WHERE ID = :id");
    $guncelleSorgu->execute([
        'adi' => $filmAdi,
        'yil' => $yayinYili,
        'ozet' => $ozet,
        'poster' => $poster,
        'id' => $id
    ]);

    // Güncelleme sonrası yönetim sayfasına yönlendir
    header("Location: yonetim.php");
    exit;
}

// Sayfa ilk açıldığında filmin mevcut bilgilerini çek
$sorgu = $db->prepare("SELECT * FROM Filmler WHERE ID = :id");
$sorgu->execute(['id' => $id]);
$film = $sorgu->fetch(PDO::FETCH_ASSOC);

if (!$film) {
    die("Film bulunamadı.");
}
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Film Düzenle</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .form-grup { margin-bottom: 15px; }
        .form-grup label { display: block; font-weight: bold; margin-bottom: 5px; color: #bdc3c7; }
        .form-grup input, .form-grup textarea { width: 100%; padding: 10px; border: 1px solid #4a535e; border-radius: 4px; background-color: #f9f9f9; color: #333; font-size: 1rem; }
        .btn-kaydet { background-color: #2ecc71; color: white; padding: 10px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; margin-top: 10px; }
        .btn-kaydet:hover { background-color: #27ae60; }
    </style>
</head>
<body>
    <div class="container">
        <a href="yonetim.php" style="color: #3498db; text-decoration: none;">← İptal ve Geri Dön</a>
        <br><br>
        <h1>Film Düzenle: <?= htmlspecialchars($film['FilmAdi']) ?></h1>
        
        <form method="POST" action="">
            <div class="form-grup">
                <label>Film Adı:</label>
                <input type="text" name="filmAdi" value="<?= htmlspecialchars($film['FilmAdi']) ?>" required>
            </div>
            
            <div class="form-grup">
                <label>Yayın Yılı:</label>
                <input type="number" name="yayinYili" value="<?= htmlspecialchars($film['YayinYili']) ?>" required>
            </div>
            
            <div class="form-grup">
                <label>Poster Linki (URL):</label>
                <input type="text" name="poster" value="<?= htmlspecialchars($film['Poster'] ?? '') ?>" required>
            </div>
            
            <div class="form-grup">
                <label>Özet:</label>
                <textarea name="ozet" rows="5" required><?= htmlspecialchars($film['Ozet']) ?></textarea>
            </div>
            
            <button type="submit" class="btn-kaydet">Değişiklikleri Kaydet</button>
        </form>
    </div>
</body>
</html>
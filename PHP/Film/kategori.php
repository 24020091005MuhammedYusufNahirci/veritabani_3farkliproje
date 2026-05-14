<?php
require_once 'baglanti.php';

$genreId = isset($_GET['genreId']) ? (int)$_GET['genreId'] : 0;

if ($genreId === 0) {
    die("Geçersiz tür ID.");
}

// 1. Türün Adını Çekme (Başlıkta göstermek için)
$turSorgu = $db->prepare("SELECT TurAdi FROM Turler WHERE ID = :id");
$turSorgu->execute(['id' => $genreId]);
$tur = $turSorgu->fetch(PDO::FETCH_ASSOC);

if (!$tur) {
    die("Film türü bulunamadı.");
}

// 2. Bu Türe Ait Filmleri Çekme (Poster alanını buraya ekledik)
$filmSorgu = $db->prepare("
    SELECT ID, FilmAdi, YayinYili, Ozet, Poster 
    FROM Filmler 
    WHERE TurID = :tur_id
    ORDER BY YayinYili DESC
");
$filmSorgu->execute(['tur_id' => $genreId]);
$filmler = $filmSorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($tur['TurAdi']) ?> Filmleri</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <a href="index.php" style="color: #3498db; text-decoration: none;">← Ana Sayfaya Dön</a>
        <br><br>
        
        <h1><?= htmlspecialchars($tur['TurAdi']) ?> Filmleri</h1>
        
        <div class="film-listesi">
            <?php if(count($filmler) > 0): ?>
                <?php foreach($filmler as $film): ?>
                    <div class="film-karti">
                        <img src="<?= htmlspecialchars($film['Poster'] ?? 'varsayilan.jpg') ?>" alt="<?= htmlspecialchars($film['FilmAdi']) ?> Posteri">
                        
                        <h3><?= htmlspecialchars($film['FilmAdi']) ?> (<?= htmlspecialchars($film['YayinYili']) ?>)</h3>
                        <p><?= htmlspecialchars(substr($film['Ozet'], 0, 150)) ?>...</p>
                        <a href="detay.php?movieId=<?= $film['ID'] ?>">Detayları Gör</a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>Bu türe ait henüz bir film eklenmemiş.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
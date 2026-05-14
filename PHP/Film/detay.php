<?php
require_once 'baglanti.php';

$movieId = isset($_GET['movieId']) ? (int)$_GET['movieId'] : 0;

if ($movieId === 0) {
    die("Geçersiz film ID.");
}

// f.Poster alanını sorguya ekledik
$filmSorgu = $db->prepare("
    SELECT f.FilmAdi, f.YayinYili, f.Ozet, f.Poster, t.TurAdi, y.AdSoyad AS YonetmenAdi 
    FROM Filmler f
    LEFT JOIN Turler t ON f.TurID = t.ID
    LEFT JOIN Yonetmenler y ON f.YonetmenID = y.ID
    WHERE f.ID = :id
");
$filmSorgu->execute(['id' => $movieId]);
$film = $filmSorgu->fetch(PDO::FETCH_ASSOC);

if (!$film) {
    die("Film bulunamadı.");
}

$oyuncuSorgu = $db->prepare("
    SELECT o.ID, o.OyuncuAdi, fo.RolAdi 
    FROM Film_Oyunculari fo
    INNER JOIN Oyuncular o ON fo.OyuncuID = o.ID
    WHERE fo.FilmID = :film_id
");
$oyuncuSorgu->execute(['film_id' => $movieId]);
$oyuncular = $oyuncuSorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($film['FilmAdi']) ?> - Detay</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <a href="index.php">← Ana Sayfaya Dön</a>
        <br><br>
        
        <div class="detay-karti detay-icerik">
            <img src="<?= htmlspecialchars($film['Poster']) ?>" alt="Poster" class="detay-poster">
            
            <div style="overflow: hidden;">
                <h1><?= htmlspecialchars($film['FilmAdi']) ?> (<?= htmlspecialchars($film['YayinYili']) ?>)</h1>
                <p><span class="badge"><?= htmlspecialchars($film['TurAdi'] ?? 'Tür Belirtilmemiş') ?></span></p>
                <br>
                <p><strong>Yönetmen:</strong> <?= htmlspecialchars($film['YonetmenAdi'] ?? 'Bilinmiyor') ?></p>
                <p><strong>Özet:</strong> <?= nl2br(htmlspecialchars($film['Ozet'])) ?></p>
                
                <hr style="margin: 20px 0; border-color: #4a535e;">
                
                <h3>Oyuncu Kadrosu</h3>
                <?php if (count($oyuncular) > 0): ?>
                    <ul class="oyuncu-listesi">
                        <?php foreach ($oyuncular as $oyuncu): ?>
                            <li>
                                <a href="oyuncu.php?actorId=<?= $oyuncu['ID'] ?>">
                                    <strong><?= htmlspecialchars($oyuncu['OyuncuAdi']) ?></strong>
                                </a> 
                                - <em><?= htmlspecialchars($oyuncu['RolAdi']) ?></em>
                            </li>
                        <?php endforeach; ?>
                    </ul>
                <?php else: ?>
                    <p>Bu filme henüz oyuncu eklenmemiş.</p>
                <?php endif; ?>
            </div>
        </div>
    </div>
</body>
</html>
<?php
require_once 'baglanti.php';

$actorId = isset($_GET['actorId']) ? (int)$_GET['actorId'] : 0;

if ($actorId === 0) {
    die("Geçersiz oyuncu ID.");
}

// 1. Oyuncu Bilgilerini Çekme
$oyuncuSorgu = $db->prepare("SELECT * FROM Oyuncular WHERE ID = :id");
$oyuncuSorgu->execute(['id' => $actorId]);
$oyuncu = $oyuncuSorgu->fetch(PDO::FETCH_ASSOC);

if (!$oyuncu) {
    die("Oyuncu bulunamadı.");
}

// 2. Oyuncunun Oynadığı Filmleri Çekme
$filmSorgu = $db->prepare("
    SELECT f.ID, f.FilmAdi, f.YayinYili, fo.RolAdi 
    FROM Film_Oyunculari fo
    INNER JOIN Filmler f ON fo.FilmID = f.ID
    WHERE fo.OyuncuID = :oyuncu_id
    ORDER BY f.YayinYili DESC
");
$filmSorgu->execute(['oyuncu_id' => $actorId]);
$filmler = $filmSorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title><?= htmlspecialchars($oyuncu['OyuncuAdi']) ?> - Profil</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <a href="javascript:history.back()" style="color: #3498db; text-decoration: none;">← Geri Dön</a>
        <br><br>
        
        <div class="detay-karti">
            <h1 style="font-size: 2.5rem; margin-bottom: 5px;"><?= htmlspecialchars($oyuncu['OyuncuAdi']) ?></h1>
            <p><span class="badge" style="background: #34495e;">Doğum Tarihi: <?= htmlspecialchars($oyuncu['DogumTarihi'] ?? 'Bilinmiyor') ?></span></p>
            <br>
            
            <p style="color: #ecf0f1; font-size: 1.05rem; line-height: 1.8;">
                <strong>Biyografi:</strong><br> 
                <?= nl2br(htmlspecialchars($oyuncu['Biyografi'] ?? 'Biyografi eklenmemiş.')) ?>
            </p>
            
            <hr style="margin: 30px 0; border-color: #4a535e;">
            
            <h3 style="color: #f1c40f;">Oynadığı Filmler (Mini IMDb Kayıtları)</h3>
            <?php if (count($filmler) > 0): ?>
                <ul class="oyuncu-listesi">
                    <?php foreach ($filmler as $film): ?>
                        <li>
                            <a href="detay.php?movieId=<?= $film['ID'] ?>" style="color: #3498db; font-size: 1.1rem;">
                                <strong><?= htmlspecialchars($film['FilmAdi']) ?> (<?= htmlspecialchars($film['YayinYili']) ?>)</strong>
                            </a> 
                            <span style="color: #bdc3c7;"> — Rol: <em><?= htmlspecialchars($film['RolAdi']) ?></em></span>
                        </li>
                    <?php endforeach; ?>
                </ul>
            <?php else: ?>
                <p style="color: #bdc3c7;">Bu oyuncunun sistemimizde kayıtlı filmi bulunmamaktadır.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
<?php
require_once 'baglanti.php';

// 1. Türleri (Kategorileri) üst menü için çekiyoruz
$turSorgu = $db->query("SELECT * FROM Turler ORDER BY TurAdi ASC");
$turler = $turSorgu->fetchAll(PDO::FETCH_ASSOC);

// 2. Filmleri posterleriyle birlikte çekiyoruz
$sorgu = $db->prepare("
    SELECT Filmler.ID, Filmler.FilmAdi, Filmler.YayinYili, Filmler.Ozet, Filmler.Poster, Turler.TurAdi 
    FROM Filmler 
    LEFT JOIN Turler ON Filmler.TurID = Turler.ID
    ORDER BY Filmler.YayinYili DESC
");
$sorgu->execute();
$filmler = $sorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Mini IMDb - Film Vitrini</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        
        <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #2f3640; padding-bottom: 15px; margin-bottom: 20px;">
            <div>
                <a href="oyuncular.php" style="margin-right: 20px; color: #fff; font-weight: bold; text-decoration: none; border-right: 1px solid #4a535e; padding-right: 20px;">🎭 Tüm Oyuncular</a>
                
                <strong style="color: #f1c40f; margin-right: 10px;">Kategoriler:</strong>
                <?php foreach($turler as $tur): ?>
                    <a href="kategori.php?genreId=<?= $tur['ID'] ?>" style="margin-right: 15px; color: #bdc3c7; text-decoration: none;"><?= htmlspecialchars($tur['TurAdi']) ?></a>
                <?php endforeach; ?>
            </div>
            <div>
                <a href="yonetim.php" class="btn-duzenle" style="text-decoration: none;">⚙️ Film Yönetimi</a>
            </div>
        </div>
        <h1>Vizyondaki Filmler (Mini IMDb)</h1>
        
        <div class="film-listesi">
            <?php if(count($filmler) > 0): ?>
                <?php foreach($filmler as $film): ?>
                    <div class="film-karti">
                        <img src="<?= htmlspecialchars($film['Poster'] ?? 'varsayilan.jpg') ?>" alt="<?= htmlspecialchars($film['FilmAdi']) ?> Posteri">
                        
                        <h3><?= htmlspecialchars($film['FilmAdi']) ?> (<?= htmlspecialchars($film['YayinYili']) ?>)</h3>
                        <p><strong>Tür:</strong> <?= htmlspecialchars($film['TurAdi'] ?? 'Belirtilmemiş') ?></p>
                        <p><?= htmlspecialchars(substr($film['Ozet'], 0, 100)) ?>...</p>
                        <a href="detay.php?movieId=<?= $film['ID'] ?>">Detayları Gör</a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>Sistemde henüz film bulunmamaktadır.</p>
            <?php endif; ?>
        </div>
        
    </div>
</body>
</html>
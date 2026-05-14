<?php
require_once 'baglanti.php';

// Tüm oyuncuları alfabetik sırayla çekiyoruz
$sorgu = $db->query("SELECT ID, OyuncuAdi, DogumTarihi FROM Oyuncular ORDER BY OyuncuAdi ASC");
$oyuncular = $sorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Tüm Oyuncular - Mini IMDb</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .oyuncu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .oyuncu-karti-mini {
            background: #2f3640;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #f1c40f;
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
            transition: transform 0.2s ease;
        }
        .oyuncu-karti-mini:hover {
            transform: translateY(-3px);
        }
        .oyuncu-karti-mini h3 { margin-bottom: 5px; color: #fff; font-size: 1.1rem; }
        .oyuncu-karti-mini p { color: #bdc3c7; font-size: 0.9rem; margin-bottom: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <a href="index.php" style="color: #3498db; text-decoration: none;">← Ana Sayfaya Dön</a>
        <br><br>
        
        <h1>🎭 Tüm Oyuncular</h1>
        
        <div class="oyuncu-grid">
            <?php if(count($oyuncular) > 0): ?>
                <?php foreach($oyuncular as $oyuncu): ?>
                    <div class="oyuncu-karti-mini">
                        <h3><?= htmlspecialchars($oyuncu['OyuncuAdi']) ?></h3>
                        <p><strong>Doğum:</strong> <?= htmlspecialchars($oyuncu['DogumTarihi'] ?? 'Bilinmiyor') ?></p>
                        <a href="oyuncu.php?actorId=<?= $oyuncu['ID'] ?>" style="display: inline-block; background: #f1c40f; color: #14181c; padding: 5px 10px; border-radius: 4px; font-size: 0.9rem; font-weight: bold;">Profili İncele</a>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <p>Sistemde henüz kayıtlı oyuncu bulunmamaktadır.</p>
            <?php endif; ?>
        </div>
    </div>
</body>
</html>
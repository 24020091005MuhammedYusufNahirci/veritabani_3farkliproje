<?php
require_once 'baglanti.php';

// Tüm filmleri çekelim
$sorgu = $db->prepare("SELECT ID, FilmAdi, YayinYili FROM Filmler ORDER BY ID DESC");
$sorgu->execute();
$filmler = $sorgu->fetchAll(PDO::FETCH_ASSOC);
?>

<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Film Yönetimi</title>
    <link rel="stylesheet" href="style.css">
    <style>
        /* Tabloyu koyu temaya uygun hale getirdik */
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background-color: #2f3640; border-radius: 8px; overflow: hidden; }
        th, td { border: 1px solid #4a535e; padding: 15px; text-align: left; }
        th { background-color: #1a2228; color: #f1c40f; font-weight: 600; }
        td { color: #ecf0f1; }
        
        .btn-sil { color: white; background-color: #e74c3c; padding: 8px 12px; border-radius: 4px; text-decoration: none; font-weight: bold; transition: 0.3s; }
        .btn-sil:hover { background-color: #c0392b; }
        .btn-duzenle { color: #14181c; background-color: #3498db; padding: 8px 12px; border-radius: 4px; text-decoration: none; font-weight: bold; margin-right: 5px; transition: 0.3s; }
        .btn-duzenle:hover { background-color: #2980b9; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <a href="index.php" style="color: #3498db; text-decoration: none;">← Ana Sayfaya Dön</a>
        <br><br>
        <h1>Film Yönetim Paneli</h1>
        
        <table>
            <thead>
                <tr>
                    <th>Film Adı</th>
                    <th>Yayın Yılı</th>
                    <th>İşlemler</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($filmler as $film): ?>
                <tr>
                    <td><?= htmlspecialchars($film['FilmAdi']) ?></td>
                    <td><?= htmlspecialchars($film['YayinYili']) ?></td>
                    <td>
                        <a href="duzenle.php?id=<?= $film['ID'] ?>" class="btn-duzenle">Düzenle</a>
                        <a href="sil.php?id=<?= $film['ID'] ?>" class="btn-sil" onclick="return confirm('Bu filmi silmek istediğinize emin misiniz?');">Sil</a>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>
</body>
</html>
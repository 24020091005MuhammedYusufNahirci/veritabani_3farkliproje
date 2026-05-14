<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="baglanti.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Şehir Rehberi ve Gezi Rotası</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Ubuntu', sans-serif; }
        body { background-color: #0f172a; color: #f8fafc; line-height: 1.6; padding: 40px 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
        h1, h2 { color: #2dd4bf; margin-bottom: 20px; }
        a { color: #38bdf8; text-decoration: none; transition: color 0.2s ease; }
        a:hover { color: #2dd4bf; }
        .nav-bar { display: flex; justify-content: space-between; align-items: center; background: #0f172a; padding: 15px 20px; border-radius: 8px; margin-bottom: 30px; }
        .search-form { display: flex; gap: 10px; align-items: center; }
        .search-form select, .search-form input[type="text"] { padding: 8px 12px; background: #1e293b; border: 1px solid #475569; color: #fff; border-radius: 6px; }
        .grid-listesi { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .kart { background: #334155; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-top: 4px solid #2dd4bf; }
        .btn { display: inline-block; background: #2dd4bf; color: #0f172a; padding: 8px 16px; border-radius: 6px; font-weight: bold; border: none; cursor: pointer; text-align: center; text-decoration: none !important; }
        .btn:hover { background: #14b8a6; }
    </style>
</head>
<body>
    <div class="container">
        <div class="nav-bar">
            <h2>🌍 Şehir Gezi Rehberi</h2>
            <form action="arama.jsp" method="GET" class="search-form">
                <input type="text" name="bolge" placeholder="Bölgeye göre ara...">
                <select name="tur">
                    <option value="">Mekan Türü Seçin</option>
                    <option value="Müze">Müze</option>
                    <option value="Park">Park</option>
                    <option value="Restoran">Restoran</option>
                </select>
                <button type="submit" class="btn">Filtrele</button>
                <a href="mekanEkle.jsp" class="btn" style="background: #0ea5e9; color: white;">+ Yeni Mekan Ekle</a>
            </form>
        </div>

        <h1>Keşfedilmeyi Bekleyen Şehirler</h1>
        <div class="grid-listesi">
            <%
                if (conn != null) {
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery("SELECT * FROM Sehirler ORDER BY SehirAdi ASC");
                    while (rs.next()) {
            %>
                        <div class="kart">
                            <h3><%= rs.getString("SehirAdi") %></h3>
                            <p style="color: #94a3b8; margin-bottom: 10px;">📍 Bölge: <%= rs.getString("Bolge") %></p>
                            <p style="margin-bottom: 15px;">👥 Nüfus: <%= String.format("%,d", rs.getInt("Nufus")) %></p>
                            <a href="sehirDetay.jsp?cityId=<%= rs.getInt("ID") %>" class="btn">Şehri Keşfet →</a>
                        </div>
            <%
                    }
                    rs.close();
                    stmt.close();
                    conn.close();
                }
            %>
        </div>
    </div>
</body>
</html>
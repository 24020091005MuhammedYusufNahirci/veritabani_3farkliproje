<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="baglanti.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Yeni Mekan Ekle</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Ubuntu', sans-serif; }
        body { background-color: #0f172a; color: #f8fafc; line-height: 1.6; padding: 40px 20px; }
        .container { max-width: 700px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
        h1 { color: #2dd4bf; margin-bottom: 20px; }
        .form-grup { margin-bottom: 20px; }
        .form-grup label { display: block; margin-bottom: 8px; color: #94a3b8; font-weight: 500; }
        .form-grup input, .form-grup textarea, .form-grup select { width: 100%; padding: 12px; background: #334155; border: 1px solid #475569; color: white; border-radius: 6px; font-size: 1rem; }
        .form-grup input:focus, .form-grup textarea:focus, .form-grup select:focus { border-color: #2dd4bf; outline: none; }
        .btn { display: block; width: 100%; background: #2dd4bf; color: #0f172a; padding: 12px; border-radius: 6px; font-weight: bold; border: none; cursor: pointer; font-size: 1rem; }
        .btn:hover { background: #14b8a6; }
        a { color: #38bdf8; text-decoration: none; }
    </style>
</head>
<body>
    <div class="container">
        <%
            // Eğer sehirDetay'dan gelindiyse parametreyi yakala
            String cityIdParam = request.getParameter("cityId");
            int urlCityId = 0;
            if (cityIdParam != null && !cityIdParam.isEmpty()) {
                urlCityId = Integer.parseInt(cityIdParam);
            }
            
            if ("POST".equalsIgnoreCase(request.getMethod())) {
                request.setCharacterEncoding("UTF-8");
                int secilenSehirId = Integer.parseInt(request.getParameter("sehirId"));
                String mekanAdi = request.getParameter("mekanAdi");
                String tur = request.getParameter("tur");
                String aciklama = request.getParameter("aciklama");

                if (conn != null) {
                    PreparedStatement psEkle = conn.prepareStatement(
                        "INSERT INTO Mekanlar (SehirID, MekanAdi, Aciklama, Tur) VALUES (?, ?, ?, ?)"
                    );
                    psEkle.setInt(1, secilenSehirId);
                    psEkle.setString(2, mekanAdi);
                    psEkle.setString(3, aciklama);
                    psEkle.setString(4, tur);
                    psEkle.executeUpdate();
                    psEkle.close();
                    conn.close();
                    
                    // Eklenen mekanın ait olduğu şehrin detay sayfasına yönlendir
                    response.sendRedirect("sehirDetay.jsp?cityId=" + secilenSehirId);
                    return;
                }
            }
        %>

        <a href="index.jsp">← İptal Et ve Ana Sayfaya Dön</a>
        <br><br>
        <h1>Yeni Gezi Mekanı Ekle</h1>

        <form action="" method="POST">
            <div class="form-grup">
                <label>Bağlı Olduğu Şehir:</label>
                <select name="sehirId" required>
                    <%
                        if (conn != null && !conn.isClosed()) {
                            Statement stmtSehir = conn.createStatement();
                            ResultSet rsSehir = stmtSehir.executeQuery("SELECT * FROM Sehirler ORDER BY SehirAdi ASC");
                            while(rsSehir.next()) {
                                int sId = rsSehir.getInt("ID");
                                // URL'den gelen id ile eşleşiyorsa otomatik seç
                                String selected = (sId == urlCityId) ? "selected" : "";
                    %>
                                <option value="<%= sId %>" <%= selected %>><%= rsSehir.getString("SehirAdi") %></option>
                    <%
                            }
                            rsSehir.close();
                            stmtSehir.close();
                        }
                    %>
                </select>
            </div>
            
            <div class="form-grup">
                <label>Mekan Adı:</label>
                <input type="text" name="mekanAdi" required>
            </div>
            <div class="form-grup">
                <label>Mekan Türü:</label>
                <select name="tur" required>
                    <option value="Müze">Müze</option>
                    <option value="Park">Park</option>
                    <option value="Restoran">Restoran</option>
                </select>
            </div>
            <div class="form-grup">
                <label>Açıklama / Gezi Notları:</label>
                <textarea name="aciklama" rows="5" required></textarea>
            </div>
            <button type="submit" class="btn">Mekanı Kaydet</button>
        </form>
    </div>
</body>
</html>
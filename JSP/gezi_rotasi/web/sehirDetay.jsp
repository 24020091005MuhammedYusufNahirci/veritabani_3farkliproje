<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="baglanti.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Şehir Detayları</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Ubuntu', sans-serif; }
        body { background-color: #0f172a; color: #f8fafc; line-height: 1.6; padding: 40px 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
        h1, h2 { color: #2dd4bf; margin-top: 20px; margin-bottom: 20px; }
        a { color: #38bdf8; text-decoration: none; }
        a:hover { color: #2dd4bf; text-decoration: underline; }
        .grid-listesi { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .kart { padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); background: #334155; border-top: 4px solid #38bdf8; }
        .badge { background: #0ea5e9; color: white; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: bold; display: inline-block; margin-bottom: 10px; }
        .btn { display: inline-block; background: #2dd4bf; color: #0f172a; padding: 10px 20px; border-radius: 6px; font-weight: bold; text-decoration: none !important; }
        .btn:hover { background: #14b8a6; }
    </style>
</head>
<body>
    <div class="container">
        <a href="index.jsp">← Ana Sayfaya Dön</a>
        <br><br>

        <%
            int cityId = Integer.parseInt(request.getParameter("cityId"));
            String sehirAdi = "";
            
            if (conn != null) {
                PreparedStatement psSehir = conn.prepareStatement("SELECT SehirAdi FROM Sehirler WHERE ID = ?");
                psSehir.setInt(1, cityId);
                ResultSet rsSehir = psSehir.executeQuery();
                if (rsSehir.next()) { sehirAdi = rsSehir.getString("SehirAdi"); }
                rsSehir.close();
                psSehir.close();
        %>
                <h1>📌 <%= sehirAdi %> Gezi Rotası</h1>
                <div style="margin-bottom: 30px;">
                    <a href="mekanEkle.jsp?cityId=<%= cityId %>" class="btn">+ Yeni Mekan Ekle</a>
                </div>

                <h2>🏛️ Görülmesi Gereken Mekanlar</h2>
                <div class="grid-listesi" style="margin-bottom: 40px;">
                    <%
                        PreparedStatement psMekan = conn.prepareStatement("SELECT * FROM Mekanlar WHERE SehirID = ?");
                        psMekan.setInt(1, cityId);
                        ResultSet rsMekan = psMekan.executeQuery();
                        boolean mekanVarMi = false;
                        while (rsMekan.next()) {
                            mekanVarMi = true;
                    %>
                            <div class="kart">
                                <h3><%= rsMekan.getString("MekanAdi") %></h3>
                                <span class="badge"><?= rsMekan.getString("Tur") ?></span>
                                <p style="margin-bottom: 15px; font-size: 0.9rem; color: #cbd5e1;"><%= rsMekan.getString("Aciklama") %></p>
                                <a href="mekanDetay.jsp?placeId=<%= rsMekan.getInt("ID") %>" style="font-weight:bold;">Detaylar ve Etkinlikler →</a>
                            </div>
                    <%
                        }
                        if(!mekanVarMi) { out.print("<p style='color:#94a3b8;'>Bu şehre ait henüz bir mekan eklenmemiş.</p>"); }
                        rsMekan.close();
                        psMekan.close();
                    %>
                </div>

                <h2>📋 Şehirde Görevli Uzman Rehberler</h2>
                <div class="grid-listesi">
                    <%
                        PreparedStatement psRehber = conn.prepareStatement(
                            "SELECT r.* FROM Rehberler r " +
                            "JOIN Sehir_Rehber_Eslesme e ON r.ID = e.RehberID " +
                            "WHERE e.SehirID = ?"
                        );
                        psRehber.setInt(1, cityId);
                        ResultSet rsRehber = psRehber.executeQuery();
                        boolean rehberVarMi = false;
                        while (rsRehber.next()) {
                            rehberVarMi = true;
                    %>
                            <div class="kart" style="border-top-color: #a855f7;">
                                <h3>👤 <%= rsRehber.getString("RehberAdi") %></h3>
                                <p style="margin-top: 5px;"><strong>🎯 Uzmanlık:</strong> <%= rsRehber.getString("UzmanlikAlani") %></p>
                                <p><strong>📞 İletişim:</strong> <%= rsRehber.getString("Iletisim") %></p>
                            </div>
                    <%
                        }
                        if(!rehberVarMi) { out.print("<p style='color:#94a3b8;'>Bu şehirde kayıtlı aktif rehber bulunmamaktadır.</p>"); }
                        rsRehber.close();
                        psRehber.close();
                    }
                    if(conn != null) conn.close();
                    %>
                </div>
    </div>
</body>
</html>
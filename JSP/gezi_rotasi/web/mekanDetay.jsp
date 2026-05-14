<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="baglanti.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mekan Detayı</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Ubuntu', sans-serif; }
        body { background-color: #0f172a; color: #f8fafc; line-height: 1.6; padding: 40px 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
        h1, h2 { color: #2dd4bf; margin-bottom: 20px; }
        .badge { background: #0ea5e9; color: white; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: bold; }
        .grid-listesi { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .kart { padding: 20px; border-radius: 8px; background: #334155; border-top: 4px solid #f59e0b; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        a { color: #38bdf8; text-decoration: none; }
        a:hover { color: #2dd4bf; }
    </style>
</head>
<body>
    <div class="container">
        <a href="javascript:history.back()">← Geri Dön</a>
        <br><br>

        <%
            int placeId = Integer.parseInt(request.getParameter("placeId"));
            if (conn != null) {
                PreparedStatement psMekan = conn.prepareStatement(
                    "SELECT m.*, s.SehirAdi FROM Mekanlar m " +
                    "JOIN Sehirler s ON m.SehirID = s.ID WHERE m.ID = ?"
                );
                psMekan.setInt(1, placeId);
                ResultSet rsMekan = psMekan.executeQuery();
                if (rsMekan.next()) {
        %>
                    <div style="background: #334155; padding: 30px; border-radius: 8px; margin-bottom: 30px; border-left: 5px solid #2dd4bf;">
                        <h1>🏛️ <%= rsMekan.getString("MekanAdi") %></h1>
                        <p style="margin-bottom: 15px;"><span class="badge"><%= rsMekan.getString("Tur") %></span> — <strong>Konum:</strong> <%= rsMekan.getString("SehirAdi") %></p>
                        <p style="font-size: 1.1rem; color: #e2e8f0;"><%= rsMekan.getString("Aciklama") %></p>
                    </div>

                    <h2>📅 Planlanan Etkinlikler</h2>
                    <div class="grid-listesi">
                        <%
                            PreparedStatement psEtkinlik = conn.prepareStatement("SELECT * FROM Etkinlikler WHERE MekanID = ?");
                            psEtkinlik.setInt(1, placeId);
                            ResultSet rsEtkinlik = psEtkinlik.executeQuery();
                            boolean etkinlikVarMi = false;
                            while (rsEtkinlik.next()) {
                                etkinlikVarMi = true;
                        %>
                                <div class="kart">
                                    <h3 style="color:#fff; margin-bottom:10px;">🎉 <%= rsEtkinlik.getString("EtkinlikAdi") %></h3>
                                    <p><strong>🗓️ Tarih:</strong> <%= rsEtkinlik.getDate("Tarih") %></p>
                                    <p style="color:#f59e0b; font-weight:bold; margin-top:5px;">💰 Ücret: <%= rsEtkinlik.getDouble("Ucret") == 0 ? "Ücretsiz" : rsEtkinlik.getDouble("Ucret") + " TL" %></p>
                                </div>
                        <%
                            }
                            if(!etkinlikVarMi) { out.print("<p style='color:#94a3b8;'>Bu mekanda planlanmış bir etkinlik bulunmuyor.</p>"); }
                            rsEtkinlik.close();
                            psEtkinlik.close();
                        %>
                    </div>
        <%
                }
                rsMekan.close();
                psMekan.close();
            }
            if(conn != null) conn.close();
        %>
    </div>
</body>
</html>
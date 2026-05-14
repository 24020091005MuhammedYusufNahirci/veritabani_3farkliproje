<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="baglanti.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Arama Sonuçları</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Ubuntu:wght@300;400;500;700&display=swap');
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Ubuntu', sans-serif; }
        body { background-color: #0f172a; color: #f8fafc; line-height: 1.6; padding: 40px 20px; }
        .container { max-width: 1100px; margin: 0 auto; background: #1e293b; padding: 30px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.4); }
        h1 { color: #2dd4bf; margin-bottom: 20px; }
        .grid-listesi { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .kart { background: #334155; padding: 20px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-top: 4px solid #2dd4bf; }
        .badge { background: #0ea5e9; color: white; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; font-weight: bold; }
        a { color: #38bdf8; text-decoration: none; }
        a:hover { color: #2dd4bf; }
    </style>
</head>
<body>
    <div class="container">
        <a href="index.jsp">← Ana Sayfaya Dön</a>
        <br><br>
        <h1>🔍 Arama Sonuçları</h1>
        <br>

        <div class="grid-listesi">
            <%
                String bolge = request.getParameter("bolge");
                String tur = request.getParameter("tur");

                if (conn != null) {
                    ResultSet rs = null;
                    PreparedStatement ps = null;

                    if (bolge != null && !bolge.trim().isEmpty() && (tur == null || tur.trim().isEmpty())) {
                        ps = conn.prepareStatement("SELECT * FROM Sehirler WHERE Bolge ILIKE ?");
                        ps.setString(1, "%" + bolge + "%");
                        rs = ps.executeQuery();
                        while(rs.next()) {
            %>
                            <div class="kart">
                                <h3>🌆 <%= rs.getString("SehirAdi") %></h3>
                                <p style="color: #94a3b8; margin: 5px 0;">📍 Bölge: <%= rs.getString("Bolge") %></p>
                                <a href="sehirDetay.jsp?cityId=<%= rs.getInt("ID") %>" style="margin-top:10px; display:inline-block; font-weight:bold;">Şehre Git →</a>
                            </div>
            <%
                        }
                    } 
                    else if (tur != null && !tur.trim().isEmpty()) {
                        String sql = "SELECT m.*, s.SehirAdi FROM Mekanlar m JOIN Sehirler s ON m.SehirID = s.ID WHERE m.Tur = ?";
                        if (bolge != null && !bolge.trim().isEmpty()) {
                            sql += " AND s.Bolge ILIKE ?";
                        }
                        ps = conn.prepareStatement(sql);
                        ps.setString(1, tur);
                        if (bolge != null && !bolge.trim().isEmpty()) {
                            ps.setString(2, "%" + bolge + "%");
                        }
                        
                        rs = ps.executeQuery();
                        boolean sonucVarMi = false;
                        while(rs.next()) {
                            sonucVarMi = true;
            %>
                            <div class="kart" style="border-top-color: #38bdf8;">
                                <h3>🏛️ <%= rs.getString("MekanAdi") %></h3>
                                <p style="margin: 8px 0;"><span class="badge"><%= rs.getString("Tur") %></span> — 🌆 <%= rs.getString("SehirAdi") %></p>
                                <p style="font-size:0.9rem; color:#cbd5e1; margin-bottom:12px;"><%= rs.getString("Aciklama") %></p>
                                <a href="mekanDetay.jsp?placeId=<%= rs.getInt("ID") %>" style="font-weight:bold;">Mekanı İncele →</a>
                            </div>
            <%
                        }
                        if(!sonucVarMi) { out.print("<p style='color:#94a3b8;'>Kriterlere uygun mekan bulunamadı.</p>"); }
                    }

                    if(rs != null) rs.close();
                    if(ps != null) ps.close();
                    conn.close();
                }
            %>
        </div>
    </div>
</body>
</html>
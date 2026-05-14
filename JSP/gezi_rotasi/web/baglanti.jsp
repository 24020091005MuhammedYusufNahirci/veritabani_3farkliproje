<%@ page import="java.sql.*" %>
<%
    String url = "jdbc:postgresql://localhost:5433/sehir_gezi";
    String dbUser = "postgres";
    String dbPassword = "yusufefe05"; 
    
    Connection conn = null;
    try {
        Class.forName("org.postgresql.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPassword);
    } catch (Exception e) {
        out.println("<div style='color:red; padding:10px; background:#fee2e2; border-radius:6px;'>Ba?lant? Hatas?: " + e.getMessage() + "</div>");
    }
%>
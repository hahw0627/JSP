<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>숙소 목록</title>
    <style>
        table {
            width: 80%;
            border-collapse: collapse;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #aaa;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f2f2f2;
        }
        img {
            max-width: 150px;
            height: auto;
        }
    </style>
</head>
<body>
    <h1 style="text-align: center;">숙소 목록</h1>

    <%
    // DB 연결 정보
    String url = "jdbc:mysql://localhost:3306/tour?useSSL=false&serverTimezone=UTC";
    String username = "root";
    String password = "hahs884312~";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);

        String sql = "SELECT title, addr1, firstimage, tel FROM lodgment";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);
    %>

    <table>
        <tr>
            <th>이름</th>
            <th>주소</th>
            <th>이미지</th>
            <th>전화번호</th>
        </tr>

        <%
        while (rs.next()) {
            String title = rs.getString("title");
            String addr = rs.getString("addr1");
            String img = rs.getString("firstimage");
            String tel = rs.getString("tel");
        %>
        <tr>
            <td><%= title %></td>
            <td><%= addr %></td>
            <td>
                <% if (img != null && !img.isEmpty()) { %>
                    <img src="<%= img %>" alt="이미지">
                <% } else { %>
                    없음
                <% } %>
            </td>
            <td><%= tel != null ? tel : "없음" %></td>
        </tr>
        <%
        } // end while
        %>
    </table>

    <%
    } catch (Exception e) {
        out.println("<div style='color:red;'>오류 발생: " + e.getMessage() + "</div>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
    %>
</body>
</html>

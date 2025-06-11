<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>천안 숙소 예약 시스템</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

  <!-- 헤더 -->
  <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold">
    천안 여행 숙소 예약 시스템
  </header>

  <!-- 검색창 -->
  <div class="flex justify-center py-6 bg-white shadow">
    <form action="" method="get" class="flex w-full justify-center">
      <input type="text" name="keyword" placeholder="지역, 숙소명, 키워드로 검색"
             class="w-1/2 px-4 py-2 border rounded-l-md" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" />
      <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded-r-md">검색</button>
    </form>
  </div>

  <!-- 본문 -->
  <div class="flex max-w-7xl mx-auto mt-6 gap-4">
    <!-- 숙소 결과 영역 -->
    <main class="w-full p-4"> 

<%
// 데이터베이스 연결 정보
String url = "jdbc:mysql://localhost:3306/tour?useSSL=false&serverTimezone=UTC";
String username = "root";
String password = "hahs884312~";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
PreparedStatement countStmt = null;
ResultSet countRs = null;

// 페이지네이션 설정
int currentPage = 1;
int itemsPerPage = 5;
String pageParam = request.getParameter("page");
if (pageParam != null && !pageParam.isEmpty()) {
    try {
        currentPage = Integer.parseInt(pageParam);
    } catch (NumberFormatException e) {
        currentPage = 1;
    }
}

// 검색 키워드
String keyword = request.getParameter("keyword");
if (keyword == null) keyword = "";

int totalItems = 0;
int totalPages = 0;
int offset = (currentPage - 1) * itemsPerPage;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, username, password);

    // 전체 개수 조회
    String countSql;
    if (!keyword.isEmpty()) {
        countSql = "SELECT COUNT(*) FROM lodgment WHERE title LIKE ? OR addr1 LIKE ?";
        countStmt = conn.prepareStatement(countSql);
        countStmt.setString(1, "%" + keyword + "%");
        countStmt.setString(2, "%" + keyword + "%");
    } else {
        countSql = "SELECT COUNT(*) FROM lodgment";
        countStmt = conn.prepareStatement(countSql);
    }
    
    countRs = countStmt.executeQuery();
    if (countRs.next()) {
        totalItems = countRs.getInt(1);
    }
    totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);

    // 데이터 조회 (페이지네이션 적용) - ID도 함께 조회
    String sql;
    if (!keyword.isEmpty()) {
        sql = "SELECT id, title, addr1, firstimage, tel FROM lodgment WHERE title LIKE ? OR addr1 LIKE ? LIMIT ? OFFSET ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + keyword + "%");
        pstmt.setString(2, "%" + keyword + "%");
        pstmt.setInt(3, itemsPerPage);
        pstmt.setInt(4, offset);
    } else {
        sql = "SELECT id, title, addr1, firstimage, tel FROM lodgment LIMIT ? OFFSET ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, itemsPerPage);
        pstmt.setInt(2, offset);
    }
    
    rs = pstmt.executeQuery();
%>

      <div class="mb-4">
        <h2 class="text-xl font-bold mb-2">검색 결과</h2>
        <p class="text-gray-600">총 <strong><%= totalItems %></strong>개의 숙소 (페이지 <%= currentPage %>/<%= totalPages %>)</p>
      </div>

      <!-- 숙소 목록 출력 -->
<%
    boolean hasResults = false;
    while (rs.next()) {
        hasResults = true;
        int hotelId = rs.getInt("id");  // ID 추가
        String title = rs.getString("title");
        String addr = rs.getString("addr1");
        String img = rs.getString("firstimage");
        String tel = rs.getString("tel");
        
        // 기본 이미지 처리
        if (img == null || img.isEmpty()) {
            img = "https://via.placeholder.com/300x200?text=Hotel+Image";
        }
%>
        <div class="bg-white shadow-lg rounded-lg overflow-hidden mb-6 flex flex-col md:flex-row">
          <img src="<%= img %>" alt="<%= title %>" class="w-full md:w-1/3 h-48 md:h-auto object-cover">
          <div class="p-6 flex flex-col justify-between flex-grow">
            <div>
              <h3 class="text-2xl font-bold text-blue-700 mb-2"><%= title %></h3>
              <p class="text-sm text-gray-600 mb-1"><%= addr != null ? addr : "주소 정보 없음" %></p>
              <p class="text-yellow-500 mb-1">
                ☆☆☆☆☆ (0.0)
              </p>
              <p class="text-sm text-gray-600 mb-3 leading-relaxed">편안하고 깨끗한 숙소입니다. 천안역 인근 위치로 교통이 편리합니다.</p>
            </div>
            <div class="text-right mt-4">
              <p class="text-red-500 font-bold text-xl mb-2">객실 가격 전화문의 요망</p>
              <p class="text-sm text-gray-500 mb-3">1박 기준</p>
              <p class="text-sm text-gray-600 mb-3">전화: <%= tel != null ? tel : "정보 없음" %></p>
              <div class="flex flex-col sm:flex-row sm:justify-end gap-2">
                <button onclick="location.href='detail.jsp?hotelId=<%= hotelId %>'" 
                        class="block w-full sm:w-auto text-center bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded transition duration-150 ease-in-out">
                  상세보기
                </button>
                <button onclick="location.href='detail.jsp?hotelId=<%= hotelId %>'" 
                        class="block w-full sm:w-auto text-center bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded transition duration-150 ease-in-out">
                  예약하기
                </button>
              </div>
            </div>
          </div>
        </div>
<%
    }
    
    if (!hasResults) {
%>
        <div class="text-center py-10">
          <p class="text-xl text-gray-700">검색 결과에 해당하는 숙소가 없습니다.</p>
          <p class="text-gray-500 mt-2">다른 키워드로 검색해보세요.</p>
        </div>
<%
    }
%>

      <!-- 페이지네이션 -->
      <% if (totalPages > 1) { %>
      <div class="mt-8 flex justify-center">
        <nav aria-label="Page navigation">
          <ul class="inline-flex items-center -space-x-px">
            <!-- 이전 페이지 -->
            <% if (currentPage > 1) { %>
            <li>
              <a href="?page=<%= currentPage - 1 %><%= !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>" 
                 class="py-2 px-3 ml-0 leading-tight text-gray-500 bg-white rounded-l-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700">
                이전
              </a>
            </li>
            <% } else { %>
            <li>
              <span class="py-2 px-3 ml-0 leading-tight text-gray-300 bg-gray-100 rounded-l-lg border border-gray-300 cursor-not-allowed">
                이전
              </span>
            </li>
            <% } %>

            <!-- 페이지 번호들 -->
            <%
            int startPage = Math.max(1, currentPage - 2);
            int endPage = Math.min(totalPages, currentPage + 2);
            
            for (int i = startPage; i <= endPage; i++) {
                if (i == currentPage) {
            %>
            <li>
              <span class="z-10 py-2 px-3 leading-tight text-blue-600 bg-blue-50 border border-blue-300">
                <%= i %>
              </span>
            </li>
            <%
                } else {
            %>
            <li>
              <a href="?page=<%= i %><%= !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>" 
                 class="py-2 px-3 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700">
                <%= i %>
              </a>
            </li>
            <%
                }
            }
            %>

            <!-- 다음 페이지 -->
            <% if (currentPage < totalPages) { %>
            <li>
              <a href="?page=<%= currentPage + 1 %><%= !keyword.isEmpty() ? "&keyword=" + java.net.URLEncoder.encode(keyword, "UTF-8") : "" %>" 
                 class="py-2 px-3 leading-tight text-gray-500 bg-white rounded-r-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700">
                다음
              </a>
            </li>
            <% } else { %>
            <li>
              <span class="py-2 px-3 leading-tight text-gray-300 bg-gray-100 rounded-r-lg border border-gray-300 cursor-not-allowed">
                다음
              </span>
            </li>
            <% } %>
          </ul>
        </nav>
      </div>
      <% } %>

<%
} catch (Exception e) {
    out.println("<div class='bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4'>");
    out.println("오류 발생: " + e.getMessage());
    out.println("</div>");
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    if (countRs != null) try { countRs.close(); } catch (SQLException e) {}
    if (countStmt != null) try { countStmt.close(); } catch (SQLException e) {}
    if (conn != null) try { conn.close(); } catch (SQLException e) {}
}
%>

    </main>
  </div>

  <!-- 푸터 -->
  <footer class="mt-12 text-center text-sm text-gray-600 py-4 border-t">
    천안 여행 숙소 예약 시스템 © 2025 | 고객센터: 1588-0000
  </footer>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="org.json.*" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>숙박 목록</title>
  <style>
    body {
      font-family: 'Malgun Gothic', sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
    }
    h1 {
      text-align: center;
      color: #333;
      margin-bottom: 30px;
    }
    .search-box {
      text-align: center;
      margin-bottom: 20px;
    }
    .search-box input {
      padding: 10px;
      width: 300px;
      border: 2px solid #ddd;
      border-radius: 5px;
      font-size: 16px;
    }
    .search-box button {
      padding: 10px 20px;
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
      margin-left: 10px;
    }
    .search-box button:hover {
      background-color: #0056b3;
    }
    .card {
      background: white;
      border: 1px solid #ddd;
      padding: 20px;
      margin: 15px 0;
      border-radius: 10px;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      display: flex;
      gap: 20px;
    }
    .card:hover {
      box-shadow: 0 4px 15px rgba(0,0,0,0.2);
      transform: translateY(-2px);
      transition: all 0.3s ease;
    }
    .card-image {
      flex-shrink: 0;
      width: 200px;
      height: 150px;
    }
    .card-image img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      border-radius: 8px;
    }
    .card-content {
      flex: 1;
    }
    .card-title {
      font-size: 18px;
      font-weight: bold;
      color: #333;
      margin-bottom: 10px;
    }
    .card-info {
      color: #666;
      line-height: 1.6;
    }
    .card-info p {
      margin: 5px 0;
    }
    .no-image {
      background-color: #f0f0f0;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #999;
      border-radius: 8px;
    }
    .pagination {
      text-align: center;
      margin: 30px 0;
    }
    .pagination button {
      margin: 0 5px;
      padding: 8px 15px;
      cursor: pointer;
      border: 1px solid #ddd;
      background-color: white;
      border-radius: 5px;
      font-size: 14px;
    }
    .pagination button:hover {
      background-color: #f8f9fa;
    }
    .pagination button.active {
      background-color: #007bff;
      color: white;
      border-color: #007bff;
      font-weight: bold;
    }
    .loading {
      text-align: center;
      padding: 50px;
      font-size: 18px;
      color: #666;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🏨 숙박 목록</h1>
    
    <div class="search-box">
      <input type="text" id="searchInput" placeholder="숙박 이름 또는 주소로 검색..." onkeypress="handleEnter(event)">
      <button onclick="searchAccommodation()">검색</button>
      <button onclick="resetSearch()">전체보기</button>
    </div>
    
    <div id="accommodation-list" class="loading">데이터를 불러오는 중...</div>
    <div class="pagination" id="pagination"></div>
  </div>

  <script>
    <%
    // DB 연결 정보
    String url = "jdbc:mysql://localhost:3306/tour?useSSL=false&serverTimezone=UTC";
    String username = "root";
    String password = "hahs884312~"; // 실제 비밀번호로 변경하세요
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    JSONArray jsonArray = new JSONArray();
    
    try {
        // MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        
        // DB 연결
        conn = DriverManager.getConnection(url, username, password);
        
        // 검색어 파라미터 확인
        String searchKeyword = request.getParameter("search");
        String sql;
        
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql = "SELECT * FROM lodgment WHERE title LIKE ? OR addr1 LIKE ? ORDER BY id";
            pstmt = conn.prepareStatement(sql);
            String searchPattern = "%" + searchKeyword.trim() + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
        } else {
            sql = "SELECT * FROM lodgment ORDER BY id";
            pstmt = conn.prepareStatement(sql);
        }
        
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            JSONObject item = new JSONObject();
            item.put("id", rs.getInt("id"));
            item.put("title", rs.getString("title") != null ? rs.getString("title") : "");
            item.put("addr1", rs.getString("addr1") != null ? rs.getString("addr1") : "");
            item.put("tel", rs.getString("tel") != null ? rs.getString("tel") : "");
            item.put("firstimage", rs.getString("firstimage") != null ? rs.getString("firstimage") : "");
            jsonArray.put(item);
        }
        
    } catch (Exception e) {
        out.println("// 데이터베이스 오류: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
    %>
    
    const itemsPerPage = 10;
    let currentPage = 1;
    let dataItems = <%= jsonArray.toString() %>;
    let filteredItems = dataItems;

    function renderPage(page) {
      const list = document.getElementById('accommodation-list');
      
      if (filteredItems.length === 0) {
        list.innerHTML = '<div class="loading">검색 결과가 없습니다.</div>';
        return;
      }

      list.innerHTML = '';

      const startIndex = (page - 1) * itemsPerPage;
      const endIndex = startIndex + itemsPerPage;
      const pageItems = filteredItems.slice(startIndex, endIndex);

      pageItems.forEach(item => {
        const card = document.createElement('div');
        card.className = 'card';

        const imageHtml = item.firstimage ? 
          `<div class="card-image"><img src="${item.firstimage}" alt="${item.title}" onerror="this.parentElement.innerHTML='<div class=\\'no-image\\'>이미지 없음</div>'"></div>` :
          '<div class="card-image"><div class="no-image">이미지 없음</div></div>';

        const title = `<div class="card-title">${item.title || '제목 없음'}</div>`;
        const address = `<p><strong>📍 주소:</strong> ${item.addr1 || '주소 정보 없음'}</p>`;
        const phone = item.tel ? `<p><strong>📞 전화:</strong> ${item.tel}</p>` : '';

        card.innerHTML = imageHtml + 
          `<div class="card-content">
            ${title}
            <div class="card-info">
              ${address}
              ${phone}
            </div>
          </div>`;
        
        list.appendChild(card);
      });
    }

    function setupPagination(totalItems) {
      const pagination = document.getElementById('pagination');
      pagination.innerHTML = '';

      if (totalItems === 0) return;

      const pageCount = Math.ceil(totalItems / itemsPerPage);
      
      // 이전 버튼
      if (currentPage > 1) {
        const prevBtn = document.createElement('button');
        prevBtn.textContent = '« 이전';
        prevBtn.onclick = () => goToPage(currentPage - 1);
        pagination.appendChild(prevBtn);
      }

      // 페이지 번호 버튼
      const startPage = Math.max(1, currentPage - 2);
      const endPage = Math.min(pageCount, currentPage + 2);

      for (let i = startPage; i <= endPage; i++) {
        const btn = document.createElement('button');
        btn.textContent = i;
        btn.onclick = () => goToPage(i);
        if (i === currentPage) {
          btn.classList.add('active');
        }
        pagination.appendChild(btn);
      }

      // 다음 버튼
      if (currentPage < pageCount) {
        const nextBtn = document.createElement('button');
        nextBtn.textContent = '다음 »';
        nextBtn.onclick = () => goToPage(currentPage + 1);
        pagination.appendChild(nextBtn);
      }
    }

    function goToPage(page) {
      currentPage = page;
      renderPage(currentPage);
      setupPagination(filteredItems.length);
      window.scrollTo(0, 0);
    }

    function searchAccommodation() {
      const keyword = document.getElementById('searchInput').value.trim();
      if (keyword) {
        filteredItems = dataItems.filter(item => 
          (item.title && item.title.toLowerCase().includes(keyword.toLowerCase())) ||
          (item.addr1 && item.addr1.toLowerCase().includes(keyword.toLowerCase()))
        );
      } else {
        filteredItems = dataItems;
      }
      currentPage = 1;
      renderPage(currentPage);
      setupPagination(filteredItems.length);
    }

    function resetSearch() {
      document.getElementById('searchInput').value = '';
      filteredItems = dataItems;
      currentPage = 1;
      renderPage(currentPage);
      setupPagination(filteredItems.length);
    }

    function handleEnter(event) {
      if (event.key === 'Enter') {
        searchAccommodation();
      }
    }

    // 페이지 로드 시 초기화
    window.onload = function() {
      if (dataItems && dataItems.length > 0) {
        setupPagination(dataItems.length);
        renderPage(currentPage);
      } else {
        document.getElementById('accommodation-list').innerHTML = '<div class="loading">표시할 숙박 정보가 없습니다.</div>';
      }
    };
  </script>
</body>
</html>
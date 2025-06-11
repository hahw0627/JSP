<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>숙소 상세 정보</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

  <!-- 상단 헤더 -->
  <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold mb-6">
    숙소 상세 정보
  </header>

<%
// 숙소 ID 파라미터 받기
String hotelIdParam = request.getParameter("hotelId");
if (hotelIdParam == null) {
    hotelIdParam = request.getParameter("id"); // 다른 파라미터명도 고려
}

// 데이터베이스 연결 정보
String url = "jdbc:mysql://localhost:3306/tour?useSSL=false&serverTimezone=UTC";
String username = "root";
String password = "hahs884312~";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

// 숙소 정보 변수들
String hotelName = "";
String hotelAddress = "";
String hotelImage = "";
String hotelTel = "";
String hotelDescription = "";
int hotelPrice = 89000; // 기본 가격

boolean hotelFound = false;

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, username, password);

    // 특정 숙소 ID로 조회하거나, ID가 없으면 첫 번째 숙소 조회
    String sql;
    if (hotelIdParam != null && !hotelIdParam.isEmpty()) {
        // ID가 숫자인지 확인 후 조회
        try {
            int hotelId = Integer.parseInt(hotelIdParam);
            sql = "SELECT title, addr1, firstimage, tel FROM lodgment WHERE id = ? LIMIT 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, hotelId);
        } catch (NumberFormatException e) {
            // ID가 숫자가 아니면 제목으로 검색
            sql = "SELECT title, addr1, firstimage, tel FROM lodgment WHERE title LIKE ? LIMIT 1";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + hotelIdParam + "%");
        }
    } else {
        // ID가 없으면 첫 번째 숙소 조회
        sql = "SELECT title, addr1, firstimage, tel FROM lodgment LIMIT 1";
        pstmt = conn.prepareStatement(sql);
    }
    
    rs = pstmt.executeQuery();
    
    if (rs.next()) {
        hotelFound = true;
        hotelName = rs.getString("title");
        hotelAddress = rs.getString("addr1");
        hotelImage = rs.getString("firstimage");
        hotelTel = rs.getString("tel");
        
        // 기본 설명 생성
        hotelDescription = hotelName + "은(는) " + hotelAddress + "에 위치한 멋진 숙소입니다. " +
                          "다양한 편의시설을 제공하며 편안한 휴식을 즐기실 수 있습니다. " +
                          "천안의 주요 관광지와 가까운 거리에 있어 여행하기에 최적의 위치입니다.";
        
        // 이미지가 없으면 기본 이미지 설정
        if (hotelImage == null || hotelImage.isEmpty()) {
            hotelImage = "https://via.placeholder.com/800x400?text=" + java.net.URLEncoder.encode(hotelName, "UTF-8");
        }
    }

} catch (Exception e) {
    out.println("<!-- 데이터베이스 오류: " + e.getMessage() + " -->");
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (SQLException e) {}
    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
    if (conn != null) try { conn.close(); } catch (SQLException e) {}
}

// 가격 포맷팅
NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.KOREA);
%>

  <main class="max-w-5xl mx-auto p-6 bg-white shadow mt-6 rounded">
    <% if (hotelFound) { %>
        <!-- 숙소 이름과 위치 -->
        <div class="flex justify-between items-start mb-4">
          <div>
            <h1 class="text-3xl font-bold mb-2"><%= hotelName %></h1>
            <p class="text-gray-600 mb-4"><%= hotelAddress != null ? hotelAddress : "주소 정보 없음" %> | ★★★★☆ 4.5</p>
          </div>
          <a href="javascript:history.back()" class="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600 transition">
            목록으로 돌아가기
          </a>
        </div>

        <!-- 숙소 이미지 -->
        <img src="<%= hotelImage %>" alt="<%= hotelName %> 이미지" 
             class="w-full h-64 object-cover rounded mb-6" 
             onerror="this.src='https://via.placeholder.com/800x400?text=Hotel+Image'" />

        <!-- 숙소 설명 -->
        <section class="mb-6">
          <h2 class="text-xl font-semibold mb-2">숙소 소개</h2>
          <p class="text-gray-700 leading-relaxed">
            <%= hotelDescription %>
          </p>
        </section>

        <!-- 편의 시설 -->
        <section class="mb-6">
          <h2 class="text-xl font-semibold mb-2">편의 시설</h2>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 text-gray-700">
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">📶</span>
              <span>무료 Wi-Fi</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">🅿️</span>
              <span>주차장</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">❄️</span>
              <span>에어컨</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">🛁</span>
              <span>욕실용품</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">📺</span>
              <span>TV</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">🏠</span>
              <span>24시간 프런트</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">🧴</span>
              <span>수건 제공</span>
            </div>
            <div class="flex items-center space-x-2">
              <span class="text-blue-500">☕</span>
              <span>카페/레스토랑</span>
            </div>
          </div>
        </section>

        <!-- 연락처 정보 -->
        <% if (hotelTel != null && !hotelTel.isEmpty()) { %>
        <section class="mb-6">
          <h2 class="text-xl font-semibold mb-2">연락처</h2>
          <p class="text-gray-700">
            <span class="font-medium">전화번호:</span> 
            <a href="tel:<%= hotelTel %>" class="text-blue-600 hover:underline"><%= hotelTel %></a>
          </p>
        </section>
        <% } %>

        <!-- 가격 및 예약 -->
        <section class="border-t pt-6 mt-6">
          <div class="bg-gray-50 p-6 rounded-lg">
            <div class="flex justify-between items-center mb-4">
              <div>
                <p class="text-red-500 font-bold text-3xl">
                  <%= numberFormat.format(hotelPrice) %>원
                </p>
                <p class="text-sm text-gray-500">1박 기준 (세금 포함)</p>
              </div>
              <div class="text-right">
                <p class="text-yellow-500 text-lg mb-1">★★★★☆</p>
                <p class="text-sm text-gray-600">평점 4.5/5.0</p>
              </div>
            </div>
            
            <!-- 예약 폼 -->
            <form class="space-y-4" action="reservation.jsp" method="post">
              <input type="hidden" name="hotelName" value="<%= hotelName %>">
              <input type="hidden" name="hotelPrice" value="<%= hotelPrice %>">
              
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">체크인</label>
                  <input type="date" name="checkin" class="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500" required>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">체크아웃</label>
                  <input type="date" name="checkout" class="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500" required>
                </div>
              </div>
              
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">투숙객 수</label>
                  <select name="guests" class="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500">
                    <option value="1">1명</option>
                    <option value="2" selected>2명</option>
                    <option value="3">3명</option>
                    <option value="4">4명</option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">객실 수</label>
                  <select name="rooms" class="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500">
                    <option value="1" selected>1개</option>
                    <option value="2">2개</option>
                    <option value="3">3개</option>
                  </select>
                </div>
              </div>
              
              <button type="submit" class="w-full bg-red-500 text-white py-3 px-6 rounded-lg font-semibold text-lg hover:bg-red-600 transition duration-200">
                지금 예약하기
              </button>
            </form>
          </div>
        </section>

    <% } else { %>
        <div class="text-center py-20">
          <p class="text-xl text-red-500 mb-4">숙소 정보를 불러올 수 없습니다.</p>
          <p class="text-gray-600 mb-6">요청하신 숙소를 찾을 수 없거나 일시적인 오류가 발생했습니다.</p>
          <a href="javascript:history.back()" class="bg-blue-500 text-white px-6 py-2 rounded hover:bg-blue-600 transition">
            목록으로 돌아가기
          </a>
        </div>
    <% } %>

    <!-- 리뷰 및 평점 -->
    <section class="border-t pt-6 mb-6 mt-10">
      <h2 class="text-xl font-semibold mb-4">리뷰 및 평점</h2>

      <!-- 평균 평점 -->
      <div class="flex items-center mb-6 bg-gray-50 p-4 rounded">
        <div class="text-center mr-8">
          <div class="text-4xl font-bold text-blue-600 mb-1">4.5</div>
          <div class="text-yellow-500 text-xl mb-1">★★★★☆</div>
          <div class="text-sm text-gray-500">총 127개 리뷰</div>
        </div>
        <div class="flex-1">
          <div class="space-y-2">
            <div class="flex items-center">
              <span class="w-8 text-sm">5★</span>
              <div class="flex-1 bg-gray-200 rounded-full h-2 mx-2">
                <div class="bg-yellow-500 h-2 rounded-full" style="width: 65%"></div>
              </div>
              <span class="text-sm text-gray-600">82</span>
            </div>
            <div class="flex items-center">
              <span class="w-8 text-sm">4★</span>
              <div class="flex-1 bg-gray-200 rounded-full h-2 mx-2">
                <div class="bg-yellow-500 h-2 rounded-full" style="width: 25%"></div>
              </div>
              <span class="text-sm text-gray-600">32</span>
            </div>
            <div class="flex items-center">
              <span class="w-8 text-sm">3★</span>
              <div class="flex-1 bg-gray-200 rounded-full h-2 mx-2">
                <div class="bg-yellow-500 h-2 rounded-full" style="width: 8%"></div>
              </div>
              <span class="text-sm text-gray-600">10</span>
            </div>
            <div class="flex items-center">
              <span class="w-8 text-sm">2★</span>
              <div class="flex-1 bg-gray-200 rounded-full h-2 mx-2">
                <div class="bg-gray-300 h-2 rounded-full" style="width: 2%"></div>
              </div>
              <span class="text-sm text-gray-600">2</span>
            </div>
            <div class="flex items-center">
              <span class="w-8 text-sm">1★</span>
              <div class="flex-1 bg-gray-200 rounded-full h-2 mx-2">
                <div class="bg-gray-300 h-2 rounded-full" style="width: 1%"></div>
              </div>
              <span class="text-sm text-gray-600">1</span>
            </div>
          </div>
        </div>
      </div>

      <!-- 개별 리뷰 예시 -->
      <div class="space-y-4">
        <div class="border-b pb-4">
          <div class="flex justify-between items-start mb-2">
            <div>
              <span class="font-medium">김○○</span>
              <span class="text-yellow-500 ml-2">★★★★★</span>
            </div>
            <span class="text-sm text-gray-500">2024.12.15</span>
          </div>
          <p class="text-gray-700">정말 깨끗하고 좋았습니다. 직원분들도 친절하시고 위치도 좋아요. 다음에도 또 이용하고 싶어요!</p>
        </div>
        
        <div class="border-b pb-4">
          <div class="flex justify-between items-start mb-2">
            <div>
              <span class="font-medium">박○○</span>
              <span class="text-yellow-500 ml-2">★★★★☆</span>
            </div>
            <span class="text-sm text-gray-500">2024.12.10</span>
          </div>
          <p class="text-gray-700">가성비가 좋습니다. 시설도 깔끔하고 조용해서 잘 쉬었어요. 주차장도 넓어서 편리했습니다.</p>
        </div>
      </div>
    </section>

    <!-- 리뷰 작성 폼 -->
    <section class="mb-6 mt-8">
      <h2 class="text-xl font-semibold mb-4">리뷰 작성하기</h2>
      <form class="space-y-4 bg-gray-100 p-6 rounded-lg">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label for="reviewer-name" class="block text-sm font-medium text-gray-700 mb-1">이름</label>
            <input type="text" id="reviewer-name" name="name" class="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500" required />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">평점</label>
            <div class="flex space-x-1 text-2xl">
              <span class="star cursor-pointer text-gray-400 hover:text-yellow-500" data-value="1">★</span>
              <span class="star cursor-pointer text-gray-400 hover:text-yellow-500" data-value="2">★</span>
              <span class="star cursor-pointer text-gray-400 hover:text-yellow-500" data-value="3">★</span>
              <span class="star cursor-pointer text-gray-400 hover:text-yellow-500" data-value="4">★</span>
              <span class="star cursor-pointer text-gray-400 hover:text-yellow-500" data-value="5">★</span>
            </div>
            <input type="hidden" name="rating" id="rating" required>
          </div>
        </div>
        <div>
          <label for="review-content" class="block text-sm font-medium text-gray-700 mb-1">리뷰 내용</label>
          <textarea id="review-content" name="review" rows="4" class="w-full p-2 border rounded focus:ring-2 focus:ring-blue-500" placeholder="숙소에 대한 경험을 공유해주세요..." required></textarea>
        </div>
        <div class="text-right">
          <button type="submit" class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 transition">리뷰 등록</button>
        </div>
      </form>
    </section>
  </main>

  <!-- 푸터 -->
  <footer class="mt-12 text-center text-sm text-gray-600 py-4 border-t">
    천안 여행 숙소 예약 시스템 © 2025 | 고객센터: 1588-0000
  </footer>

  <script>
    // 별점 선택 기능
    document.addEventListener('DOMContentLoaded', function() {
      const stars = document.querySelectorAll('.star');
      const ratingInput = document.getElementById('rating');
      
      stars.forEach(star => {
        star.addEventListener('click', function() {
          const value = this.getAttribute('data-value');
          ratingInput.value = value;
          
          // 별점 표시 업데이트
          stars.forEach((s, index) => {
            if (index < value) {
              s.classList.remove('text-gray-400');
              s.classList.add('text-yellow-500');
            } else {
              s.classList.remove('text-yellow-500');
              s.classList.add('text-gray-400');
            }
          });
        });
      });
      
      // 체크인/체크아웃 날짜 제한
      const today = new Date().toISOString().split('T')[0];
      document.querySelector('input[name="checkin"]').setAttribute('min', today);
      document.querySelector('input[name="checkout"]').setAttribute('min', today);
      
      // 체크인 날짜 변경 시 체크아웃 최소 날짜 설정
      document.querySelector('input[name="checkin"]').addEventListener('change', function() {
        const checkin = this.value;
        const checkoutInput = document.querySelector('input[name="checkout"]');
        checkoutInput.setAttribute('min', checkin);
        
        // 체크아웃이 체크인보다 빠르면 리셋
        if (checkoutInput.value && checkoutInput.value <= checkin) {
          checkoutInput.value = '';
        }
      });
    });
  </script>
</body>
</html>
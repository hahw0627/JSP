<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Date" %>
<%
// 인코딩 설정 - 한글 깨짐 방지를 위한 필수 설정
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>숙소 예약 - 천안 여행 숙소 예약 시스템</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50">

    <!-- 헤더 -->
    <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold">
        천안 여행 숙소 예약 시스템
    </header>

<%
// 데이터베이스 연결 정보 - 인코딩 설정 추가
String url = "jdbc:mysql://localhost:3306/tour?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8&useUnicode=true";
String username = "root";
String password = "hahs884312~";

// 폼에서 전달된 데이터 받기
String hotelName = request.getParameter("hotelName");
String hotelPriceStr = request.getParameter("hotelPrice");
String checkinDate = request.getParameter("checkin");
String checkoutDate = request.getParameter("checkout");
String guestsStr = request.getParameter("guests");
String roomsStr = request.getParameter("rooms");

// null 값 처리 및 기본값 설정
if (hotelName == null || hotelName.trim().isEmpty()) {
    hotelName = "선택된 숙소";
}
if (hotelPriceStr == null) hotelPriceStr = "89000";
if (guestsStr == null) guestsStr = "2";
if (roomsStr == null) roomsStr = "1";

// 예약 처리 여부 확인
boolean isReservationSubmit = "POST".equals(request.getMethod()) && 
                             request.getParameter("customerName") != null;

String reservationMessage = "";
boolean reservationSuccess = false;

// 예약 처리 로직
if (isReservationSubmit) {
    String customerName = request.getParameter("customerName");
    String customerEmail = request.getParameter("customerEmail");
    String customerPhone = request.getParameter("customerPhone");
    String specialRequests = request.getParameter("specialRequests");
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, username, password);
        
        // 데이터베이스 인코딩 설정
        Statement stmt = conn.createStatement();
        stmt.execute("SET NAMES utf8mb4");
        stmt.execute("SET CHARACTER SET utf8mb4");
        stmt.close();
        
        // 예약 테이블이 없으면 생성 (UTF-8 설정 포함)
        String createTableSql = "CREATE TABLE IF NOT EXISTS reservations (" +
                               "id INT AUTO_INCREMENT PRIMARY KEY, " +
                               "hotel_name VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL, " +
                               "customer_name VARCHAR(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL, " +
                               "customer_email VARCHAR(100) NOT NULL, " +
                               "customer_phone VARCHAR(20) NOT NULL, " +
                               "checkin_date DATE NOT NULL, " +
                               "checkout_date DATE NOT NULL, " +
                               "guests INT NOT NULL, " +
                               "rooms INT NOT NULL, " +
                               "total_price INT NOT NULL, " +
                               "special_requests TEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci, " +
                               "reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                               "status VARCHAR(20) DEFAULT 'confirmed'" +
                               ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci";
        
        PreparedStatement createStmt = conn.prepareStatement(createTableSql);
        createStmt.executeUpdate();
        createStmt.close();
        
        // 예약 정보 저장
        String insertSql = "INSERT INTO reservations (hotel_name, customer_name, customer_email, " +
                          "customer_phone, checkin_date, checkout_date, guests, rooms, total_price, special_requests) " +
                          "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setString(1, hotelName);
        pstmt.setString(2, customerName);
        pstmt.setString(3, customerEmail);
        pstmt.setString(4, customerPhone);
        pstmt.setString(5, checkinDate);
        pstmt.setString(6, checkoutDate);
        pstmt.setInt(7, Integer.parseInt(guestsStr));
        pstmt.setInt(8, Integer.parseInt(roomsStr));
        pstmt.setInt(9, Integer.parseInt(hotelPriceStr));
        pstmt.setString(10, specialRequests);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            reservationSuccess = true;
            reservationMessage = "예약이 성공적으로 완료되었습니다!";
        } else {
            reservationMessage = "예약 처리 중 오류가 발생했습니다. 다시 시도해주세요.";
        }
        
    } catch (Exception e) {
        reservationMessage = "데이터베이스 오류: " + e.getMessage();
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e2) {}
        if (conn != null) try { conn.close(); } catch (SQLException e2) {}
    }
}

int hotelPrice = Integer.parseInt(hotelPriceStr);
int guests = Integer.parseInt(guestsStr);
int rooms = Integer.parseInt(roomsStr);

// 총 가격 계산 (체크인/체크아웃 날짜가 있으면 일수 계산)
int totalPrice = hotelPrice;
int nights = 1;

if (checkinDate != null && checkoutDate != null && !checkinDate.isEmpty() && !checkoutDate.isEmpty()) {
    try {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date checkin = sdf.parse(checkinDate);
        Date checkout = sdf.parse(checkoutDate);
        long diffTime = checkout.getTime() - checkin.getTime();
        nights = (int) (diffTime / (1000 * 60 * 60 * 24));
        if (nights > 0) {
            totalPrice = hotelPrice * nights * rooms;
        }
    } catch (Exception e) {
        nights = 1;
        totalPrice = hotelPrice * rooms;
    }
}

NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.KOREA);
%>

    <main class="max-w-4xl mx-auto my-8 p-6">
        
        <% if (reservationSuccess) { %>
            <!-- 예약 성공 메시지 -->
            <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded mb-6">
                <div class="flex items-center">
                    <span class="text-2xl mr-3">✅</span>
                    <div>
                        <p class="font-bold text-lg">예약 완료!</p>
                        <p><%= reservationMessage %></p>
                        <p class="text-sm mt-2">예약 확인 이메일을 발송해드렸습니다.</p>
                    </div>
                </div>
            </div>
            
            <!-- 예약 확인 정보 -->
            <div class="bg-white rounded-lg shadow-md p-6 mb-6">
                <h2 class="text-2xl font-bold mb-4 text-blue-600">예약 확인</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <p><strong>숙소명:</strong> <%= hotelName %></p>
                        <p><strong>체크인:</strong> <%= checkinDate %></p>
                        <p><strong>체크아웃:</strong> <%= checkoutDate %></p>
                        <p><strong>숙박일수:</strong> <%= nights %>박</p>
                    </div>
                    <div>
                        <p><strong>투숙객:</strong> <%= guests %>명</p>
                        <p><strong>객실 수:</strong> <%= rooms %>개</p>
                        <p><strong>총 결제금액:</strong> <span class="text-red-500 font-bold"><%= numberFormat.format(totalPrice) %>원</span></p>
                    </div>
                </div>
            </div>
            
            <div class="text-center">
                <a href="index.jsp" class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-6 rounded mr-4 transition">
                    메인으로 돌아가기
                </a>
                <a href="javascript:window.print()" class="bg-gray-500 hover:bg-gray-600 text-white font-semibold py-2 px-6 rounded transition">
                    예약확인서 인쇄
                </a>
            </div>
            
        <% } else { %>
            <!-- 예약 폼 -->
            <% if (!reservationMessage.isEmpty() && !reservationSuccess) { %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-6">
                    <p class="font-bold">오류 발생</p>
                    <p><%= reservationMessage %></p>
                </div>
            <% } %>
            
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                
                <!-- 예약 정보 요약 -->
                <div class="lg:col-span-1">
                    <div class="bg-white rounded-lg shadow-md p-6 sticky top-6">
                        <h2 class="text-xl font-bold mb-4 text-blue-600">예약 정보</h2>
                        
                        <div class="space-y-3 text-sm">
                            <div class="flex justify-between">
                                <span class="text-gray-600">숙소명</span>
                                <span class="font-medium"><%= hotelName %></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">체크인</span>
                                <span class="font-medium"><%= checkinDate != null ? checkinDate : "미선택" %></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">체크아웃</span>
                                <span class="font-medium"><%= checkoutDate != null ? checkoutDate : "미선택" %></span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">숙박</span>
                                <span class="font-medium"><%= nights %>박</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">투숙객</span>
                                <span class="font-medium"><%= guests %>명</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">객실</span>
                                <span class="font-medium"><%= rooms %>개</span>
                            </div>
                        </div>
                        
                        <div class="border-t mt-4 pt-4">
                            <div class="flex justify-between items-center">
                                <span class="text-lg font-bold">총 결제금액</span>
                                <span class="text-xl font-bold text-red-500"><%= numberFormat.format(totalPrice) %>원</span>
                            </div>
                        </div>
                        
                        <!-- 가격 상세 -->
                        <div class="mt-4 text-xs text-gray-500">
                            <p>객실 요금: <%= numberFormat.format(hotelPrice) %>원 × <%= nights %>박 × <%= rooms %>개</p>
                            <p>세금 및 수수료 포함</p>
                        </div>
                    </div>
                </div>
                
                <!-- 예약자 정보 입력 -->
                <div class="lg:col-span-2">
                    <div class="bg-white rounded-lg shadow-md p-6">
                        <h2 class="text-2xl font-bold mb-6 text-blue-600">예약자 정보</h2>
                        
                        <form method="post" action="reservation.jsp" id="reservationForm" accept-charset="UTF-8">
                            <!-- 숨겨진 필드들 -->
                            <input type="hidden" name="hotelName" value="<%= hotelName %>">
                            <input type="hidden" name="hotelPrice" value="<%= hotelPriceStr %>">
                            <input type="hidden" name="checkin" value="<%= checkinDate != null ? checkinDate : "" %>">
                            <input type="hidden" name="checkout" value="<%= checkoutDate != null ? checkoutDate : "" %>">
                            <input type="hidden" name="guests" value="<%= guestsStr %>">
                            <input type="hidden" name="rooms" value="<%= roomsStr %>">
                            
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                                <div>
                                    <label for="customerName" class="block text-sm font-medium text-gray-700 mb-2">
                                        이름 <span class="text-red-500">*</span>
                                    </label>
                                    <input type="text" id="customerName" name="customerName" required
                                           class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                </div>
                                <div>
                                    <label for="customerEmail" class="block text-sm font-medium text-gray-700 mb-2">
                                        이메일 <span class="text-red-500">*</span>
                                    </label>
                                    <input type="email" id="customerEmail" name="customerEmail" required
                                           class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <label for="customerPhone" class="block text-sm font-medium text-gray-700 mb-2">
                                    연락처 <span class="text-red-500">*</span>
                                </label>
                                <input type="tel" id="customerPhone" name="customerPhone" required
                                       placeholder="010-1234-5678"
                                       class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500">
                            </div>
                            
                            <div class="mb-6">
                                <label for="specialRequests" class="block text-sm font-medium text-gray-700 mb-2">
                                    특별 요청사항
                                </label>
                                <textarea id="specialRequests" name="specialRequests" rows="3"
                                          placeholder="추가 침구, 금연실 요청 등 특별한 요청사항이 있으시면 입력해주세요."
                                          class="w-full p-3 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"></textarea>
                                <p class="text-xs text-gray-500 mt-1">* 특별 요청사항은 숙소 사정에 따라 보장되지 않을 수 있습니다.</p>
                            </div>
                            
                            <!-- 이용약관 동의 -->
                            <div class="mb-6">
                                <div class="bg-gray-50 p-4 rounded-lg">
                                    <h3 class="font-semibold mb-2">예약 약관</h3>
                                    <div class="text-sm text-gray-600 space-y-1">
                                        <p>• 체크인: 15:00 이후, 체크아웃: 11:00 이전</p>
                                        <p>• 취소/변경: 체크인 1일 전까지 무료 취소 가능</p>
                                        <p>• 노쇼(No-show) 시 전액 청구됩니다</p>
                                        <p>• 미성년자는 보호자 동반 시에만 투숙 가능합니다</p>
                                    </div>
                                </div>
                                
                                <div class="mt-4 space-y-2">
                                    <label class="flex items-center">
                                        <input type="checkbox" required class="mr-2">
                                        <span class="text-sm">위 예약 약관에 동의합니다 <span class="text-red-500">*</span></span>
                                    </label>
                                    <label class="flex items-center">
                                        <input type="checkbox" required class="mr-2">
                                        <span class="text-sm">개인정보 수집 및 이용에 동의합니다 <span class="text-red-500">*</span></span>
                                    </label>
                                </div>
                            </div>
                            
                            <div class="flex flex-col sm:flex-row gap-3">
                                <button type="button" onclick="history.back()" 
                                        class="flex-1 bg-gray-500 hover:bg-gray-600 text-white font-semibold py-3 px-6 rounded-md transition">
                                    이전으로
                                </button>
                                <button type="submit" 
                                        class="flex-1 bg-red-500 hover:bg-red-600 text-white font-semibold py-3 px-6 rounded-md transition">
                                    예약 확정하기
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <% } %>
    </main>

    <!-- 푸터 -->
    <footer class="mt-12 text-center text-sm text-gray-600 py-4 border-t">
        천안 여행 숙소 예약 시스템 © 2025 | 고객센터: 1588-0000
    </footer>

    <script>
        // 폼 유효성 검사
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            const name = document.getElementById('customerName').value.trim();
            const email = document.getElementById('customerEmail').value.trim();
            const phone = document.getElementById('customerPhone').value.trim();
            
            if (!name || !email || !phone) {
                e.preventDefault();
                alert('필수 항목을 모두 입력해주세요.');
                return;
            }
            
            // 이메일 형식 검사
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('올바른 이메일 형식을 입력해주세요.');
                return;
            }
            
            // 전화번호 형식 검사
            const phoneRegex = /^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$/;
            if (!phoneRegex.test(phone.replace(/\s/g, ''))) {
                e.preventDefault();
                alert('올바른 전화번호 형식을 입력해주세요. (예: 010-1234-5678)');
                return;
            }
            
            // 최종 확인
            if (!confirm('예약을 확정하시겠습니까?')) {
                e.preventDefault();
            }
        });
        
        // 전화번호 자동 포맷팅
        document.getElementById('customerPhone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length <= 3) {
                e.target.value = value;
            } else if (value.length <= 7) {
                e.target.value = value.slice(0, 3) + '-' + value.slice(3);
            } else {
                e.target.value = value.slice(0, 3) + '-' + value.slice(3, 7) + '-' + value.slice(7, 11);
            }
        });
    </script>

</body>
</html>
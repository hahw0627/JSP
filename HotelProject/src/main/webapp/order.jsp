<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- 필요한 경우 JSTL functions 라이브러리도 추가할 수 있습니다.
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
--%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>예약 결제</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

  <!-- 헤더 -->
  <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold mb-6">
    예약 결제
  </header>

  <main class="max-w-2xl mx-auto bg-white shadow p-6 rounded">

    <!-- 예약 요약 -->
    <section class="mb-6">
      <h2 class="text-xl font-semibold mb-2">예약 정보</h2>
      <ul class="text-gray-700 text-sm space-y-1">
        <%-- 서버로부터 전달받은 예약 정보를 표시합니다. 예시: request.getAttribute("reservationDetails") --%>
        <li><strong>숙소명:</strong> <c:out value="${reservationDetails.accommodationName}" default="에메랄드 오션 리조트"/></li>
        <li><strong>객실:</strong> <c:out value="${reservationDetails.roomInfo}" default="스탠다드 룸 1개"/></li>
        <li><strong>숙박 기간:</strong> <c:out value="${reservationDetails.stayPeriod}" default="2025-07-01 ~ 2025-07-03 (2박)"/></li>
        <li><strong>이용 인원:</strong> <c:out value="${reservationDetails.guestCount}" default="성인 2명"/></li>
      </ul>
    </section>

    <!-- 결제 정보 -->
    <section class="mb-6">
      <h2 class="text-xl font-semibold mb-2">결제 정보</h2>
      <div class="flex justify-between text-gray-700 text-sm">
        <span>숙박 요금</span>
        <span><c:out value="${paymentDetails.roomPrice}" default="150,000"/>원</span>
      </div>
      <div class="flex justify-between text-gray-700 text-sm mt-1">
        <span>세금 및 수수료</span>
        <span><c:out value="${paymentDetails.taxesAndFees}" default="10,000"/>원</span>
      </div>
      <div class="flex justify-between text-lg font-bold mt-4">
        <span>총 결제 금액</span>
        <span class="text-red-500"><c:out value="${paymentDetails.totalAmount}" default="160,000"/>원</span>
      </div>
    </section>

    <!-- 결제 방법 선택 -->
    <section class="mb-6">
      <h2 class="text-xl font-semibold mb-2">결제 수단</h2>
      <select name="paymentMethod" class="w-full border px-4 py-2 rounded">
        <option value="card">카드 결제</option>
        <option value="transfer">계좌 이체</option>
        <option value="kakaopay">카카오페이</option>
        <option value="tosspay">토스페이</option>
      </select>
    </section>

    <!-- 결제 버튼 -->
    <div class="text-right mt-6">
      <%-- 실제 결제 처리 로직은 서버에서 담당해야 합니다. --%>
      <button class="bg-red-500 text-white px-6 py-2 rounded text-lg hover:bg-red-600 transition" onclick="location.href='orderCheck.jsp'">
        결제하기
      </button>
    </div>
  </main>

  <!-- 푸터 -->
  <footer class="mt-12 text-center text-sm text-gray-600 py-4 border-t">
    천안 여행 숙소 예약 시스템 © 2025 | 고객센터: 1588-0000
  </footer>

</body>
</html>
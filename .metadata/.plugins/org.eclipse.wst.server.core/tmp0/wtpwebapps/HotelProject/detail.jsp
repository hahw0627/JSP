<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- 가격 포맷팅을 위해 추가 --%>
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

  <main class="max-w-5xl mx-auto p-6 bg-white shadow mt-6 rounded">
    <c:choose>
      <c:when test="${not empty hotel}">
        <!-- 숙소 이름과 위치 -->
        <h1 class="text-3xl font-bold mb-2"><c:out value="${hotel.name}"/></h1>
        <p class="text-gray-600 mb-4"><c:out value="${hotel.address}"/> | ★★★★☆ <c:out value="${hotel.rating}"/></p>

        <!-- 숙소 이미지 (실제로는 hotel.imageUrl 같은 속성을 사용해야 합니다) -->
        <img src="https://via.placeholder.com/800x400?text=${hotel.name}" alt="<c:out value="${hotel.name}"/> 이미지" class="w-full h-64 object-cover rounded mb-6" />

        <!-- 숙소 설명 (실제로는 hotel.description 같은 속성을 사용해야 합니다) -->
        <section class="mb-6">
          <h2 class="text-xl font-semibold mb-2">숙소 소개</h2>
          <p class="text-gray-700 leading-relaxed">
            <c:out value="${hotel.name}"/>은(는) <c:out value="${hotel.address}"/>에 위치한 멋진 숙소입니다.
            다양한 편의시설을 제공하며 편안한 휴식을 즐기실 수 있습니다. (이 부분은 상세 설명 필드가 필요합니다)
          </p>
        </section>

        <!-- 편의 시설 -->
        <section class="mb-6">
          <h2 class="text-xl font-semibold mb-2">편의 시설</h2>
          <ul class="list-disc pl-6 text-gray-700">
            <c:forEach var="facility" items="${hotel.facilities.split(',')}">
              <li><c:out value="${facility.trim()}"/></li>
            </c:forEach>
            <%-- 만약 facilities가 List<String> 형태라면 아래와 같이 사용 --%>
            <%--
            <c:forEach var="facility" items="${hotel.facilityList}">
              <li><c:out value="${facility}"/></li>
            </c:forEach>
            --%>
          </ul>
        </section>

        <!-- 가격 및 예약 -->
        <section class="border-t pt-4 mt-4 flex justify-between items-center">
          <div>
            <p class="text-red-500 font-bold text-2xl">
              <fmt:formatNumber value="${hotel.pricePerNight}" type="number"/>원
            </p>
            <p class="text-sm text-gray-500">1박 기준</p>
          </div>
          <%-- 예약 페이지로 이동 시 hotelId를 전달할 수 있습니다. --%>
          <button class="bg-red-500 text-white mt-2 px-4 py-1 rounded" onclick="location.href='${pageContext.request.contextPath}/room_select?hotelId=${hotel.id}'">예약하기</button>
        </section>
      </c:when>
      <c:otherwise>
        <p class="text-center text-red-500">숙소 정보를 불러올 수 없습니다. 관리자에게 문의해주세요.</p>
      </c:otherwise>
    </c:choose>

  <!-- 리뷰 및 평점 -->
  <section class="border-t pt-4 mb-6 mt-10">
    <h2 class="text-xl font-semibold mb-2">리뷰 및 평점</h2>

    <!-- 평균 평점 -->
    <div id="average-rating" class="flex items-center mb-4">
      <span class="text-yellow-500 text-2xl mr-2">★★★★☆</span>
      <span class="text-gray-700 font-semibold text-lg">4.5 / 5.0</span>
      <span class="text-sm text-gray-500 ml-2">(총 0개 리뷰)</span>
    </div>

    <!-- 개별 리뷰 -->
    <div id="review-list" class="space-y-4"></div>
  </section>

  <!-- 리뷰 작성 폼 -->
  <section class="mb-6 mt-8">
    <h2 class="text-xl font-semibold mb-2">리뷰 작성하기</h2>
    <form id="review-form" class="space-y-4 bg-gray-100 p-4 rounded">
      <div>
        <label for="name" class="block text-sm font-medium text-gray-700">이름</label>
        <input type="text" id="name" name="name" class="mt-1 block w-full border-gray-300 rounded shadow-sm p-2" required />
      </div>
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-1">평점</label>
        <div id="star-rating" class="flex space-x-1 text-2xl cursor-pointer">
          <span data-value="1" class="star text-gray-400">★</span>
          <span data-value="2" class="star text-gray-400">★</span>
          <span data-value="3" class="star text-gray-400">★</span>
          <span data-value="4" class="star text-gray-400">★</span>
          <span data-value="5" class="star text-gray-400">★</span>
        </div>
        <input type="hidden" name="rating" id="rating" required>
      </div>
      <div>
        <label for="review" class="block text-sm font-medium text-gray-700">리뷰 내용</label>
        <textarea id="review" name="review" rows="4" class="mt-1 block w-full border-gray-300 rounded shadow-sm p-2" required></textarea>
      </div>
      <div class="text-right">
        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">리뷰 등록</button>
      </div>
    </form>
  </section>
  </main>

  <!-- 푸터 -->
  <footer class="mt-12 text-center text-sm text-gray-600 py-4 border-t">
    천안 여행 숙소 예약 시스템 © 2025 | 고객센터: 1588-0000
  </footer>

  <script src="js/accommodation_detail.js"></script>
</body>
</html>
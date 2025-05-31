<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- 가격 포맷팅을 위해 추가 --%>
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
    <form action="${pageContext.request.contextPath}/hotelList" method="get" class="flex w-full justify-center">
      <input type="text" name="keyword" placeholder="지역, 숙소명, 키워드로 검색"
             class="w-1/2 px-4 py-2 border rounded-l-md" value="<c:out value='${param.keyword}'/>" />
      <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded-r-md">검색</button>
    </form>
  </div>

  <!-- 본문 -->
  <div class="flex max-w-7xl mx-auto mt-6 gap-4">


    <!-- 숙소 결과 영역 -->
    <main class="w-full p-4"> 
      <div class="mb-4">
        <h2 class="text-xl font-bold mb-2">검색 결과</h2>
        <p class="text-gray-600">총 <strong>${fn:length(hotelList)}</strong>개의 숙소</p>
      </div>

      <!-- 숙소 반복 출력 -->
      <c:choose>
        <c:when test="${not empty hotelList}">
          <c:forEach var="hotel" items="${hotelList}">
            <div class="bg-white shadow-lg rounded-lg overflow-hidden mb-6 flex flex-col md:flex-row">
              <img src="${not empty hotel.imageUrl ? hotel.imageUrl : 'https://via.placeholder.com/300x200?text=Hotel+Image'}"
                   alt="<c:out value='${hotel.name}'/>" class="w-full md:w-1/3 h-48 md:h-auto object-cover">
              <div class="p-6 flex flex-col justify-between flex-grow">
                <div>
                  <h3 class="text-2xl font-bold text-blue-700 mb-2"><c:out value="${hotel.name}"/></h3>
                  <p class="text-sm text-gray-600 mb-1"><c:out value="${hotel.address}"/></p>
                  <p class="text-yellow-500 mb-1">
                    <c:forEach begin="1" end="${hotel.rating >= 1 ? hotel.rating : 0}" varStatus="loop">★</c:forEach>
                    <c:if test="${hotel.rating % 1 != 0 && hotel.rating > 0}">½</c:if>
                    <c:forEach begin="1" end="${5 - (hotel.rating >= 1 ? (hotel.rating % 1 == 0 ? hotel.rating : hotel.rating + 0.5) : 0)}" varStatus="loop">☆</c:forEach>
                    (<fmt:formatNumber value="${hotel.rating}" maxFractionDigits="1"/>)
                  </p>
                  <p class="text-sm text-gray-600 mb-3 leading-relaxed"><c:out value="${hotel.facilities}"/></p>
                </div>
                <div class="text-right mt-4">
                  <p class="text-red-500 font-bold text-xl mb-2">
                    <fmt:formatNumber value="${hotel.pricePerNight}" type="number"/>원
                  </p>
                  <p class="text-sm text-gray-500 mb-3">1박 기준</p>
                  <div class="flex flex-col sm:flex-row sm:justify-end gap-2">
                    <a href="${pageContext.request.contextPath}/hotelDetail?hotelId=${hotel.id}"
                       class="block w-full sm:w-auto text-center bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded transition duration-150 ease-in-out">
                      상세보기
                    </a>
                    <a href="${pageContext.request.contextPath}/room_select?hotelId=${hotel.id}"
                       class="block w-full sm:w-auto text-center bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded transition duration-150 ease-in-out">
                      예약하기
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <div class="text-center py-10">
            <p class="text-xl text-gray-700">검색 결과에 해당하는 숙소가 없습니다.</p>
            <p class="text-gray-500 mt-2">다른 키워드로 검색해보세요.</p>
          </div>
        </c:otherwise>
      </c:choose>

      <!-- 페이지네이션 (필요시 추가) -->
      <!--
      <div class="mt-8 flex justify-center">
        <nav aria-label="Page navigation">
          <ul class="inline-flex items-center -space-x-px">
            <li>
              <a href="#" class="py-2 px-3 ml-0 leading-tight text-gray-500 bg-white rounded-l-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700">Previous</a>
            </li>
            <li>
              <a href="#" aria-current="page" class="z-10 py-2 px-3 leading-tight text-blue-600 bg-blue-50 border border-blue-300 hover:bg-blue-100 hover:text-blue-700">1</a>
            </li>
            <li>
              <a href="#" class="py-2 px-3 leading-tight text-gray-500 bg-white border border-gray-300 hover:bg-gray-100 hover:text-gray-700">2</a>
            </li>
            <li>
              <a href="#" class="py-2 px-3 leading-tight text-gray-500 bg-white rounded-r-lg border border-gray-300 hover:bg-gray-100 hover:text-gray-700">Next</a>
            </li>
          </ul>
        </nav>
      </div>
      -->
    </main>

  </div>

  <!-- 푸터 -->
  <footer class="mt-12 text-center text-sm text-gray-600 py-4 border-t">
    천안 여행 숙소 예약 시스템 © 2025 | 고객센터: 1588-0000
  </footer>

</body>
</html>

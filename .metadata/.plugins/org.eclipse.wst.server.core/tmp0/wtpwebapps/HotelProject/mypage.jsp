<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 예약 내역</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <!-- 헤더 -->
    <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold mb-6">
        마이페이지
    </header>

    <main class="container mx-auto my-8 p-4">
        <h1 class="text-3xl font-bold mb-6 text-gray-800">
            <c:out value="${userName}"/>님의 예약 내역
        </h1>

        <c:choose>
            <c:when test="${not empty reservationList}">
                <div class="space-y-6">
                    <c:forEach var="reservation" items="${reservationList}">
                        <div class="bg-white rounded-lg shadow-lg overflow-hidden flex flex-col md:flex-row">
                            <img src="${not empty reservation.hotelImageUrl ? reservation.hotelImageUrl : 'https://via.placeholder.com/300x200?text=Hotel+Image'}" 
                                 alt="<c:out value='${reservation.hotelName}'/>" 
                                 class="w-full md:w-1/3 h-48 md:h-auto object-cover">
                            <div class="p-6 flex flex-col justify-between flex-grow">
                                <div>
                                    <h2 class="text-xl font-semibold mb-1 text-blue-700"><c:out value="${reservation.hotelName}"/></h2>
                                    <p class="text-sm text-gray-500 mb-2">객실: <c:out value="${reservation.roomName}"/></p>
                                    
                                    <div class="text-sm text-gray-700 space-y-1 mb-3">
                                        <p><strong>예약 번호:</strong> <c:out value="${reservation.reservationNumber}"/></p>
                                        <p><strong>숙박 기간:</strong> <c:out value="${reservation.stayPeriod}"/></p>
                                        <p><strong>예약일:</strong> <c:out value="${reservation.reservationDate}"/></p>
                                        <p><strong>총 금액:</strong> <fmt:formatNumber value="${reservation.totalPrice}" type="number"/>원</p>
                                        <p><strong>상태:</strong> 
                                            <span class="font-semibold
                                                <c:if test='${reservation.status == "예약완료"}'>text-green-600</c:if>
                                                <c:if test='${reservation.status == "취소됨"}'>text-red-600</c:if>
                                            ">
                                                <c:out value="${reservation.status}"/>
                                            </span>
                                        </p>
                                    </div>
                                </div>
                                <div class="mt-4 flex flex-col sm:flex-row sm:justify-end space-y-2 sm:space-y-0 sm:space-x-3">
                                    <a href="${pageContext.request.contextPath}/hotelDetail?hotelId=${reservation.hotelId}" class="text-center bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded text-sm transition duration-150">
                                        숙소 상세보기
                                    </a>
                                    <c:if test='${reservation.status == "예약완료"}'>
                                        <%-- 예약 취소 기능은 별도 서블릿으로 구현 필요 --%>
                                        <button onclick="alert('예약 취소 기능은 준비 중입니다.\n예약번호: ${reservation.reservationNumber}')" class="text-center bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded text-sm transition duration-150">
                                            예약 취소
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-10 bg-white rounded-lg shadow">
                    <p class="text-xl text-gray-700 mb-4">예약 내역이 없습니다.</p>
                    <a href="${pageContext.request.contextPath}/hotelList" class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded transition duration-150">
                        숙소 둘러보기
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <footer class="text-center mt-12 py-4 text-sm text-gray-600 border-t">
        <p>&copy; 2024 숙소 예약 시스템. 모든 권리 보유.</p>
    </footer>

</body>
</html>
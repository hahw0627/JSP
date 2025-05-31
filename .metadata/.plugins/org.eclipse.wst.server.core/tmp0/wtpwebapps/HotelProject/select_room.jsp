<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- 가격 포맷팅을 위해 추가 --%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>객실 선택</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <!-- 헤더 -->
    <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold">
        <h1>
            <c:choose>
                <c:when test="${not empty hotel}">
                    <c:out value="${hotel.name}"/> - 객실 선택
                </c:when>
                <c:otherwise>
                    객실 선택
                </c:otherwise>
            </c:choose>
        </h1>
    </header>

    <main class="container mx-auto my-8 p-4">
        <c:choose>
            <c:when test="${not empty roomList}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="room" items="${roomList}">
                        <div class="bg-white rounded-lg shadow-lg overflow-hidden">
                            <img src="${not empty room.imageUrl ? room.imageUrl : 'https://via.placeholder.com/300x200?text=Room+Image'}" alt="<c:out value='${room.roomName}'/>" class="w-full h-48 object-cover">
                            <div class="p-6">
                                <h2 class="text-xl font-semibold mb-2 text-blue-700"><c:out value="${room.roomName}"/></h2>
                                <p class="text-gray-600 text-sm mb-1"><strong>가격:</strong> <fmt:formatNumber value="${room.price}" type="number"/>원 / 박</p>
                                <p class="text-gray-600 text-sm mb-1"><strong>최대 인원:</strong> <c:out value="${room.capacity}"/>명</p>
                                <p class="text-gray-700 mb-4 leading-relaxed"><c:out value="${room.description}"/></p>
                                <%-- URL 파라미터 값들을 안전하게 인코딩하기 위해 c:url 태그 사용 --%>
                                <c:url var="reservationUrl" value="/reservation.jsp">
                                    <c:param name="hotelId" value="${hotelId}" />
                                    <c:param name="roomId" value="${room.roomId}" />
                                    <c:param name="roomName" value="${room.roomName}" />
                                    <c:param name="roomPrice" value="${room.price}" />
                                </c:url>
                                <a href="${reservationUrl}" class="block w-full text-center bg-green-500 hover:bg-green-600 text-white font-bold py-2 px-4 rounded transition duration-150">
                                    이 객실 선택
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-10">
                    <p class="text-xl text-gray-700">선택하신 호텔에 현재 예약 가능한 객실이 없습니다.</p>
                    <a href="${pageContext.request.contextPath}/hotelList" class="mt-4 inline-block bg-blue-500 hover:bg-blue-600 text-white font-bold py-2 px-4 rounded">
                        다른 숙소 보기
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <footer class="text-center mt-8 py-4 text-sm text-gray-600 border-t">
        <p>&copy; 2024 숙소 예약 시스템. 모든 권리 보유.</p>
    </footer>

</body>
</html>

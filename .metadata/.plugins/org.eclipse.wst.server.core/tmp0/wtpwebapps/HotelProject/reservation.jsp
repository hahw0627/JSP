<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>숙소 예약</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

    <!-- 헤더 -->
    <header class="bg-blue-600 text-white text-center py-4 text-2xl font-bold">
        <h1>숙소 예약</h1>
    </header>

    <main class="max-w-2xl mx-auto my-8 p-8 bg-white rounded-lg shadow-md">
        <form id="reservation-form">
            <div class="mb-4">
                <label for="name" class="block mb-2 text-sm font-medium text-gray-700">이름</label>
                <input type="text" id="name" name="name" required
                       class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
            </div>
            <div class="mb-4">
                <label for="email" class="block mb-2 text-sm font-medium text-gray-700">이메일</label>
                <input type="email" id="email" name="email" required
                       class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
            </div>
            <div class="mb-4">
                <label for="phone" class="block mb-2 text-sm font-medium text-gray-700">연락처</label>
                <input type="tel" id="phone" name="phone" required
                       class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                <div>
                    <label for="checkin" class="block mb-2 text-sm font-medium text-gray-700">체크인 날짜</label>
                    <input type="date" id="checkin" name="checkin" required
                           class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
                </div>
                <div>
                    <label for="checkout" class="block mb-2 text-sm font-medium text-gray-700">체크아웃 날짜</label>
                    <input type="date" id="checkout" name="checkout" required
                           class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
                </div>
            </div> 
            <div class="mb-4">
                <label for="guests" class="block mb-2 text-sm font-medium text-gray-700">인원 수</label>
                <input type="number" id="guests" name="guests" min="1" required
                       class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
            </div>
            <div class="mb-6">
                <label for="room-type" class="block mb-2 text-sm font-medium text-gray-700">객실 유형</label>
                <select id="room-type" name="room-type"
                        class="w-full p-3 border border-gray-300 rounded-md box-border focus:ring-blue-500 focus:border-blue-500">
                    <option value="standard">스탠다드</option>
                    <option value="deluxe">디럭스</option>
                    <option value="suite">스위트</option>
                </select>
            </div>
            <button type="submit"
                    class="w-full bg-green-500 hover:bg-green-600 text-white font-bold py-3 px-6 rounded-md cursor-pointer text-base">
                예약 확정
            </button>
        </form>
    </main>

    <footer class="text-center mt-8 py-4 text-sm text-gray-600 border-t">
        <p>&copy; 2024 숙소 예약 시스템. 모든 권리 보유.</p>
    </footer>

    <script src="js/reservation.js"></script>
</body>
</html>
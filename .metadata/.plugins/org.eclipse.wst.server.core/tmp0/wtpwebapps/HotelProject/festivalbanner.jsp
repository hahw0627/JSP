<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>천안 지역 축제 배너</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">

  <h2 class="text-2xl font-bold text-center my-10">📅 천안 지역 축제 배너</h2>
  <div class="max-w-5xl mx-auto rounded-xl shadow-lg overflow-hidden">
    <div id="sliderWrapper" class="flex transition-transform duration-500 ease-in-out">
      <!-- 슬라이드 자동 삽입 -->
    </div>
    <div class="absolute top-1/2 transform -translate-y-1/2 w-full flex justify-between">
      <button id="prevBtn" class="bg-black/40 text-white text-3xl p-2 cursor-pointer">
        &#8592;
      </button>
      <button id="nextBtn" class="bg-black/40 text-white text-3xl p-2 cursor-pointer">
        &#8594;
      </button>
    </div>
  </div>

  <script src="js/festival_banner.js"></script>

</body>
</html>
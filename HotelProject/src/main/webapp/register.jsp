<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>회원가입</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

  <div class="bg-white shadow-md rounded px-8 py-10 w-full max-w-md">
    <h2 class="text-2xl font-bold text-center mb-6 text-blue-600">회원가입</h2>

    <%-- 실제 서버로 데이터를 전송하려면 action과 method를 설정해야 합니다. --%>
    <%-- 예: <form id="register-form" action="registerProcess.do" method="post"> --%>
    <form id="register-form">
      <div class="mb-4">
        <label class="block text-gray-700 font-medium mb-1" for="name">이름</label>
        <input type="text" id="name" name="name" class="w-full px-4 py-2 border rounded-md" placeholder="홍길동" required>
      </div>

      <div class="mb-4">
        <label class="block text-gray-700 font-medium mb-1" for="email">이메일</label>
        <input type="email" id="email" name="email" class="w-full px-4 py-2 border rounded-md" placeholder="example@email.com" required>
      </div>

      <div class="mb-4">
        <label class="block text-gray-700 font-medium mb-1" for="phone">전화번호</label>
        <input type="tel" id="phone" name="phone" class="w-full px-4 py-2 border rounded-md" placeholder="010-1234-5678" required>
      </div>

      <div class="mb-4">
        <label class="block text-gray-700 font-medium mb-1" for="password">비밀번호</label>
        <input type="password" id="password" name="password" class="w-full px-4 py-2 border rounded-md" required>
      </div>

      <div class="mb-6">
        <label class="block text-gray-700 font-medium mb-1" for="confirm-password">비밀번호 확인</label>
        <input type="password" id="confirm-password" name="confirmPassword" class="w-full px-4 py-2 border rounded-md" required>
      </div>

      <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded-md font-semibold hover:bg-blue-700 transition">
        가입하기
      </button>
    </form>

    <p class="mt-4 text-center text-sm text-gray-600">
      이미 계정이 있으신가요? <a href="index.jsp" class="text-blue-500 underline">로그인</a> <%-- index.html -> login.jsp (또는 실제 로그인 페이지 경로) --%>
    </p>
  </div>

  <script src="js/register.js"></script>
</body>
</html>
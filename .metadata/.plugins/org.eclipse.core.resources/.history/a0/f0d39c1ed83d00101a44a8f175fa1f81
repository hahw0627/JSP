<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 - 천안 여행 정보</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 flex items-center justify-center min-h-screen">

    <div class="bg-white shadow-md rounded-lg px-8 py-10 w-full max-w-md">
        <h2 class="text-2xl font-bold text-center mb-8 text-blue-600">로그인</h2>

        <%--
            실제 로그인 처리를 위해서는 form의 action 속성에 로그인 서블릿 경로를 지정해야 합니다.
            예: <form action="${pageContext.request.contextPath}/loginProcess" method="post">
        --%>
        <form action="${pageContext.request.contextPath}/loginProcess" method="post">
            <div class="mb-4">
                <label class="block text-gray-700 font-medium mb-2" for="email">
                    이메일
                </label>
                <input class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       id="email" name="email" type="email" placeholder="your@email.com" required>
            </div>
            <div class="mb-6">
                <label class="block text-gray-700 font-medium mb-2" for="password">
                    비밀번호
                </label>
                <input class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                       id="password" name="password" type="password" placeholder="********" required>
                <%-- <p class="text-right text-xs text-gray-500 mt-1">비밀번호를 잊으셨나요?</p> --%>
            </div>
            <button type="submit"
                    class="w-full bg-blue-600 text-white py-2.5 px-4 rounded-md font-semibold hover:bg-blue-700 transition duration-200 ease-in-out">
                로그인
            </button>
        </form>
        <p class="mt-8 text-center text-sm text-gray-600">
            계정이 없으신가요? <a href="${pageContext.request.contextPath}/register.jsp" class="text-blue-500 hover:text-blue-700 hover:underline font-medium">회원가입</a>
        </p>
    </div>
</body>
</html>

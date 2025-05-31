package controler;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 로그인 처리를 담당하는 서블릿입니다.
 * index.jsp에서 로그인 폼이 제출되면 이 서블릿이 호출됩니다.
 */
@WebServlet("/loginProcess") // index.jsp의 form action과 일치해야 합니다.
public class LoginProcessServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 임시 사용자 정보 (실제로는 DB에서 조회해야 합니다)
    private static final String VALID_EMAIL = "test@example.com";
    private static final String VALID_PASSWORD = "password123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // POST 요청 시 한글 깨짐 방지

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 간단한 임시 인증 로직
        if (VALID_EMAIL.equals(email) && VALID_PASSWORD.equals(password)) {
            // 로그인 성공
            HttpSession session = request.getSession(); // 세션 생성 또는 기존 세션 가져오기
            session.setAttribute("loggedInUserEmail", email); // 세션에 사용자 정보 저장 (예시)
            session.setAttribute("loggedInUserName", "테스트유저"); // 세션에 사용자 이름 저장 (예시)

            // 로그인 성공 후 호텔 목록 페이지로 리다이렉트
            // System.out.println("로그인 성공: " + email); // 디버깅용
            response.sendRedirect(request.getContextPath() + "/hotelList"); // HotelListServlet 경로로 변경 권장

        } else {
            // 로그인 실패
            request.setAttribute("loginError", "이메일 또는 비밀번호가 올바르지 않습니다.");

            // 로그인 실패 시 다시 로그인 페이지(index.jsp)로 포워드
            // System.out.println("로그인 실패: " + email); // 디버깅용
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    /**
     * GET 요청은 일반적으로 로그인 폼을 보여주는 페이지로 보내거나,
     * 여기서는 특별한 처리를 하지 않고 POST와 동일하게 처리하거나 에러 처리할 수 있습니다.
     * 간단히 POST로 넘기도록 하겠습니다.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // GET 요청으로 직접 /loginProcess 접근 시 로그인 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
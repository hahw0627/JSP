package controler;


import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.HotelDTO;

//"/hotelList" URL 요청을 이 서블릿이 처리하도록 매핑합니다.
@WebServlet("/hotelList")
public class HotelListServlet extends HttpServlet {
 private static final long serialVersionUID = 1L;

 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     System.out.println("HotelListServlet 호출됨! 키워드: " + request.getParameter("keyword")); // 디버깅 메시지 추가
     // 1. 요청 파라미터 확인 (예: 검색어)
     String keyword = request.getParameter("keyword");
     if (keyword != null && !keyword.trim().isEmpty()) {
         System.out.println("검색어: " + keyword);
         // TODO: 실제로는 keyword를 사용하여 DB에서 검색하는 로직이 필요합니다.
     }

     // 2. 숙소 목록 데이터 생성 (지금은 임시 데이터 사용)
     List<HotelDTO> hotelList = new ArrayList<>();
     // HotelDTO 생성자에 imageUrl 인자 추가 및 필드명 일치 (name, pricePerNight)
     hotelList.add(new HotelDTO("H001", "천안 럭셔리 호텔", "천안시 동남구 신부동 123-45", 4.8, "수영장, 조식, Wifi, 피트니스 센터", 200000, "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"));
     hotelList.add(new HotelDTO("H002", "아늑한 천안 펜션", "천안시 서북구 두정동 678-90", 4.5, "바베큐, 주차장, 개별 테라스", 120000, "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"));
     hotelList.add(new HotelDTO("H003", "비즈니스 호텔 천안", "천안시 동남구 원성동 11-22", 4.2, "회의실, Wifi, 비즈니스 센터", 150000, "https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGhvdGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"));
     hotelList.add(new HotelDTO("H004", "에메랄드 오션 리조트 (예시)", "제주도 서귀포시 중문동 777", 4.7, "바다 전망 객실, 실외 수영장, 무료 조식", 250000, "https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fGhvdGVsJTIwcmVzb3J0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"));
     hotelList.add(new HotelDTO("H005", "한옥 체험 마을", "전주시 완산구 교동", 4.3, "온돌방, 한복 체험, 전통차", 100000, "https://images.unsplash.com/photo-1568495048034-e648c300911e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8M3x8aGFub2slMjBob3RlbHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60"));

     // ... 더 많은 임시 데이터 추가 가능
     // 예시:
     // hotelList.add(new HotelDTO("H004", "제주 힐링 리조트", "제주시 애월읍", 4.9, "오션뷰, 스파, 인피니티풀", 300000, "https://via.placeholder.com/300x200?text=Jeju+Resort"));

     // 만약 검색 기능이 있다면, 검색 결과에 따라 hotelList를 필터링해야 합니다.
     // 현재는 모든 호텔을 보여줍니다.
     if (keyword != null && !keyword.trim().isEmpty()) {
         // 실제로는 DB 쿼리에서 LIKE 등을 사용하겠지만, 여기서는 간단히 이름에 포함되는지 확인
         // List<HotelDTO> filteredList = hotelList.stream()
         // .filter(hotel -> hotel.getName().toLowerCase().contains(keyword.toLowerCase()) || hotel.getAddress().toLowerCase().contains(keyword.toLowerCase()))
         // .collect(Collectors.toList());
         // request.setAttribute("hotelList", filteredList);
     } else {
        request.setAttribute("hotelList", hotelList);
     }

     // 3. JSP로 전달할 데이터를 request 객체에 속성으로 저장
     // request.setAttribute("hotelList", hotelList); // 위에서 조건부로 설정하도록 변경

     // 4. hotel_list.jsp 페이지로 포워딩
     RequestDispatcher dispatcher = request.getRequestDispatcher("/hotel_list.jsp"); // 실제 JSP 파일 경로
     dispatcher.forward(request, response);
 }

 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     // POST 요청도 GET과 동일하게 처리 (검색 폼이 GET 방식이므로 주로 doGet 사용)
     doGet(request, response);
 }
}

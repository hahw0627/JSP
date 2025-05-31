package controler;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dto.HotelDTO; // 호텔 정보를 가져오기 위해 필요할 수 있음
import dto.RoomDTO;

@WebServlet("/room_select") // URL 매핑을 "/room_select"로 유지합니다.
public class SelectRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // 임시 호텔 데이터 (HotelDetailServlet 또는 HotelService에서 가져오는 것이 이상적)
    // 실제 애플리케이션에서는 이 데이터가 DB에서 조회됩니다.
    private List<HotelDTO> getMockHotelData() {
        List<HotelDTO> hotelList = new ArrayList<>();
        // HotelDTO 생성 시 imageUrl을 포함한 7개 인자를 사용합니다.
        hotelList.add(new HotelDTO("H001", "천안 럭셔리 호텔", "천안시 동남구 신부동 123-45", 4.8, "수영장, 조식, Wifi, 피트니스 센터", 200000, "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"));
        hotelList.add(new HotelDTO("H002", "아늑한 천안 펜션", "천안시 서북구 두정동 678-90", 4.5, "바베큐, 주차장, 개별 테라스", 120000, "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Nnx8aG90ZWx8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"));
        hotelList.add(new HotelDTO("H003", "비즈니스 호텔 천안", "천안시 동남구 원성동 11-22", 4.2, "회의실, Wifi, 비즈니스 센터", 150000, "https://images.unsplash.com/photo-1582719508461-905c673771fd?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTB8fGhvdGVsfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"));
        hotelList.add(new HotelDTO("H004", "에메랄드 오션 리조트 (예시)", "제주도 서귀포시 중문동 777", 4.7, "바다 전망 객실, 실외 수영장, 무료 조식", 250000, "https://images.unsplash.com/photo-1590073242678-70ee3fc28e8e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fGhvdGVsJTIwcmVzb3J0fGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60"));
        return hotelList;
    }

    // 임시 객실 데이터 생성 로직
    private List<RoomDTO> getMockRoomsForHotel(String hotelId) {
        List<RoomDTO> rooms = new ArrayList<>();
        if (hotelId == null || hotelId.isEmpty()) {
            return rooms; // 호텔 ID가 없으면 빈 목록 반환
        }

        // 호텔 ID에 따라 다른 객실 목록을 반환 (예시)
        // 실제로는 DB에서 해당 hotelId의 객실들을 조회해야 합니다.
        if ("H001".equals(hotelId) || "H004".equals(hotelId)) { // 럭셔리 호텔 또는 에메랄드 리조트
            rooms.add(new RoomDTO("R001", "스탠다드 룸", 180000, "아늑한 스탠다드 객실입니다.", 2, "https://via.placeholder.com/300x200?text=Standard+Room"));
            rooms.add(new RoomDTO("R002", "디럭스 룸", 250000, "넓고 편안한 디럭스 객실입니다.", 2, "https://via.placeholder.com/300x200?text=Deluxe+Room"));
            rooms.add(new RoomDTO("R003", "스위트 룸", 350000, "최고급 스위트 객실에서 특별한 경험을 하세요.", 4, "https://via.placeholder.com/300x200?text=Suite+Room"));
        } else if ("H002".equals(hotelId)) { // 펜션
            rooms.add(new RoomDTO("R101", "커플룸", 120000, "연인을 위한 아늑한 객실입니다.", 2, "https://via.placeholder.com/300x200?text=Couple+Room"));
            rooms.add(new RoomDTO("R102", "패밀리룸", 180000, "가족 여행에 적합한 넓은 객실입니다.", 4, "https://via.placeholder.com/300x200?text=Family+Room"));
        } else { // 기타 호텔 (기본 객실)
            rooms.add(new RoomDTO("R201", "기본 객실", 150000, "편안한 기본 객실입니다.", 2, "https://via.placeholder.com/300x200?text=Basic+Room"));
        }
        return rooms;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String hotelId = request.getParameter("hotelId");
        
        // 호텔 정보 가져오기 (선택 사항, 호텔 이름을 표시하고 싶다면)
        if (hotelId != null && !hotelId.isEmpty()) {
            Optional<HotelDTO> hotelOptional = getMockHotelData().stream()
                                                .filter(h -> hotelId.equals(h.getId()))
                                                .findFirst();
            if (hotelOptional.isPresent()) {
                request.setAttribute("hotel", hotelOptional.get());
            } else {
                 System.out.println("SelectRoomServlet: Hotel not found for ID: " + hotelId);
            }
        }

        List<RoomDTO> rooms = getMockRoomsForHotel(hotelId);
        request.setAttribute("roomList", rooms);
        request.setAttribute("hotelId", hotelId); // reservation.jsp로 넘기기 위해 hotelId도 전달

        // 포워딩할 JSP 파일 이름을 정확히 지정합니다.
        RequestDispatcher dispatcher = request.getRequestDispatcher("/select_room.jsp");
        dispatcher.forward(request, response);
    }
}

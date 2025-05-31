package dto;

public class ReservationDTO {
    private String reservationNumber;
    private String userId; // 어떤 사용자의 예약인지 식별
    private String hotelId;
    private String hotelName;
    private String hotelImageUrl; // 호텔 대표 이미지
    private String roomId;
    private String roomName;
    private String checkInDate;
    private String checkOutDate;
    private int totalPrice;
    private String reservationDate; // 예약한 날짜
    private String status; // 예약 상태 (예: "예약완료", "취소됨")

    public ReservationDTO(String reservationNumber, String userId, String hotelId, String hotelName, String hotelImageUrl, String roomId, String roomName, String checkInDate, String checkOutDate, int totalPrice, String reservationDate, String status) {
        this.reservationNumber = reservationNumber;
        this.userId = userId;
        this.hotelId = hotelId;
        this.hotelName = hotelName;
        this.hotelImageUrl = hotelImageUrl;
        this.roomId = roomId;
        this.roomName = roomName;
        this.checkInDate = checkInDate;
        this.checkOutDate = checkOutDate;
        this.totalPrice = totalPrice;
        this.reservationDate = reservationDate;
        this.status = status;
    }

    // Getters
    public String getReservationNumber() { return reservationNumber; }
    public String getUserId() { return userId; }
    public String getHotelId() { return hotelId; }
    public String getHotelName() { return hotelName; }
    public String getHotelImageUrl() { return hotelImageUrl; }
    public String getRoomId() { return roomId; }
    public String getRoomName() { return roomName; }
    public String getCheckInDate() { return checkInDate; }
    public String getCheckOutDate() { return checkOutDate; }
    public int getTotalPrice() { return totalPrice; }
    public String getReservationDate() { return reservationDate; }
    public String getStatus() { return status; }

    // Setters (필요에 따라 추가)
    public void setReservationNumber(String reservationNumber) { this.reservationNumber = reservationNumber; }
    public void setUserId(String userId) { this.userId = userId; }
    public void setHotelId(String hotelId) { this.hotelId = hotelId; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }
    public void setHotelImageUrl(String hotelImageUrl) { this.hotelImageUrl = hotelImageUrl; }
    public void setRoomId(String roomId) { this.roomId = roomId; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }
    public void setTotalPrice(int totalPrice) { this.totalPrice = totalPrice; }
    public void setReservationDate(String reservationDate) { this.reservationDate = reservationDate; }
    public void setStatus(String status) { this.status = status; }

    /**
     * JSP에서 ${reservation.stayPeriod} 형태로 쉽게 사용하기 위한 편의 메소드
     * @return "YYYY-MM-DD ~ YYYY-MM-DD" 형식의 문자열
     */
    public String getStayPeriod() {
        if (checkInDate != null && !checkInDate.isEmpty() && checkOutDate != null && !checkOutDate.isEmpty()) {
            return checkInDate + " ~ " + checkOutDate;
        }
        return "기간 정보 없음";
    }
}
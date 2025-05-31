package dto;

public class RoomDTO {
    private String roomId;
    private String roomName;
    private int price;
    private String description;
    private int capacity;
    private String imageUrl; // 객실 이미지 URL (선택 사항)

    public RoomDTO(String roomId, String roomName, int price, String description, int capacity, String imageUrl) {
        this.roomId = roomId;
        this.roomName = roomName;
        this.price = price;
        this.description = description;
        this.capacity = capacity;
        this.imageUrl = imageUrl;
    }

    public String getRoomId() {
        return roomId;
    }

    public void setRoomId(String roomId) {
        this.roomId = roomId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getCapacity() { return capacity; }

    public void setCapacity(int capacity) { this.capacity = capacity; }

    public String getImageUrl() { return imageUrl; }

    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
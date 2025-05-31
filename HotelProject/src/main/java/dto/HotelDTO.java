package dto;

public class HotelDTO {
    private String id;
    private String name; // 기존 title에서 name으로 변경 (일관성을 위해)
    private String address;
    private double rating;
    private String facilities;
    private int pricePerNight; // 기존 price에서 pricePerNight로 변경 (의미 명확화)
    private String imageUrl;   // 이미지 URL 필드 추가

    public HotelDTO(String id, String name, String address, double rating, String facilities, int pricePerNight, String imageUrl) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.rating = rating;
        this.facilities = facilities;
        this.pricePerNight = pricePerNight;
        this.imageUrl = imageUrl; // 생성자에서 imageUrl 초기화
    }

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public String getFacilities() {
        return facilities;
    }

    public void setFacilities(String facilities) {
        this.facilities = facilities;
    }

    public int getPricePerNight() {
        return pricePerNight;
    }

    public void setPricePerNight(int pricePerNight) {
        this.pricePerNight = pricePerNight;
    }

    public String getImageUrl() { // imageUrl getter 추가
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) { // imageUrl setter 추가
        this.imageUrl = imageUrl;
    }
}
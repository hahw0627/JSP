package dto;

public class UserDTO {
    private String userId;
    private String password; // 실제 사용 시에는 해시된 비밀번호를 저장해야 합니다.
    private String name;
    private String email;
    // 기타 필요한 사용자 정보 필드들 (연락처, 가입일 등)

    public UserDTO(String userId, String password, String name, String email) {
        this.userId = userId;
        this.password = password;
        this.name = name;
        this.email = email;
    }

    // Getters
    public String getUserId() {
        return userId;
    }

    public String getPassword() {
        return password;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    // Setters
    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setPassword(String password) {
        this.password = password; // 실제 사용 시에는 해시화된 비밀번호를 저장하고, 변경 시에도 해시화 필요
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

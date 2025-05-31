document.addEventListener('DOMContentLoaded', function () {
    const registerForm = document.getElementById('register-form');

    if (registerForm) {
        registerForm.addEventListener('submit', function(event) {
            // 기본 폼 제출 방지 (서버로 바로 전송되는 것을 막음)
            // 실제 서버로 전송하기 전에 유효성 검사를 수행합니다.
            // 유효성 검사 실패 시 event.preventDefault()를 호출하여 제출을 막을 수 있습니다.
            // 여기서는 간단한 예시로 항상 제출을 시도하도록 둡니다.
            // 실제로는 아래 주석 처리된 부분처럼 유효성 검사를 추가해야 합니다.

            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirm-password').value;

            if (!name || !email || !phone || !password || !confirmPassword) {
                alert('모든 필수 항목을 입력해주세요.');
                event.preventDefault(); // 폼 제출 방지
                return;
            }

            // 이메일 형식 검사 (간단한 정규식)
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                alert('올바른 이메일 주소를 입력해주세요.');
                event.preventDefault();
                return;
            }

            if (password !== confirmPassword) {
                alert('비밀번호가 일치하지 않습니다.');
                event.preventDefault(); // 폼 제출 방지
                return;
            }

            // 여기에 추가적인 유효성 검사 로직을 넣을 수 있습니다.
            // (예: 비밀번호 길이, 전화번호 형식 등)

            console.log('회원가입 폼 유효성 검사 통과 (클라이언트 측). 서버로 제출합니다.');
            // 유효성 검사를 통과하면 폼이 action에 지정된 URL로 제출됩니다.
        });
    }
});
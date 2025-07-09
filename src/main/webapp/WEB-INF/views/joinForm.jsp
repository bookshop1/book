<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원가입 | BookShop</title>
    <!-- 구글 폰트 및 아이콘 -->
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css">
   <style>
    body {
        margin: 0;
        min-height: 100vh;
        background: linear-gradient(120deg, #e8f0fe 0%, #ffffff 100%);
        font-family: 'Roboto', 'Noto Sans KR', Arial, sans-serif;
        display: flex;
        align-items: center;
        justify-content: center;
        position: relative;
        overflow: hidden;
    }
    .book-bg {
        position: absolute;
        right: 0;
        bottom: 0;
        width: 530px;
        opacity: 0.12;
        z-index: 0;
        pointer-events: none;
        user-select: none;
    }
    .signup-container {
        background: #fff;
        width: 430px;
        padding: 46px 44px 38px 44px;
        border-radius: 18px;
        box-shadow: 0 12px 40px rgba(52, 112, 219, 0.13);
        display: flex;
        flex-direction: column;
        align-items: center;
        z-index: 1;
        animation: fadeIn 0.9s;
    }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(40px);}
        to { opacity: 1; transform: translateY(0);}
    }
    .logo {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }
    .logo i {
        font-size: 34px;
        color: #357ae1;
        margin-right: 10px;
    }
    .logo span {
        font-size: 1.85rem;
        font-weight: 700;
        color: #357ae1;
        letter-spacing: 1px;
    }
    .signup-container h2 {
        font-weight: 700;
        font-size: 1.7rem;
        color: #222;
        margin-bottom: 30px;
        margin-top: 8px;
        text-align: center;
        letter-spacing: 0.5px;
    }
    .signup-form { width: 100%; }
    .input-group { position: relative; margin-bottom: 26px; }
    .input-group label {
        font-size: 14px; color: #444; font-weight: 500; margin-bottom: 6px; display: block;
    }
    .input-group .required { color: #e74c3c; margin-left: 3px; }
    .input-group .input-icon {
        position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
        color: #b0b8c1; font-size: 20px;
    }
    .input-group input {
        width: 100%; padding: 13px 14px 13px 44px; border: 1.5px solid #d6e0ea;
        border-radius: 8px; font-size: 16px; color: #2d3a4b; background: #f9fbfd;
        outline: none; transition: border-color 0.25s, box-shadow 0.25s; font-family: inherit;
    }
    .input-group input:focus {
        border-color: #357ae1; background: #fff;
        box-shadow: 0 2px 8px rgba(53,122,225,0.10);
    }
    .input-group input::placeholder { color: #b5bfc7; font-size: 15px; }
    .input-group .msg {
        color: #e67e22; font-size: 13px; margin-top: 5px; display: none; padding-left: 2px;
    }
    .input-group .subtext {
        color: #8c98a4; font-size: 12px; margin-top: 3px; margin-left: 2px;
    }
    .submit-btn {
        width: 100%; padding: 15px 0;
        background: linear-gradient(90deg, #357ae1 0%, #5ab2fa 100%);
        border: none; border-radius: 8px; font-size: 18px; font-weight: 700; color: #fff;
        cursor: pointer; margin-top: 8px;
        box-shadow: 0 4px 16px rgba(53,122,225,0.13);
        transition: background 0.2s, box-shadow 0.2s;
    }
    .submit-btn:hover {
        background: linear-gradient(90deg, #2356a7 0%, #357ae1 100%);
        box-shadow: 0 6px 20px rgba(33,86,167,0.16);
    }
    .signup-footer {
        margin-top: 18px; text-align: center; color: #666; font-size: 14px;
    }
    .signup-footer a {
        color: #357ae1; text-decoration: none; font-weight: 500; margin-left: 4px;
    }
    @media (max-width: 600px) {
        .signup-container { width: 100%; padding: 24px 6px; border-radius: 0; box-shadow: none; }
        .book-bg { width: 100vw; }
    }
</style>

    <script>
        function showMsg(inputId, msgId) {
            var input = document.getElementById(inputId);
            var msg = document.getElementById(msgId);
            input.onfocus = function() { msg.style.display = 'block'; }
            input.onblur = function() { msg.style.display = 'none'; }
        }

        // 폼 제출 시 필수 입력값 검사
        function validateForm(e) {
            var requiredFields = ['id', 'password', 'address', 'email', 'num'];
            for (var i = 0; i < requiredFields.length; i++) {
                var el = document.getElementById(requiredFields[i]);
                if (!el.value.trim()) {
                    alert('회원가입을 진행해주세요.');
                    el.focus();
                    e.preventDefault();
                    return false;
                }
            }
            return true;
        }

        window.onload = function() {
            showMsg('id', 'msg-id');
            showMsg('password', 'msg-password');
            showMsg('address', 'msg-address');
            showMsg('email', 'msg-email');
            showMsg('num', 'msg-num');
            // 폼 제출 이벤트에 검사 함수 연결
            document.getElementById('signupForm').onsubmit = validateForm;
        }
    </script>
</head>
<body>
    <!-- 책장 일러스트 ... -->
    <img class="book-bg" src="/images/bookshelf.svg" alt="bookshelf background" />
    <div class="signup-container">
        <div class="logo">
            <i class="ri-book-open-line"></i>
            <span>BookShop</span>
        </div>
        <h2>회원가입</h2>
        <form id="signupForm" class="signup-form" action="/join/register" method="post" autocomplete="off" novalidate>
            <div class="input-group">
                <label for="id">아이디 <span class="required">*</span></label>
                <i class="ri-user-3-line input-icon"></i>
                <input class="form-input" type="text" name="id" id="id" placeholder="아이디를 입력하세요" maxlength="20">
                <div class="msg" id="msg-id">아이디를 입력해주세요.</div>
                <div class="subtext">영문/숫자 4~20자</div>
            </div>
            <div class="input-group">
                <label for="password">비밀번호 <span class="required">*</span></label>
                <i class="ri-lock-password-line input-icon"></i>
                <input class="form-input" type="password" name="password" id="password" placeholder="비밀번호를 입력하세요" minlength="6" maxlength="30">
                <div class="msg" id="msg-password">비밀번호를 입력해주세요.</div>
                <div class="subtext">영문, 숫자, 특수문자 포함 6자 이상</div>
            </div>
            <div class="input-group">
                <label for="address">주소 <span class="required">*</span></label>
                <i class="ri-map-pin-line input-icon"></i>
                <input class="form-input" type="text" name="address" id="address" placeholder="주소를 입력하세요" maxlength="100">
                <div class="msg" id="msg-address">주소를 입력해주세요.</div>
            </div>
            <div class="input-group">
                <label for="email">이메일 <span class="required">*</span></label>
                <i class="ri-mail-line input-icon"></i>
                <input class="form-input" type="email" name="email" id="email" placeholder="예: example@domain.com" maxlength="50">
                <div class="msg" id="msg-email">이메일을 입력해주세요.</div>
            </div>
            <div class="input-group">
                <label for="num">휴대전화 <span class="required">*</span></label>
                <i class="ri-phone-line input-icon"></i>
                <input class="form-input" type="tel" name="num" id="num" placeholder="숫자만 입력하세요" pattern="[0-9]{9,15}" maxlength="15">
                <div class="msg" id="msg-num">휴대전화 번호를 입력해주세요.</div>
            </div>
            <button type="submit" class="submit-btn">가입하기</button>
        </form>
        <div class="signup-footer">
            이미 회원이신가요?
            <a href="/login">로그인</a>
        </div>
    </div>
</body>
</html>

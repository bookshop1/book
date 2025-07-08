<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>회원가입</title>
    <style>
        /* Reset & 기본 스타일 */
        * {
            box-sizing: border-box;
        }
        body {
            margin: 0;
            font-family: 'Noto Sans KR', '맑은 고딕', Arial, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        /* 컨테이너 */
        .signup-container {
            background: #fff;
            width: 420px;
            padding: 40px 50px;
            border-radius: 12px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.1);
            transition: box-shadow 0.3s ease;
        }
        .signup-container:hover {
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        /* 제목 */
        .signup-container h2 {
            margin: 0 0 30px;
            font-weight: 700;
            font-size: 28px;
            color: #333;
            text-align: center;
            letter-spacing: 1px;
        }
        /* 라벨 */
        label.form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #555;
            font-size: 14px;
        }
        /* 필수 표시 */
        .required {
            color: #e74c3c;
            margin-left: 4px;
        }
        /* 입력창 */
        input.form-input {
            width: 100%;
            padding: 14px 16px;
            margin-bottom: 24px;
            border: 1.8px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            color: #333;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
            outline: none;
            font-weight: 500;
        }
        input.form-input::placeholder {
            color: #aaa;
            font-weight: 400;
        }
        input.form-input:focus {
            border-color: #3498db;
            box-shadow: 0 0 8px rgba(52, 152, 219, 0.4);
        }
        /* 안내 메시지 */
        .msg {
            color: #e67e22;
            font-size: 13px;
            margin-top: -18px;
            margin-bottom: 18px;
            display: none;
        }
        /* 제출 버튼 */
        .submit-btn {
            width: 100%;
            padding: 16px 0;
            background: #3498db;
            border: none;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 700;
            color: white;
            cursor: pointer;
            box-shadow: 0 6px 15px rgba(52, 152, 219, 0.4);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .submit-btn:hover {
            background: #217dbb;
            box-shadow: 0 8px 20px rgba(33, 125, 187, 0.6);
        }
        /* 반응형 */
        @media (max-width: 480px) {
            .signup-container {
                width: 100%;
                padding: 30px 20px;
                border-radius: 0;
                box-shadow: none;
            }
        }
    </style>
    <script>
        // 간단한 포커스 시 안내 메시지 표시 스크립트
        function showMsg(inputId, msgId) {
            var input = document.getElementById(inputId);
            var msg = document.getElementById(msgId);
            input.onfocus = function() { msg.style.display = 'block'; }
            input.onblur = function() { msg.style.display = 'none'; }
        }
        window.onload = function() {
            showMsg('id', 'msg-id');
            showMsg('password', 'msg-password');
            showMsg('address', 'msg-address');
            showMsg('email', 'msg-email');
            showMsg('num', 'msg-num');
        }
    </script>
</head>
<body>
<div class="signup-container">
    <h2>회원가입</h2>
    <form action="/join/register" method="post" autocomplete="off" novalidate>
        <label class="form-label" for="id">아이디 <span class="required">*</span></label>
        <input class="form-input" type="text" name="id" id="id" placeholder="아이디를 입력하세요" required>
        <div class="msg" id="msg-id">아이디를 입력해주세요.</div>

        <label class="form-label" for="password">비밀번호 <span class="required">*</span></label>
        <input class="form-input" type="password" name="password" id="password" placeholder="비밀번호를 입력하세요" required>
        <div class="msg" id="msg-password">비밀번호를 입력해주세요.</div>

        <label class="form-label" for="address">주소 <span class="required">*</span></label>
        <input class="form-input" type="text" name="address" id="address" placeholder="주소를 입력하세요" required>
        <div class="msg" id="msg-address">주소를 입력해주세요.</div>

        <label class="form-label" for="email">이메일 <span class="required">*</span></label>
        <input class="form-input" type="email" name="email" id="email" placeholder="예: example@domain.com" required>
        <div class="msg" id="msg-email">이메일을 입력해주세요.</div>

        <label class="form-label" for="num">휴대전화 <span class="required">*</span></label>
        <input class="form-input" type="tel" name="num" id="num" placeholder="숫자만 입력하세요" pattern="[0-9]{9,15}" required>
        <div class="msg" id="msg-num">휴대전화 번호를 입력해주세요.</div>

        <input class="submit-btn" type="submit" value="가입하기">
    </form>
</div>
</body>
</html>

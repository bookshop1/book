<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>로그인 | BookShop</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css">
    <style>
        /* ... (기존 스타일 그대로) ... */
        body { margin: 0; min-height: 100vh; background: linear-gradient(120deg, #e8f0fe 0%, #ffffff 100%); font-family: 'Roboto', 'Noto Sans KR', Arial, sans-serif; display: flex; align-items: center; justify-content: center; position: relative; overflow: hidden; }
        .book-bg { position: absolute; right: 0; bottom: 0; width: 530px; opacity: 0.12; z-index: 0; pointer-events: none; user-select: none; }
        .login-container { background: #fff; width: 430px; padding: 46px 44px 38px 44px; border-radius: 18px; box-shadow: 0 12px 40px rgba(52, 112, 219, 0.13); display: flex; flex-direction: column; align-items: center; z-index: 1; animation: fadeIn 0.9s; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(40px);} to { opacity: 1; transform: translateY(0);} }
        .logo { display: flex; align-items: center; margin-bottom: 10px; }
        .logo i { font-size: 34px; color: #357ae1; margin-right: 10px; }
        .logo span { font-size: 1.85rem; font-weight: 700; color: #357ae1; letter-spacing: 1px; }
        .login-container h2 { font-weight: 700; font-size: 1.7rem; color: #222; margin-bottom: 30px; margin-top: 8px; text-align: center; letter-spacing: 0.5px; }
        .login-form { width: 100%; }
        .input-group { position: relative; margin-bottom: 26px; }
        .input-group label { font-size: 14px; color: #444; font-weight: 500; margin-bottom: 6px; display: block; }
        .input-group .required { color: #e74c3c; margin-left: 3px; }
        .input-group .input-icon { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: #b0b8c1; font-size: 20px; }
        .input-group input { width: 100%; padding: 13px 14px 13px 44px; border: 1.5px solid #d6e0ea; border-radius: 8px; font-size: 16px; color: #2d3a4b; background: #f9fbfd; outline: none; transition: border-color 0.25s, box-shadow 0.25s; font-family: inherit; }
        .input-group input:focus { border-color: #357ae1; background: #fff; box-shadow: 0 2px 8px rgba(53,122,225,0.10); }
        .input-group input::placeholder { color: #b5bfc7; font-size: 15px; }
        .login-btn { width: 100%; padding: 15px 0; background: linear-gradient(90deg, #357ae1 0%, #5ab2fa 100%); border: none; border-radius: 8px; font-size: 18px; font-weight: 700; color: #fff; cursor: pointer; margin-top: 8px; box-shadow: 0 4px 16px rgba(53,122,225,0.13); transition: background 0.2s, box-shadow 0.2s; }
        .login-btn:hover { background: linear-gradient(90deg, #2356a7 0%, #357ae1 100%); box-shadow: 0 6px 20px rgba(33,86,167,0.16); }
        .login-footer { margin-top: 18px; text-align: center; color: #666; font-size: 14px; }
        .login-footer a { color: #357ae1; text-decoration: none; font-weight: 500; margin-left: 4px; }
        .alert { width: 100%; margin: 0 0 18px 0; padding: 12px 18px; border-radius: 8px; background: #ffeaea; color: #e74c3c; font-size: 15px; text-align: center; }
        @media (max-width: 600px) { .login-container { width: 100%; padding: 24px 6px; border-radius: 0; box-shadow: none; } .book-bg { width: 100vw; } }
    </style>
    <script>
        window.onload = function() {
            // 로그인 실패 시 아이디 입력란에 포커스
            <c:if test="${not empty errorMsg}">
                document.getElementById('username').focus();
            </c:if>
        }
    </script>
</head>
<body>
    <img class="book-bg" src="/images/bookshelf.svg" alt="bookshelf background" />
    <div class="login-container">
        <div class="logo">
            <i class="ri-book-open-line"></i>
            <span>BookShop</span>
        </div>
        <h2>로그인</h2>
        <c:if test="${not empty errorMsg}">
            <div class="alert">${errorMsg}</div>
        </c:if>
        <form class="login-form" action="/login" method="post" autocomplete="off">
            <div class="input-group">
                <label for="username">아이디 <span class="required">*</span></label>
                <i class="ri-user-3-line input-icon"></i>
                <input type="text" name="username" id="username" placeholder="아이디를 입력하세요" maxlength="20" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호 <span class="required">*</span></label>
                <i class="ri-lock-password-line input-icon"></i>
                <input type="password" name="password" id="password" placeholder="비밀번호를 입력하세요" minlength="6" maxlength="30" required>
            </div>
            <button type="submit" class="login-btn">로그인</button>
        </form>
        <div class="login-footer">
            아직 회원이 아니신가요?
            <a href="/join/joinform">회원가입</a>
        </div>
    </div>
</body>
</html>

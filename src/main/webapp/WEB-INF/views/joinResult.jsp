<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원가입 완료 | BookStore</title>
<!-- 구글 폰트 및 아이콘 -->
<link href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon/fonts/remixicon.css">
<style>
    body {
        font-family: 'Roboto', 'Noto Sans KR', '맑은 고딕', Arial, sans-serif;
        background: linear-gradient(120deg, #e8f0fe 0%, #ffffff 100%);
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
        position: relative;
        overflow: hidden;
    }
    /* 책장 일러스트 배경 (SVG/PNG 파일을 프로젝트에 넣고 경로 지정) */
    .book-bg {
        position: absolute;
        right: 0;
        bottom: 0;
        width: 490px;
        opacity: 0.11;
        z-index: 0;
        pointer-events: none;
        user-select: none;
    }
    .complete-container {
        background: #fff;
        padding: 48px 54px 38px 54px;
        border-radius: 16px;
        box-shadow: 0 10px 36px rgba(53, 122, 225, 0.13);
        text-align: center;
        z-index: 1;
        animation: fadeIn 0.8s;
        min-width: 340px;
    }
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(40px);}
        to { opacity: 1; transform: translateY(0);}
    }
    .complete-container .icon-success {
        font-size: 48px;
        color: #357ae1;
        margin-bottom: 18px;
        display: inline-block;
        animation: pop 0.5s;
    }
    @keyframes pop {
        0% { transform: scale(0.4);}
        80% { transform: scale(1.1);}
        100% { transform: scale(1);}
    }
    .complete-container h2 {
        color: #357ae1;
        font-size: 2rem;
        font-weight: 700;
        margin-bottom: 12px;
        letter-spacing: 1px;
    }
    .complete-container p {
        font-size: 18px;
        color: #333;
        margin-bottom: 34px;
        font-weight: 500;
    }
    .main-btn {
        padding: 13px 38px;
        font-size: 18px;
        background: linear-gradient(90deg, #357ae1 0%, #5ab2fa 100%);
        color: #fff;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        transition: background 0.2s, box-shadow 0.2s;
        box-shadow: 0 2px 10px rgba(53, 122, 225, 0.11);
    }
    .main-btn:hover {
        background: linear-gradient(90deg, #2356a7 0%, #357ae1 100%);
        box-shadow: 0 6px 20px rgba(33,86,167,0.16);
    }
    @media (max-width: 600px) {
        .complete-container { padding: 32px 10px 24px 10px; border-radius: 0; min-width: 0;}
        .book-bg { width: 100vw; }
    }
</style>
</head>
<body>
    <!-- 책장 일러스트: 아래 경로를 실제 프로젝트 내 이미지로 교체 가능 -->
    <img class="book-bg" src="/images/bookshelf.svg" alt="bookshelf background" />
    <div class="complete-container">
        <span class="icon-success"><i class="ri-checkbox-circle-fill"></i></span>
        <h2>회원가입이 완료되었습니다!</h2>
        <p>BookStore에 오신 것을 환영합니다.<br>이제 다양한 도서와 서비스를 만나보세요.</p>
        <form action="/login/loginform" method="get">
    <button type="submit" class="main-btn">로그인으로</button>
</form>
    </div>
</body>
</html>

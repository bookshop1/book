<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 완료</title>
<style>
    body {
        font-family: '맑은 고딕', Arial, sans-serif;
        background: #f5f7fa;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }
    .complete-container {
        background: #fff;
        padding: 40px 60px;
        border-radius: 12px;
        box-shadow: 0 6px 20px rgba(52, 152, 219, 0.13);
        text-align: center;
    }
    .complete-container h2 {
        color: #3498db;
        font-size: 26px;
        margin-bottom: 18px;
    }
    .complete-container p {
        font-size: 18px;
        color: #333;
        margin-bottom: 32px;
    }
    .main-btn {
        padding: 12px 36px;
        font-size: 17px;
        background: #3498db;
        color: #fff;
        border: none;
        border-radius: 8px;
        cursor: pointer;
        font-weight: bold;
        transition: background 0.2s;
        box-shadow: 0 2px 8px rgba(52, 152, 219, 0.13);
    }
    .main-btn:hover {
        background: #217dbb;
    }
</style>
</head>
<body>
<div class="complete-container">
    <h2>회원가입이 완료되었습니다!</h2>
    <p>환영합니다</p>
    <form action="/main" method="get">
        <button type="submit" class="main-btn">메인으로</button>
    </form>
</div>
</body>
</html>

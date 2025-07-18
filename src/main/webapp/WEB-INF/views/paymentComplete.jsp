<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
<head>
    <meta charset="UTF-8">
    <title>결제 완료</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .confirmation-card {
            max-width: 500px;
            margin: 100px auto;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 12px;
            background-color: #ffffff;
        }
        .btn-home {
            margin-top: 20px;
        }
    </style>
</head>
<body class="bg-light">

    <div class="container">
        <div class="confirmation-card text-center">
            <h2 class="text-success mb-3">결제가 완료되었습니다!</h2>
            <p class="lead">주문해주셔서 감사합니다.<br>결제가 성공적으로 처리되었습니다.</p>
            <a href="/main" class="btn btn-primary btn-home">홈으로 돌아가기</a>
        </div>
    </div>

</body>
</html>

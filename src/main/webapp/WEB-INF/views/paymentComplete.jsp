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
        .book-image {
            max-width: 100%;
            height: auto;
        }
        .book-info {
            white-space: pre-wrap;
            line-height: 1.6;
        }
        .btn-group-custom a {
            margin: 0 5px;
            min-width: 120px;
        }
    </style>
</head>
<body class="bg-light">

	<h2>결제가 완료되었습니다!</h2>
    <p>주문해주셔서 감사합니다. 결제가 성공적으로 처리되었습니다.</p>
    <a href="/main">홈으로 돌아가기</a>
</body>
</html>

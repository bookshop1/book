<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${view.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .book-image {
            max-width: 100%;
            height: auto;
        }
        .book-info {
            white-space: pre-wrap; /* 개행 보존 */
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5 p-4 bg-white rounded shadow">

    <!-- 책 제목 -->
    <h2 class="text-center mb-4">${view.title}</h2>

    <div class="row">
        <!-- 책 이미지 -->
        <div class="col-md-4 text-center">
            <img src="/images/book/${view.pic}" alt="${view.title}" class="book-image img-thumbnail">
        </div>

        <!-- 책 정보 -->
        <div class="col-md-8">
            <div class="mb-2">
                <strong>저자:</strong> ${view.author}
            </div>
            <div class="mb-2">
                <strong>가격:</strong> <span class="text-danger fw-bold">${view.price}원</span>
            </div>
            <div class="mt-3 book-info">
                <strong>책 소개:</strong><br>
                ${view.info}
            </div>
        </div>
    </div>
</div>
</body>
</html>

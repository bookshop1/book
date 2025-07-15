<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<%@ include file="header.jsp" %>
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

<div class="container mt-5 p-4 bg-white rounded shadow">

    <!-- 뒤로가기 버튼 -->
    <div class="mb-3">
        <a href="javascript:history.back()" class="btn btn-secondary">&larr; 뒤로가기</a>
    </div>

    <!-- 책 제목 -->
    <h2 class="text-center mb-5">${view.title}</h2>

    <!-- 본문 3단 구성 (비율: 3 : 5 : 4) -->
    <div class="row align-items-start">
        <!-- 왼쪽: 저자 + 가격 -->
        <div class="col-md-3 text-center" style="margin-top: 30px;">
            <div class="d-inline-flex justify-content-center align-items-center">
                <div><strong>저자:</strong> ${view.author}</div>
                <div class="ms-3"><strong>가격:</strong> <span class="text-danger fw-bold">${view.price}원</span></div>
            </div>
        </div>

        <!-- 가운데: 책 이미지 -->
        <div class="col-md-5 text-center px-2">
            <img src="/images/book/${view.pic}" alt="${view.title}" class="book-image img-thumbnail">
        </div>

        <!-- 오른쪽: 책 소개 + 버튼 -->
        <div class="col-md-4 text-start ps-1 d-flex flex-column justify-content-start">
    		<p class="mb-1"><strong>책 소개:</strong></p>
   		 <div class="book-info mb-3" style="white-space: normal;">
   			 ${view.info}
		</div>

		    <!-- 버튼 -->
		    <form action="/pay" method="get">
			    <input type="hidden" name="title" value="${view.title}">
			    <input type="hidden" name="price" value="${view.price}">
			    <input type="hidden" name="qty" value="1">
			    
			    <div class="btn-group-custom text-center mt-2">
			        <a href="/bag/bagform" class="btn btn-outline-primary">🛒 장바구니</a>
			        <button type="submit" class="btn btn-danger">💳 구매하기</button>
			    </div>
		    </form>
		</div>
    </div>
</div>
 <!-- Footer -->
  <%@ include file="detail_footer.jsp" %>
</body>
</html>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>결제 페이지</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .section-title {
            font-weight: bold;
            font-size: 1.2rem;
            margin-bottom: 1rem;
            border-left: 4px solid #0d6efd;
            padding-left: 10px;
        }
    </style>
</head>
<body>
<%-- (수정 권장) header.jsp는 body 태그 안에 위치하는 것이 표준적인 HTML 구조입니다. --%>
<%@ include file="header.jsp" %>

<form action="/paySuccess" method="post">
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
<div class="container my-5">
    <h2 class="mb-4">결제 페이지</h2>

    <div class="mb-4">
        <div class="section-title">주문자 정보</div>
        <div class="row g-3">
            <div class="col-md-6">
                <%-- [수정 1] 모델에 담긴 loginUser 객체의 이름(id)을 value에 설정 --%>
                <input type="text" name="name" class="form-control" placeholder="이름" value="${loginUser.id}">
            </div>
            <div class="col-md-6">
                <%-- [수정 2] 모델에 담긴 loginUser 객체의 연락처(num)를 value에 설정 --%>
                <input type="text" name="num" class="form-control" placeholder="연락처" value="0${loginUser.num}">
            </div>
        </div>
    </div>

    <div class="mb-4">
        <div class="section-title">배송지 정보</div>
        <div class="row g-3">
            <div class="col-md-8">
                <%-- [수정 3] 모델에 담긴 loginUser 객체의 주소(address)를 value에 설정 --%>
                <input type="text" name="address" class="form-control" placeholder="주소" value="${loginUser.address}">
            </div>
            <div class="col-md-4">
                <input type="text" name="post" class="form-control" placeholder="우편번호" value="">
            </div>
            <div class="col-12">
                <input type="text" name="detailAddress" class="form-control" placeholder="상세주소">
            </div>
        </div>
    </div>

    <div class="mb-4">
        <div class="section-title">주문 상품</div>
        <table class="table table-bordered align-middle text-center">
            <thead class="table-light">
                <tr>
                    <th>상품명</th>
                    <th>수량</th>
                    <th>금액</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${orderList}">
                    <tr>
                        <td>${item.title}</td>
                        <td>${item.quantity}</td>
                        <td>${item.total}원</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <div class="mb-4">
        <div class="section-title">결제 금액</div>
        <div class="row justify-content-end">
            <div class="col-md-6">
                <ul class="list-group">
                    <li class="list-group-item d-flex justify-content-between">
                        <span>상품 합계</span><strong>${total} 원</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <span>배송비</span><strong>0 원</strong>
                    </li>
                    <li class="list-group-item d-flex justify-content-between">
                        <span>총 결제금액</span><strong class="text-primary fs-5">${total} 원</strong>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="text-center mt-4">
        <c:forEach var="item" items="${orderList}" varStatus="status">
            <input type="hidden" name="bagItems[${status.index}].title" value="${item.title}" />
            <input type="hidden" name="bagItems[${status.index}].price" value="${item.price}" />
            <input type="hidden" name="bagItems[${status.index}].quantity" value="${item.quantity}" />
        </c:forEach>
        <button type="submit" class="btn btn-primary btn-lg px-5">결제하기</button>
    </div>
</div>
</form>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
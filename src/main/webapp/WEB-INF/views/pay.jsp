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
<div class="container my-5">
  <h2 class="mb-4">결제 페이지</h2>

  <!-- 1. 주문자 정보 -->
  <div class="mb-4">
    <div class="section-title">주문자 정보</div>
    <div class="row g-3">
      <div class="col-md-6">
        <input type="text" class="form-control" placeholder="이름" value="">
      </div>
      <div class="col-md-6">
        <input type="text" class="form-control" placeholder="연락처" value="">
      </div>
    </div>
  </div>

  <!-- 2. 배송지 정보 -->
  <div class="mb-4">
    <div class="section-title">배송지 정보</div>
    <div class="row g-3">
      <div class="col-md-8">
        <input type="text" class="form-control" placeholder="주소" value="">
      </div>
      <div class="col-md-4">
        <input type="text" class="form-control" placeholder="우편번호" value="">
      </div>
      <div class="col-12">
        <input type="text" class="form-control" placeholder="상세주소">
      </div>
    </div>
  </div>

  <!-- 3. 주문 상품 목록 -->
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
                <td>${item.qty}</td>
                <td>${item.total}원</td>
            </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <!-- 4. 결제 금액 요약 -->
  <div class="mb-4">
    <div class="section-title">결제 금액</div>
    <div class="row justify-content-end">
      <div class="col-md-6">
        <ul class="list-group">
          <li class="list-group-item d-flex justify-content-between">
            <span>상품 합계</span><strong></strong>
          </li>
          <li class="list-group-item d-flex justify-content-between">
            <span>배송비</span><strong></strong>
          </li>
          <li class="list-group-item d-flex justify-content-between">
            <span>총 결제금액</span><strong class="text-primary fs-5">${total}</strong>
          </li>
        </ul>
      </div>
    </div>
  </div>

  <!-- 5. 결제 버튼 -->
  <div class="text-center mt-4">
    <button type="button" class="btn btn-primary btn-lg px-5">결제하기</button>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

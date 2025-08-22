<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <title>결제 내역</title>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-5">

    <h2 class="mb-5 text-center">🧾 결제 내역</h2>
    
    <div class="text-center">
        <a href="/main" class="btn btn-outline-primary">🏠 홈으로 돌아가기</a>
    </div>

    <c:forEach var="payment" items="${paymentList}">
        <div class="card mb-5 shadow-sm">
            <div class="card-header bg-primary text-white">
                <strong>수령인 정보</strong>
            </div>
            <div class="card-body">
                <p><strong>수령인:</strong> ${payment.name}</p>
                <p><strong>연락처:</strong> ${payment.num}</p>
                <p><strong>주소:</strong> ${payment.address} ${payment.detailAddress}</p>
                <p><strong>우편번호:</strong> ${payment.post}</p>

                <h5 class="mt-4">🛒 주문 상품</h5>
                <div class="table-responsive">
                    <table class="table table-striped align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>상품명</th>
                                <th>수량</th>
                                <th>가격</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${payment.items}">
                                <tr>
                                    <td>${item.title}</td>
                                    <td>${item.quantity}</td>
                                    <td>${item.price}원</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </c:forEach>

    

</body>
</html>

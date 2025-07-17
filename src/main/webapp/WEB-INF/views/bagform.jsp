<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>장바구니</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    <style>
        .cart-card {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            border-radius: 12px;
            padding: 20px;
            background-color: #ffffff;
        }

        .cart-item {
            border-bottom: 1px solid #dee2e6;
            padding: 20px 0;
        }

        .cart-img {
            width: 80px;
            height: 120px;
            object-fit: cover;
            border-radius: 4px;
        }

        .cart-info {
            flex: 1;
            margin-left: 20px;
        }

        .cart-title {
            font-weight: bold;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }

        .price-cell {
            text-align: right;
            font-weight: 500;
        }

        .summary-box {
            background-color: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            margin-top: 30px;
        }

        .order-btn {
            float: right;
        }
    </style>
</head>
<body class="bg-light">
<div class="container mt-5 mb-5">
    <div class="cart-card">
        <h2 class="text-primary mb-4"><i class="fas fa-shopping-cart"></i> 내 장바구니</h2>

        <c:choose>
            <c:when test="${empty bagItems}">
                <div class="alert alert-info">장바구니에 책이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <c:forEach var="book" items="${bagItems}">
                    <div class="cart-item d-flex align-items-start">
                        <img src="/images/book/${book.pic}" alt="책 이미지" class="cart-img">
                        <div class="cart-info">
                            <div class="cart-title">${book.title}</div>
                            <div class="text-muted">수량: ${book.quantity}</div>
                        </div>
                        <div class="ms-auto text-end">
                            <div class="price-cell">${book.price}원</div>
                            <div class="price-cell small text-muted mt-1">합계: ${book.price * book.quantity}원</div>
                            <form action="/bag/bagdelete" method="post" class="mt-2">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <input type="hidden" name="b_id" value="${book.b_id}"/>
                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                    <i class="fas fa-trash-alt"></i> 삭제
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>

                <!-- 총합 영역 -->
                <div class="summary-box mt-4">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="fs-5"><strong>총합계</strong></div>
                        <div class="fs-5 text-primary"><strong>${totalPrice}원</strong></div>
                    </div>
                    <form action="/order/checkout" method="post" class="mt-3 text-end">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="btn btn-success btn-lg">
                            <i class="fas fa-credit-card"></i> 주문하기
                        </button>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
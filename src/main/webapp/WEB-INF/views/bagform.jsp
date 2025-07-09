<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>장바구니</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-5">
    <h2 class="mb-4">🛒 내 장바구니</h2>
    <c:choose>
        <c:when test="${empty bagItems}">
            <div class="alert alert-info">장바구니에 책이 없습니다.</div>
        </c:when>
        <c:otherwise>
            <table class="table table-bordered align-middle text-center">
                <thead class="table-light">
                <tr>
                    <th>제목</th>
                    <th>수량</th>
                    <th>가격</th>
                    <th>합계</th>
                    <th>삭제</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="book" items="${bagItems}">
                    <tr>
                        <td>${book.title}</td>
                        <td>${book.quantity}</td>
                        <td>${book.price}원</td>
                        <td>${book.price * book.quantity}원</td>
                        <td>
                            <form action="/bag/bagdelete" method="post">
                                <input type="hidden" name="b_id" value="${book.b_id}"/>
                                <button type="submit" class="btn btn-danger btn-sm">삭제</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <tr class="table-warning">
                    <td colspan="3"><strong>총합</strong></td>
                    <td colspan="2"><strong>${totalPrice}원</strong></td>
                </tr>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
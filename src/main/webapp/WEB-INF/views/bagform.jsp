<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<%@ include file="header.jsp" %>
<head>
    <title>장바구니</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        .cart-card { box-shadow: 0 4px 20px rgba(0,0,0,0.08); border-radius:12px; padding:20px; background:#fff; }
        .cart-item { border-bottom:1px solid #dee2e6; padding:20px 0; display:flex; align-items:start; }
        .cart-img { width:80px; height:120px; object-fit:cover; border-radius:4px; }
        .cart-info { flex:1; margin-left:20px; }
        .cart-title { font-weight:bold; font-size:1.1rem; margin-bottom:5px; }
        .price-cell { text-align:right; font-weight:500; }
        .summary-box { background:#f9f9f9; border-radius:8px; padding:20px; margin-top:30px; }
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
                <form action="/pay" method="post" id="payForm">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                
                    <c:forEach var="book" items="${bagItems}" varStatus="status">
                        <div class="cart-item" data-bid="${book.b_id}">
                            <img src="${book.pic}" alt="책 이미지" class="cart-img">
                            <div class="cart-info">
                                <div class="cart-title">${book.title}</div>
                                <div class="text-muted">
                                    수량:
                                    <input type="number" min="1" value="${book.quantity}" 
                                           class="qty-input form-control form-control-sm" style="width:70px;">
                                </div>
                            </div>
                            <div class="ms-auto text-end">
                                <div class="price-cell" data-price="${book.price}">${book.price}원</div>
                                <div class="price-cell small text-muted mt-1 item-total">${book.price * book.quantity}원</div>
                                <button type="button" class="btn btn-outline-danger btn-sm delete-btn mt-2" data-bid="${book.b_id}">
                                    <i class="fas fa-trash-alt"></i> 삭제
                                </button>
                                <input type="hidden" name="b_id" value="${book.b_id}">
                                <input type="hidden" name="quantity" value="${book.quantity}" class="qty-hidden">
                            </div>
                        </div>
                    </c:forEach>

                    <!-- 총합 영역 -->
                    <div class="summary-box mt-4">
                        <div class="d-flex justify-content-between align-items-center">
                            <div class="fs-5"><strong>총합계</strong></div>
                            <div class="fs-5 text-primary" id="totalPrice"><strong>${totalPrice}원</strong></div>
                        </div>
                        <div class="text-end mt-3">
                            <button type="submit" class="btn btn-success btn-lg">
                                <i class="fas fa-credit-card"></i> 주문하기
                            </button>
                        </div>
                    </div>
                </form>
            </c:otherwise>
        </c:choose>
    </div>
    <a href="/main" class="btn btn-primary btn-home">쇼핑 계속하기</a>
</div>


<script>
document.addEventListener("DOMContentLoaded", function() {
    const qtyInputs = document.querySelectorAll('.qty-input');
    const qtyHidden = document.querySelectorAll('.qty-hidden');
    const itemTotals = document.querySelectorAll('.item-total');
    const totalElem = document.querySelector('#totalPrice');

    // CSRF 토큰 가져오기
    const csrfParameter = document.querySelector('input[name="_csrf"]').name;
    const csrfToken = document.querySelector('input[name="_csrf"]').value;

    // 수량 변경시 총합 업데이트
    function updateTotals() {
        let total = 0;
        qtyInputs.forEach((input, idx) => {
            const qty = parseInt(input.value);
            const price = parseInt(input.closest('.cart-item').querySelector('.price-cell').dataset.price);
            const itemTotal = qty * price;
            itemTotals[idx].textContent = itemTotal + '원';
            qtyHidden[idx].value = qty; // hidden input 동기화
            total += itemTotal;
        });
        totalElem.textContent = total + '원';
    }

    qtyInputs.forEach(input => {
        input.addEventListener('input', updateTotals);
        input.addEventListener('change', function() {
            updateTotals();
            const bId = this.closest('.cart-item').dataset.bid;

            const formData = new URLSearchParams();
            formData.append('b_id', bId);
            formData.append('quantity', this.value);
            formData.append(csrfParameter, csrfToken); // CSRF 토큰 포함

            fetch('/bag/update-guest-quantity', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            });
        });
    });

    // 삭제 버튼
    const deleteButtons = document.querySelectorAll('.delete-btn');
    deleteButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const cartItem = this.closest('.cart-item');
            const bId = this.dataset.bid;

            const formData = new URLSearchParams();
            formData.append('b_id', bId);
            formData.append(csrfParameter, csrfToken); // CSRF 토큰 포함

            fetch('/bag/bagdelete', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            }).then(resp => {
                if(resp.ok){
                    cartItem.remove();
                    updateTotals();

                    const remainingItems = document.querySelectorAll('.cart-item');
                    if(remainingItems.length === 0){
                        document.getElementById('payForm').style.display = 'none';
                        totalElem.textContent = '0원';
                    }
                } else {
                    alert('삭제 실패');
                }
            });
        });
    });
});
</script>
<%@ include file="footer.jsp" %>
</body>
</html>
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
    const deleteButtons = document.querySelectorAll('.delete-btn');
    const payForm = document.getElementById('payForm');

    const csrfParameter = document.querySelector('input[name="_csrf"]').name;
    const csrfToken = document.querySelector('input[name="_csrf"]').value;
    const isUserLoggedIn = '<%= request.getSession().getAttribute("userId") != null %>';

    // ✅ 수량 변경 시 총합 업데이트 (수정된 부분)
    function updateTotals() {
        let total = 0;
        let formIsEmpty = true;
        qtyInputs.forEach((input, idx) => {
            // 입력값이 비어있거나 유효한 숫자가 아니면 0으로 처리
            const qty = input.value === '' || isNaN(parseInt(input.value)) ? 0 : parseInt(input.value);
            
            // 입력 필드의 값 자체를 0으로 고정하여 사용자에게 표시
            input.value = qty; 

            const price = parseInt(input.closest('.cart-item').querySelector('.price-cell').dataset.price);
            const itemTotal = qty * price;
            itemTotals[idx].textContent = itemTotal.toLocaleString('ko-KR') + '원';
            qtyHidden[idx].value = qty;
            total += itemTotal;
            if (qty > 0) {
                formIsEmpty = false;
            }
        });
        totalElem.textContent = total.toLocaleString('ko-KR') + '원';
        
        // 장바구니가 비어 있으면 결제 버튼 숨기기
        const orderButton = payForm.querySelector('button[type="submit"]');
        if (formIsEmpty) {
            orderButton.style.display = 'none';
        } else {
            orderButton.style.display = 'inline-block';
        }
    }

    updateTotals();

    qtyInputs.forEach(input => {
        input.addEventListener('input', updateTotals);
        input.addEventListener('change', function() {
            updateTotals();
            
            if (isUserLoggedIn === 'false') {
                const bId = this.closest('.cart-item').dataset.bid;
                const formData = new URLSearchParams();
                formData.append('b_id', bId);
                formData.append('quantity', this.value);
                formData.append(csrfParameter, csrfToken);
    
                fetch('/bag/update-guest-quantity', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                }).then(resp => {
                    if(!resp.ok) {
                       console.error("수량 업데이트 실패");
                    }
                });
            }
        });
    });

    // ✅ 결제 폼 제출 전 유효성 검사 (추가된 부분)
    payForm.addEventListener('submit', function(event) {
        let hasValidItems = false;
        qtyInputs.forEach(input => {
            const qty = parseInt(input.value);
            if (!isNaN(qty) && qty > 0) {
                hasValidItems = true;
            }
        });

        if (!hasValidItems) {
            event.preventDefault(); // 폼 제출 막기
            alert('장바구니에 유효한 상품이 없습니다.');
        }
    });

    function getLoggedInUserCartData() {
        const cartItems = [];
        document.querySelectorAll('.cart-item').forEach(itemElem => {
            const bId = itemElem.dataset.bid;
            const quantity = itemElem.querySelector('.qty-input').value;
            // 결제 전송 시 유효성 검사를 통해 0이 아닌 값만 전송하므로 별도 로직 불필요
            cartItems.push({
                b_id: bId,
                quantity: quantity
            });
        });
        return cartItems;
    }

    window.addEventListener('beforeunload', function (event) {
        const isUserLoggedIn = '<%= request.getSession().getAttribute("userId") != null %>';

        if (isUserLoggedIn === 'true') {
            const cartData = getLoggedInUserCartData();
            const csrfToken = document.querySelector('input[name="_csrf"]').value;
            const csrfHeaderName = 'X-CSRF-TOKEN'; 

            fetch('/bag/save-bag-items', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    [csrfHeaderName]: csrfToken 
                },
                body: JSON.stringify(cartData)
            })
            .then(response => {
                console.log('장바구니 업데이트 요청 전송 완료');
            })
            .catch(error => {
                console.error('장바구니 업데이트 요청 실패:', error);
            });
        }
    });

    deleteButtons.forEach(btn => {
        btn.addEventListener('click', function() {
            const cartItem = this.closest('.cart-item');
            const bId = this.dataset.bid;

            const formData = new URLSearchParams();
            formData.append('b_id', bId);
            formData.append(csrfParameter, csrfToken);

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
                        const cartCard = document.querySelector('.cart-card');
                        cartCard.innerHTML = '<h2 class="text-primary mb-4"><i class="fas fa-shopping-cart"></i> 내 장바구니</h2><div class="alert alert-info">장바구니에 책이 없습니다.</div>';
                    }
                } else {
                    alert('삭제 실패');
                }
            }).catch(error => {
                console.error('삭제 요청 중 오류 발생:', error);
                alert('삭제 실패: 네트워크 오류');
            });
        });
    });
});
</script>
<%@ include file="footer.jsp" %>
</body>
</html>
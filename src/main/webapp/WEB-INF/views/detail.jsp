<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 하단 고정 바 -->
<div class="d-flex align-items-center justify-content-between border-top py-3 px-4"
     style="position: fixed; bottom: 0; width: 100%; background-color: #fff; z-index: 1000;">

  <!-- 총 상품 금액 -->
  <div class="d-flex align-items-center gap-2">
    <span>총 상품 금액</span>
    <strong class="fs-5" id="footer-total">${view.price}원</strong>
  </div>

  <!-- 수량 조절 및 구매 버튼 -->
  <div class="d-flex align-items-center gap-2">
    <div class="input-group" style="width: 110px;">
      <button class="btn btn-outline-secondary" type="button" id="footer-decrease">−</button>
      <input type="text" class="form-control text-center" id="footer-quantity" value="1" readonly style="max-width: 50px;">
      <button class="btn btn-outline-secondary" type="button" id="footer-increase">＋</button>
    </div>

    <button type="button" class="btn btn-outline-secondary" title="찜하기">
      <i class="bi bi-heart"></i>
    </button>

    <button type="button" class="btn btn-outline-secondary">선물하기</button>
    <button type="button" class="btn btn-outline-primary">장바구니</button>
    <button type="button" class="btn btn-secondary">바로드림</button>
    <button type="button" class="btn btn-primary">바로구매</button>
  </div>
</div>

<!-- ✅ 가격 계산 스크립트 -->
<script>
  // JSP에서 받은 가격을 안전하게 숫자로 변환
  const unitPrice = parseInt("<c:out value='${view.price}'/>".replace(/,/g, ''));
  const footerQtyInput = document.getElementById('footer-quantity');
  const footerTotal = document.getElementById('footer-total');

  document.getElementById('footer-increase').addEventListener('click', () => {
    let val = parseInt(footerQtyInput.value);
    footerQtyInput.value = isNaN(val) ? 1 : val + 1;
    updateFooterTotal();
  });

  document.getElementById('footer-decrease').addEventListener('click', () => {
    let val = parseInt(footerQtyInput.value);
    footerQtyInput.value = (isNaN(val) || val <= 1) ? 1 : val - 1;
    updateFooterTotal();
  });

  function updateFooterTotal() {
    const qty = parseInt(footerQtyInput.value);
    const total = isNaN(qty) ? unitPrice : qty * unitPrice;
    footerTotal.textContent = total.toLocaleString() + "원";
  }
</script>

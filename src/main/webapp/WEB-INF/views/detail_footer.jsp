<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 부트스트랩 5 기준 -->
<div class="d-flex align-items-center justify-content-between border-top py-3 px-4 position: fixed;
      bottom: 0;">
  <div class="d-flex align-items-center gap-2">
    <span>총 상품 금액</span>
    <strong class="fs-5">${view.price}원</strong>
  </div>

  <div class="d-flex align-items-center gap-2">
    <div class="input-group" style="width: 110px;">
      <button class="btn btn-outline-secondary" type="button">−</button>
      <input type="text" class="form-control text-center" value="1" style="max-width: 50px;">
      <button class="btn btn-outline-secondary" type="button">+</button>
    </div>

    <button type="button" class="btn btn-outline-secondary" title="찜하기">
      <i class="bi bi-heart"></i> <!-- Bootstrap Icons 필요 -->
    </button>

    <button type="button" class="btn btn-outline-primary">
      장바구니
    </button>

    <button type="button" class="btn btn-primary">
      바로구매
    </button>
  </div>
</div>

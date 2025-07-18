<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page pageEncoding="UTF-8" %>

<!-- 헤더 영역 -->
<div class="container-fluid bg-light border-bottom py-2">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <!-- 왼쪽: 로고 -->
            <div>
			    <c:choose>
			        <c:when test="${sessionScope.loginUser.role eq 'ROLE_ADMIN'}">
			            <a href="/admin/main" class="text-decoration-none">
			                <span class="fw-bold fs-4" style="color: skyblue;">BookShop</span>
			            </a>
			        </c:when>
			        <c:otherwise>
			            <a href="/main" class="text-decoration-none">
			                <span class="fw-bold fs-4" style="color: skyblue;">BookShop</span>
			            </a>
			        </c:otherwise>
			    </c:choose>
			</div>

            <!-- 중간: 검색 폼 -->
            <form action="/main" method="get" class="d-flex" style="max-width: 300px;">
                <div class="input-group">
                    <input type="text" name="keyword" class="form-control"
                           placeholder="도서 제목 또는 저자명 검색" value="${param.keyword}">
                    <button class="btn btn-primary" type="submit">검색</button>
                </div>
            </form>

            <!-- 오른쪽: 로그인 여부에 따라 다른 메뉴 -->
            <div class="d-flex align-items-center">
                <c:choose>
                    
                    <c:when test="${not empty sessionScope.loginUser}">
                        <span class="me-2">👤 ${sessionScope.loginUser.id} 님</span>
                        <a href="/login/logout" class="btn btn-sm btn-outline-danger me-2">로그아웃</a>
                        <a href="/bag/bagform" class="btn btn-sm btn-outline-primary">🛒 장바구니</a>
                        <a href="/paymentHistory" class="btn btn-sm btn-outline-primary">결제내역</a>
                    </c:when>

                  
                    <c:otherwise>
                        <a href="/login/loginform" class="btn btn-sm btn-outline-secondary me-2">로그인</a>
                        <a href="/join/joinform" class="btn btn-sm btn-outline-secondary me-2">회원가입</a>
                        <a href="/bag/bagform" class="btn btn-sm btn-outline-primary">🛒 장바구니</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

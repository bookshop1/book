<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!-- 헤더 영역 -->
<div class="container-fluid bg-light border-bottom py-2">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <!-- 왼쪽: 로고 -->
            <div>
                <a href="/index.jsp" class="text-decoration-none">
                    <span class="fw-bold fs-4" style="color: skyblue;">BookShop</span>
                </a>
            </div>

            <!-- 오른쪽: 로그인/회원가입/장바구니 or 로그아웃/마이페이지 -->
            <div class="d-flex align-items-center">
                <c:choose>
                    <c:when test="${not empty sessionScope.loginUser}">
                        <span class="me-2">👤 ${sessionScope.loginUser.name}님</span>
                        <a href="/logout.jsp" class="btn btn-sm btn-outline-danger me-2">로그아웃</a>
                        <a href="/cart.jsp" class="btn btn-sm btn-outline-primary">🛒 장바구니</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/loginform.jsp" class="btn btn-sm btn-outline-secondary me-2">로그인</a>
                        <a href="/joinform.jsp" class="btn btn-sm btn-outline-secondary me-2">회원가입</a>
                        <a href="/cart.jsp" class="btn btn-sm btn-outline-primary">🛒 장바구니</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

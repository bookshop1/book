<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- [수정 1] Spring Security 태그 라이브러리 선언 --%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page pageEncoding="UTF-8" %>

<div class="container-fluid bg-light border-bottom py-2">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <%-- [수정 2] 권한에 따라 로고 링크 변경 --%>
                <sec:authorize access="hasRole('ADMIN')">
                    <a href="/admin/main" class="text-decoration-none">
                        <span class="fw-bold fs-4" style="color: skyblue;">BookShop</span>
                    </a>
                </sec:authorize>
                <sec:authorize access="!hasRole('ADMIN')">
                    <a href="/main" class="text-decoration-none">
                        <span class="fw-bold fs-4" style="color: skyblue;">BookShop</span>
                    </a>
                </sec:authorize>
            </div>

            <form action="/main" method="get" class="d-flex" style="max-width: 300px;">
                <div class="input-group">
                    <input type="text" name="keyword" class="form-control"
                           placeholder="도서 제목 또는 저자명 검색" value="${param.keyword}">
                    <button class="btn btn-primary" type="submit">검색</button>
                </div>
            </form>

            <div class="d-flex align-items-center">
                
                <%-- [수정 3] 로그인 상태일 때 표시 (isAuthenticated) --%>
                <sec:authorize access="isAuthenticated()">
                    <span class="me-2">
                        👤 <sec:authentication property="principal.username"/> 님
                    </span>
                    
                    <%-- [수정 4] 로그아웃은 POST 방식 form으로 처리 --%>
                    <a href="javascript:void(0);" onclick="document.getElementById('logout-form').submit();" class="btn btn-sm btn-outline-danger me-2">로그아웃</a>
                    <form id="logout-form" action="/logout" method="post" style="display: none;">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    </form>
                    
                    <a href="/bag/bagform" class="btn btn-sm btn-outline-primary me-2">🛒 장바구니</a>
                    <a href="/paymentHistory" class="btn btn-sm btn-outline-primary me-2">결제내역</a>

                    <%-- [수정 5] 관리자(ADMIN)일 때만 '차트' 버튼 표시 --%>
                    <sec:authorize access="hasRole('ADMIN')">
                        <a href="/chart" class="btn btn-sm btn-outline-primary">차트</a>
                    </sec:authorize>
                </sec:authorize>

                <%-- [수정 3] 로그아웃 상태일 때 표시 (isAnonymous) --%>
                <sec:authorize access="isAnonymous()">
                    <a href="/login/loginform" class="btn btn-sm btn-outline-secondary me-2">로그인</a>
                    <a href="/join/joinform" class="btn btn-sm btn-outline-secondary me-2">회원가입</a>
                    <a href="/bag/bagform" class="btn btn-sm btn-outline-primary">🛒 장바구니</a>
                </sec:authorize>
            </div>
        </div>
    </div>
    <div class="container mt-2">
        ...
    </div>
</div>
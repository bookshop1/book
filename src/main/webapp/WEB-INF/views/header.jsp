<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page pageEncoding="UTF-8" %>

<div class="container-fluid bg-light border-bottom py-2">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            
            <div>
                <c:choose>
                    <c:when test="${sessionScope.userRole eq 'ADMIN'}">
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

            <form action="/main" method="get" class="d-flex flex-grow-1 justify-content-center" style="max-width: 400px;">
                <div class="input-group rounded shadow-sm">
                    <span class="input-group-text bg-white border-0">
                        <i class="bi bi-search text-secondary"></i>
                    </span>
                    <input type="text" name="keyword" class="form-control border-0"
                           placeholder="도서 제목 또는 저자명 검색" value="${param.keyword}">
                    <button class="btn btn-primary px-3" type="submit">검색</button>
                </div>
            </form>

            <div class="d-flex align-items-center">
                <c:choose>
                    <%-- 1. 세션에 'loggedInUser'가 있는지 확인 (loginUser -> loggedInUser로 수정) --%>
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <%-- 2. 사용자 이름 표시 (${... .id} 제거) --%>
                        <span class="me-2">👤 <strong>${sessionScope.loggedInUser}</strong> 님</span>
                        
                        <%-- 3. 로그아웃 URL 수정 (/login/logout -> /logout) --%>
                        <form action="/logout" method="post" style="display: inline;">
						    <button type="submit" class="btn btn-sm btn-outline-danger me-2">로그아웃</button>
						    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						</form>
                        <a href="/bag/bagform" class="btn btn-sm btn-outline-primary me-2">🛒 장바구니</a>
                        <a href="/paymentHistory" class="btn btn-sm btn-outline-primary me-2">결제내역</a>

                        <%-- 4. 관리자(ADMIN)일 경우에만 '차트' 버튼 표시 --%>
                        <c:if test="${sessionScope.userRole eq 'ADMIN'}">
                            <a href="/chart" class="btn btn-sm btn-outline-success">📊 차트</a>
                        </c:if>
                    </c:when>

                    <c:otherwise>
                        <a href="/login/loginform" class="btn btn-sm btn-outline-secondary me-2">로그인</a>
                        <a href="/join/joinform" class="btn btn-sm btn-outline-secondary me-2">회원가입</a>
                        <a href="/bag/bagform" class="btn btn-sm btn-outline-primary me-2">🛒 장바구니</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <div class="container mt-2">
        <ul class="nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle fw-bold" href="#" id="categoryDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    카테고리
                </a>
                <ul class="dropdown-menu" aria-labelledby="categoryDropdown">
                    <li><a class="dropdown-item" href="/main?category=essay">에세이</a></li>
                    <li><a class="dropdown-item" href="/main?category=novel">소설</a></li>
                    <li><a class="dropdown-item" href="/main?category=humanities">인문</a></li>
                    <li><a class="dropdown-item" href="/main?category=health">건강</a></li>
                    <li><a class="dropdown-item" href="/main?category=economy">경제</a></li>
                </ul>
            </li>
            
        </ul>
    </div>
</div>
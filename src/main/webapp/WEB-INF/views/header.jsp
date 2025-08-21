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
<form action="/main" method="get" class="d-flex flex-grow-1 justify-content-center" style="max-width: 400px;">
    <div class="input-group rounded shadow-sm">
        <!-- 검색 아이콘 -->
        <span class="input-group-text bg-white border-0">
            <i class="bi bi-search text-secondary"></i>
        </span>
        <!-- 검색 입력창 -->
        <input type="text" name="keyword" class="form-control border-0"
               placeholder="도서 제목 또는 저자명 검색" value="${param.keyword}">
        <!-- 버튼 -->
        <button class="btn btn-primary px-3" type="submit">
            검색
        </button>
    </div>
</form>

<!-- Bootstrap Icons (검색 아이콘용) -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">





            <!-- 오른쪽: 로그인 여부에 따라 다른 메뉴 -->
            <div class="d-flex align-items-center">
                <c:choose>
                    
                    <c:when test="${not empty sessionScope.loginUser}">
                        <span class="me-2">👤 ${sessionScope.loginUser.id} 님</span>
                        <a href="/login/logout" class="btn btn-sm btn-outline-danger me-2">로그아웃</a>
                        <a href="/bag/bagform" class="btn btn-sm btn-outline-primary">🛒 장바구니</a>
                        <a href="/paymentHistory" class="btn btn-sm btn-outline-primary">결제내역</a>
                        <a href="/chart" class="btn btn-sm btn-outline-primary">차트</a>
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
    <!-- 하단 메뉴 -->
    <div class="container mt-2">
        <ul class="nav">
            <!-- 카테고리 드롭다운 -->
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
            <!-- 베스트셀러 -->
            <li class="nav-item">
                <a class="nav-link fw-bold" href="/bestseller">베스트셀러</a>
            </li>
            <!-- 통계 -->
            <li class="nav-item">
                <a class="nav-link fw-bold" href="/statistics">통계</a>
            </li>
        </ul>
    </div>
</div>



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

            <c:choose>
			    <c:when test="${sessionScope.userRole eq 'ADMIN'}">
			        <form action="${pageContext.request.contextPath}/admin/main" method="get" class="d-flex justify-content-center" style="max-width:400px;">
			    </c:when>
			    <c:otherwise>
			        <form action="${pageContext.request.contextPath}/main" method="get" class="d-flex justify-content-center" style="max-width:400px;">
			    </c:otherwise>
			</c:choose>
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
                    <c:when test="${not empty sessionScope.loggedInUser}">
                        <span class="me-2">👤 <strong>${sessionScope.loggedInUser}</strong> 님</span>
                        
                        <form action="/logout" method="post" style="display: inline;">
						    <button type="submit" class="btn btn-sm btn-outline-danger me-2">로그아웃</button>
						    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
						</form>
                        <a href="/bag/bagform" class="btn btn-sm btn-outline-primary me-2">🛒 장바구니</a>
                        <a href="/paymentHistory" class="btn btn-sm btn-outline-primary me-2">결제내역</a>

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
                    <c:choose>
                        <c:when test="${sessionScope.userRole eq 'ADMIN'}">
                            <li><a class="dropdown-item" href="/admin/main?category=essay">에세이</a></li>
                            <li><a class="dropdown-item" href="/admin/main?category=novel">소설</a></li>
                            <li><a class="dropdown-item" href="/admin/main?category=humanities">인문</a></li>
                            <li><a class="dropdown-item" href="/admin/main?category=health">건강</a></li>
                            <li><a class="dropdown-item" href="/admin/main?category=economy">경제</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a class="dropdown-item" href="/main?category=essay">에세이</a></li>
                            <li><a class="dropdown-item" href="/main?category=novel">소설</a></li>
                            <li><a class="dropdown-item" href="/main?category=humanities">인문</a></li>
                            <li><a class="dropdown-item" href="/main?category=health">건강</a></li>
                            <li><a class="dropdown-item" href="/main?category=economy">경제</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </li>
        </ul>
    </div>
</div>
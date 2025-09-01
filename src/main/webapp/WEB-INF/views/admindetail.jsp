<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 도서 상세</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
</head>
<body>
<main class="container py-5">
    <h2 class="mb-4">📖 도서 상세 정보 (관리자)</h2>

    <div class="card mb-4 shadow-sm">
        <div class="row g-0">
            <div class="col-md-4">
                <c:if test="${not empty book.pic}">
                    <img src="${book.pic}" class="img-fluid rounded-start" alt="책 표지">
                </c:if>
            </div>
            <div class="col-md-8 mx-auto">
			    <div class="card shadow-sm border-0">
			        <div class="card-body text-center">
			            <!-- 제목 -->
			            <h3 class="card-title fw-bold mb-2">${book.title}</h3>
			            
			            <!-- 저자 -->
			            <p class="text-secondary mb-2" style="font-size: 1rem;">저자: ${book.author}</p>
			            
			            <!-- 가격 -->
			            <p class="card-text mb-2" style="font-size: 1.1rem; font-weight: 500;">
			                가격: <span class="text-danger">₩ <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" /></span>
			            </p>
			            
			            <!-- 도서 정보 -->
			            <p class="card-text mb-3" style="font-size: 0.95rem;">${book.info}</p>
			            
			            <!-- 액션 버튼 -->
			            <div class="d-flex justify-content-center mb-3 gap-2 flex-wrap">
			                <!-- 수정 버튼 -->
			                <a href="/admin/edit/${book.b_id}" class="btn btn-primary px-4" style="height: 38px;">수정</a>
			
			                <!-- 삭제 버튼 -->
			                <form action="/admin/delete/${book.b_id}" method="post" 
			                      onsubmit="return confirm('정말 삭제하시겠습니까?');" class="d-inline-flex">
			                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			                    <button type="submit" class="btn btn-danger px-4" style="height: 38px;">삭제</button>
			                </form>
			
			                <!-- 목록으로 버튼 -->
			                <a href="/admin/main" class="btn btn-secondary px-4" style="height: 38px;">목록으로</a>
			            </div>
			            
			            <!-- 평균 별점 -->
			            <div class="avg-score mt-3" style="font-size: 1.1rem;">
			                <strong>평균 별점:</strong>
			                <a href="#commentsSection" class="text-warning text-decoration-none">
			                    <c:forEach begin="1" end="${fn:substringBefore(reviewAvg.avgScore + 0.5, '.')}" var="i">★</c:forEach>
			                    <c:forEach begin="${fn:substringBefore(reviewAvg.avgScore + 0.5, '.') + 1}" end="5" var="i">☆</c:forEach>
			                    (<fmt:formatNumber value="${reviewAvg.avgScore}" pattern="#0.0" /> / ${reviewAvg.reviewCount}건)
			                </a>
			            </div>
			        </div>
			    </div>
			</div>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<%@ include file="footer.jsp" %>
</body>
</html>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${view.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html { scroll-behavior: smooth; }

        /* 카드, 이미지, 버튼 스타일 */
        .book-card { border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.12); }
        .book-image { max-width: 100%; height: auto; border-radius: 10px; }
        .book-info { white-space: pre-wrap; line-height: 1.6; }
        .avg-score a { cursor: pointer; text-decoration: none; }
        .comment-card { background-color: #f8f9fa; border-radius: 10px; padding: 12px; }
        .action-buttons { gap: 12px; flex-wrap: wrap; }

        /* 좌우 컬럼 세로 중앙 정렬 */
        .align-center { display: flex; flex-direction: column; justify-content: center; height: 100%; }

        /* 버튼 반응형 */
        @media (max-width: 768px) {
            .action-buttons { flex-direction: column; }
            .action-buttons .btn { width: 100%; }
        }

        /* 제목 중앙 강조 */
        h2.book-title { font-weight: 700; margin-bottom: 40px; color: #343a40; }

        /* 카드 내부 여백 */
        .card-padding { padding: 30px; }

        /* 별점 스타일 */
        .avg-score a:hover { text-decoration: underline; }

        /* 댓글 작성 영역 */
        .comment-form textarea { resize: none; }

        /* 버튼 공통 스타일 */
        .btn-custom { min-width: 130px; }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">

  
    <!-- 책 제목 -->
    <h2 class="text-center book-title">${view.title}</h2>

    <!-- 책 정보 카드 -->
    <div class="card book-card card-padding mb-5 bg-white">
        <div class="row g-4 align-items-center">

            <!-- 좌측: 저자, 가격, 평균별점 -->
            <div class="col-md-3 align-center text-center text-md-start">
                <h5 class="mb-3">저자: ${view.author}</h5>
                <h5 class="mb-3">가격: <span class="text-danger fw-bold">${view.price}원</span></h5>
                <div class="avg-score mt-2">
				    <strong>평균 별점:</strong>
				    <a href="#commentsSection" class="text-warning">
				        <c:forEach begin="1" end="${fn:substringBefore(reviewAvg.avgScore + 0.5, '.')}" var="i">★</c:forEach>
				        <c:forEach begin="${fn:substringBefore(reviewAvg.avgScore + 0.5, '.') + 1}" end="5" var="i">☆</c:forEach>
				        (<fmt:formatNumber value="${reviewAvg.avgScore}" pattern="#0.0" /> / ${reviewAvg.reviewCount}건)
				    </a>
				</div>
            </div>

            <!-- 중앙: 책 이미지 -->
            <div class="col-md-5 text-center">
                <img src="${view.pic}" alt="${view.title}" class="book-image img-fluid">
            </div>

            <!-- 우측: 책 소개 + 버튼 -->
            <div class="col-md-4 align-center">
                <h6 class="mb-3">책 소개:</h6>
                <div class="book-info mb-4">${view.info}</div>
                <div class="d-flex action-buttons">
                    <!-- 장바구니 -->
                    <form action="/bag/add" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="b_id" value="${view.b_id}">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn btn-outline-primary btn-custom">🛒 장바구니</button>
                    </form>

                    <!-- 구매 -->
                    <form action="/pay" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <input type="hidden" name="b_id" value="${view.b_id}">
                        <input type="hidden" name="title" value="${view.title}">
                        <input type="hidden" name="author" value="${view.author}">
                        <input type="hidden" name="price" value="${view.price}">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" class="btn btn-danger btn-custom">💳 구매하기</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <hr class="my-5">

    <!-- 댓글 작성 -->
    <div class="card card-padding mb-5 bg-white">
        <h5 class="mb-4">리뷰 작성</h5>
        <form action="/comments/add" method="post" class="comment-form">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <input type="hidden" name="b_id" value="${view.b_id}" />

            <div class="mb-3">
                <input type="text" name="writer" class="form-control" placeholder="작성자" required>
            </div>
            <div class="mb-3">
                <textarea name="content" class="form-control" rows="4" placeholder="리뷰 내용을 입력하세요" required></textarea>
            </div>
            <div class="mb-4">
                <label for="score" class="form-label"><strong>별점:</strong></label>
                <select name="score" id="score" class="form-select" required>
                    <option value="">선택하세요</option>
                    <option value="1">★☆☆☆☆</option>
                    <option value="2">★★☆☆☆</option>
                    <option value="3">★★★☆☆</option>
                    <option value="4">★★★★☆</option>
                    <option value="5">★★★★★</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary btn-custom">리뷰 등록</button>
        </form>
    </div>

    <!-- 댓글 목록 -->
    <div class="card card-padding mb-5 bg-white" id="commentsSection">
        <h5 class="mb-4">리뷰 목록</h5>
        <c:forEach var="c" items="${comments}">
            <div class="comment-card mb-3">
                <p class="mb-1"><strong>${c.writer}</strong> <small class="text-muted">(${c.regDate})</small></p>
                <p class="mb-0">
                    ${c.content}
                    <span class="text-warning">
                        <c:forEach begin="1" end="${c.score}" var="i">★</c:forEach>
                        <c:forEach begin="${c.score + 1}" end="5" var="i">☆</c:forEach>
                    </span>
                </p>
            </div>
        </c:forEach>
    </div>

</div>

</body>
</html>

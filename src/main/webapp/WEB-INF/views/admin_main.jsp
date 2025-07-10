<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="header.jsp" %>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>관리자 도서 관리</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous" />
  
  <!-- Custom CSS -->
  <style>
    body {
      font-family: "Segoe UI", "Malgun Gothic", sans-serif;
      background-color: #f8f9fa;
    }
    .navbar-brand {
      font-weight: bold;
      color: #0d6efd !important;
    }
    .card-title {
      font-size: 1.1rem;
      font-weight: bold;
    }
    .card-price {
      color: #dc3545;
    }
    .line-clamp-2 {
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
    }
    .admin-btn {
      font-size: 0.85rem;
    }
  </style>
</head>
<body>

  <!-- Main Content -->
  <main class="container py-5">

    <!-- 상단 제목 + 추가 버튼 -->
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="fw-semibold">📚 도서 관리 (관리자)</h2>
      <a href="/admin/addform" class="btn btn-primary">+ 도서 추가</a>
    </div>

    <!-- 도서 카드 -->
    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
      <c:forEach var="book" items="${books}">
        <div class="col">
          <div class="card h-100 border-0 shadow-sm">
            <a href="/view/detail?id=${book.b_id}">
              <img src="/images/book/${book.pic}" class="card-img-top" alt="책 표지" />
            </a>

            <div class="card-body">
              <h5 class="card-title">
                <a href="/view/detail?id=${book.b_id}" class="text-decoration-none text-dark">
                  ${book.title}
                </a>
              </h5>
              <p class="text-secondary mb-1">저자: ${book.author}</p>
              <p class="card-text line-clamp-2">${book.info}</p>
            </div>

            <div class="card-footer bg-white border-0 pt-0">
              <div class="d-flex justify-content-between align-items-center mb-2">
                <span class="fw-bold fs-5 card-price">₩ ${book.price}</span>
              </div>

              <!-- 관리자 수정/삭제 버튼 -->
				<div class="d-flex justify-content-between">
				  <a href="/admin/edit/${book.b_id}" class="btn btn-outline-primary btn-sm admin-btn">수정</a>
				  <a href="/admin/delete/${book.b_id}" class="btn btn-outline-danger btn-sm admin-btn" 
				     onclick="return confirm('정말 삭제하시겠습니까?');">
				    삭제
				  </a>
				</div>
            </div>

          </div>
        </div>
      </c:forEach>
    </div>
  </main>

  <%@ include file="footer.jsp" %>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>

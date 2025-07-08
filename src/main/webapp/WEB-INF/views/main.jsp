<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>교보문고 스타일 도서 쇼핑몰</title>

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
  </style>
</head>
<body>

  <!-- Navbar -->
  <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
    <div class="container">
      <a class="navbar-brand" href="#">MyBookShop</a>
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
        <ul class="navbar-nav">
          <li class="nav-item"><a class="nav-link active" href="#">홈</a></li>
          <li class="nav-item"><a class="nav-link" href="#">베스트셀러</a></li>
          <li class="nav-item"><a class="nav-link" href="#">신간</a></li>
          <li class="nav-item"><a class="nav-link" href="#">이벤트</a></li>
        </ul>
      </div>
    </div>
  </nav>

  <!-- Main Content -->
  <main class="container py-5">
    <h2 class="fw-semibold mb-4">📚 추천 도서</h2>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
      <c:forEach var="book" items="${books}">
        <div class="col">
          <div class="card h-100 border-0 shadow-sm">
            <img src="/images/book/${book.pic}" class="card-img-top" alt="책 표지" />
            <div class="card-body">
              <h5 class="card-title">${book.title}</h5>
              <p class="text-secondary mb-1">저자: ${book.author}</p>
              <p class="card-text line-clamp-2">${book.info}</p>
            </div>
            <div class="card-footer bg-white border-0 pt-0">
              <span class="fw-bold fs-5 card-price">
                ₩ ${book.price}
              </span>
            </div>
          </div>
        </div>
      </c:forEach>
    </div>
  </main>

  <!-- Footer -->
  <footer class="bg-white text-center py-4 border-top mt-auto">
    <div class="container small">
      ⓒ 2025 MyBookShop. All rights reserved.
    </div>
  </footer>

  <!-- Bootstrap Bundle JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>

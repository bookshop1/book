<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="header.jsp" %>
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>도서 쇼핑몰</title>

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
    
    .carousel-control-prev-icon,
	.carousel-control-next-icon {
	  filter: invert(1); /* 흰색 아이콘을 검정색으로 반전 */
	}
  </style>
  
</head>
<body>


  <main class="container py-5">
    
  <!-- ✅ 베스트셀러 (캐러셀) -->
  <h2 class="fw-semibold mb-4">👍 추천 도서</h2>
<h2 class="fw-semibold mb-3"></h2>

<div id="bestsellerCarousel" class="carousel slide mb-5 shadow-sm rounded overflow-hidden" 
     data-bs-ride="carousel" data-bs-interval="4000">
  <div class="carousel-inner bg-light p-4">

    <c:forEach var="book" items="${books}" begin="0" end="2" varStatus="status">
      <div class="carousel-item ${status.first ? 'active' : ''}">
        <div class="row align-items-center justify-content-center">
          
          <!-- 표지 이미지 크게 -->
          <div class="col-md-4 text-center">
            <a href="/view/detail?id=${book.b_id}">
              <img src="${book.pic}" alt="책 표지" 
                   class="rounded shadow" 
                   style="width:200px; height:280px; object-fit:cover;">
            </a>
          </div>

          <!-- 책 정보 크게 -->
          <div class="col-md-6">
            <h3 class="fw-bold mb-3">
              <a href="/view/detail?id=${book.b_id}" class="text-dark text-decoration-none">
                ${book.title}
              </a>
            </h3>
            <p class="text-secondary fs-5 mb-2">저자: ${book.author}</p>
            <span class="fw-bold fs-3 text-danger">₩ ${book.price}</span>
            <p class="mt-3 text-muted line-clamp-2">${book.info}</p>
          </div>

        </div>
      </div>
    </c:forEach>

  </div>

  <!-- 좌우 화살표 -->
  <button class="carousel-control-prev" type="button" data-bs-target="#bestsellerCarousel" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#bestsellerCarousel" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>



    <!-- 도서 목록 -->
    <h2 class="fw-semibold mb-4">📚 도서 목록</h2>

    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">

      <c:forEach var="book" items="${books}">
        <div class="col">
          <div class="card h-100 border-0 shadow-sm">
            
            <c:if test="${not empty book.pic}">
              <a href="/view/detail?id=${book.b_id}">
                <img src="${book.pic}" class="card-img-top" alt="책 표지" />
              </a>
            </c:if>

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
              <span class="fw-bold fs-5 card-price">₩ ${book.price}</span>
            </div>
          </div>
        </div>
      </c:forEach>

    </div>
  </main>

  <!-- Footer -->
  <%@ include file="footer.jsp" %>

  <!-- Bootstrap Bundle JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
</body>
</html>

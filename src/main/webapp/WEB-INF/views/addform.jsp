<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 추가</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>📚 도서 등록</h2>
    <form action="${pageContext.request.contextPath}/admin/add" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <div class="mb-3">
            <label for="num" class="form-label">도서 번호</label>
            <input type="text" class="form-control" id="num" name="num" required>
        </div>
        <div class="mb-3">
            <label for="pic" class="form-label">이미지 파일명</label>
            <input type="text" class="form-control" id="pic" name="pic" placeholder="예: book01.jpg">
        </div>
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="mb-3">
            <label for="author" class="form-label">저자</label>
            <input type="text" class="form-control" id="author" name="author" required>
        </div>
        <div class="mb-3">
            <label for="price" class="form-label">가격</label>
            <input type="number" class="form-control" id="price" name="price" required>
        </div>
        <div class="mb-3">
            <label for="info" class="form-label">도서 설명</label>
            <textarea class="form-control" id="info" name="info" rows="4" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">등록</button>
        <a href="${pageContext.request.contextPath}/admin/main" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>

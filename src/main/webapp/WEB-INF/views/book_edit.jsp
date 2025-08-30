<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="join.UserVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>도서 수정</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-5">
    <h2>📘 도서 정보 수정</h2>
    <form action="${pageContext.request.contextPath}/admin/edit" method="post">
        <!-- 수정할 도서의 ID는 숨김 필드로 보냄 -->
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
        <input type="hidden" name="b_id" value="${book.b_id}" />
        <div class="mb-3">
            <label for="pic" class="form-label">이미지 파일명</label>
            <input type="text" class="form-control" id="pic" name="pic" value="${book.pic}">
        </div>
        <div class="mb-3">
            <label for="title" class="form-label">제목</label>
            <input type="text" class="form-control" id="title" name="title" value="${book.title}" required>
        </div>
        <div class="mb-3">
            <label for="author" class="form-label">저자</label>
            <input type="text" class="form-control" id="author" name="author" value="${book.author}" required>
        </div>
        <div class="mb-3">
            <label for="category" class="form-label">카테고리</label>
            <select class="form-select" id="category" name="category" required>
                <option value=" ">카테고리 선택</option>
                <option value="essay" <c:if test="${book.category eq 'essay'}">selected</c:if>>에세이</option>
                <option value="novel" <c:if test="${book.category eq 'novel'}">selected</c:if>>소설</option>
                <option value="humanities" <c:if test="${book.category eq 'humanities'}">selected</c:if>>인문</option>
                <option value="health" <c:if test="${book.category eq 'health'}">selected</c:if>>건강</option>
                <option value="economy" <c:if test="${book.category eq 'economy'}">selected</c:if>>경제</option>
            </select>
        </div>
        <div class="mb-3">
            <label for="price" class="form-label">가격</label>
            <input type="number" class="form-control" id="price" name="price" value="${book.price}" required>
        </div>
        <div class="mb-3">
            <label for="info" class="form-label">도서 설명</label>
            <textarea class="form-control" id="info" name="info" rows="4" required>${book.info}</textarea>
        </div>
        <button type="submit" class="btn btn-primary">수정</button>
        <a href="${pageContext.request.contextPath}/admin/main" class="btn btn-secondary">취소</a>
    </form>
</div>
</body>
</html>

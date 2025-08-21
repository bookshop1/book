<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- [수정 1] 페이지 상단의 Java 코드(스크립틀릿) 전체 삭제! --%>
<!DOCTYPE html>
<html lang="ko">
<%-- header.jsp는 Spring Security Taglib을 사용하도록 수정했으므로 그대로 둡니다. --%>
<%@ include file="header.jsp" %>
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>관리자 도서 관리</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous" />
    <style>
        /* ... 기존 스타일 그대로 ... */
    </style>
</head>
<body>

    <main class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-semibold">📚 도서 관리 (관리자)</h2>
            <a href="/admin/addform" class="btn btn-primary">+ 도서 추가</a>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
            <c:forEach var="book" items="${books}">
                <div class="col">
                    <div class="card h-100 border-0 shadow-sm">
                        <%-- ... 카드 이미지, 제목 등은 기존과 동일 ... --%>
                        <div class="card-footer bg-white border-0 pt-0">
                            <%-- ... 가격 등은 기존과 동일 ... --%>

                            <div class="d-flex justify-content-between">
                                <a href="/admin/edit/${book.b_id}" class="btn btn-outline-primary btn-sm admin-btn">수정</a>
                                
                                <%-- [수정 2] '삭제' 링크를 form으로 변경 --%>
                                <form action="/admin/delete/${book.b_id}" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                    <button type="submit" class="btn btn-outline-danger btn-sm admin-btn">삭제</button>
                                </form>
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
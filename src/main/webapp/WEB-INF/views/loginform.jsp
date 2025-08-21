<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 | BookShop</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">

    <style>
        /* 기존과 유사한 배경 및 전체 레이아웃 설정 */
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(120deg, #e8f0fe 0%, #ffffff 100%);
            font-family: 'Noto Sans KR', sans-serif; /* 한국어 환경에 더 적합한 폰트로 변경 */
        }
        /* 카드(폼 컨테이너)에 약간의 애니메이션 효과 추가 */
        .card {
            animation: fadeIn 0.8s;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5 col-xl-4">
            
            <div class="card shadow-lg border-0 rounded-4 my-5">
                <div class="card-body p-4 p-sm-5">

                    <div class="text-center mb-4">
                        <a href="/main" class="text-decoration-none">
                            <h1 class="h2 fw-bold text-primary">
                                <i class="bi bi-book-half me-2"></i>BookShop
                            </h1>
                        </a>
                    </div>
                    
                    <h2 class="h4 text-center mb-4">로그인</h2>

                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger text-center py-2" role="alert">
                            아이디 또는 비밀번호가 잘못되었습니다.
                        </div>
                    </c:if>

                    <form action="/login" method="post" autocomplete="off">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <div class="input-group mb-3">
                            <span class="input-group-text"><i class="bi bi-person-fill"></i></span>
                            <div class="form-floating">
                                <input type="text" class="form-control" name="username" id="username" placeholder="아이디" required>
                                <label for="username">아이디</label>
                            </div>
                        </div>

                        <div class="input-group mb-4">
                             <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                            <div class="form-floating">
                                <input type="password" class="form-control" name="password" id="password" placeholder="비밀번호" required>
                                <label for="password">비밀번호</label>
                            </div>
                        </div>

                        <div class="d-grid">
                            <button type="submit" class="btn btn-primary btn-lg py-2">로그인</button>
                        </div>
                    </form>

                    <div class="text-center mt-4">
                        <small>아직 회원이 아니신가요? <a href="/join/joinform" class="fw-bold">회원가입</a></small>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
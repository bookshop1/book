package login;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomerLoginSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
                                        throws IOException, ServletException {

        // 권한 목록을 문자열로 변환
        List<String> roleNames = new ArrayList<>();
        authentication.getAuthorities().forEach(authority -> {
            roleNames.add(authority.getAuthority());
        });

        System.out.println("로그인 성공 - 권한: " + roleNames);

        // ROLE_USER만 체크
        if (roleNames.contains("ROLE_ADMIN")) {
            response.sendRedirect("/admin/main");
            return; // 리다이렉트 후에는 처리를 종료하는 것이 좋습니다.
        }

        if (roleNames.contains("ROLE_USER")) {
            response.sendRedirect("/main");
            return;
        }  
     // 로그인 페이지로 보내는 것보다, 메인 페이지나 에러 페이지로 보내는 것이 사용자 경험에 더 좋습니다.
        response.sendRedirect("/main"); // 예: 기본 페이지로 리다이렉트
    }
}

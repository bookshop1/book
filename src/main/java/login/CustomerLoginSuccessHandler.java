package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import join.UserVO;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class CustomerLoginSuccessHandler implements AuthenticationSuccessHandler {

    private final LoginMapper loginMapper;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication)
                                        throws IOException, ServletException {
        
        String username = authentication.getName();
        UserVO user = loginMapper.findById(username);
        HttpSession session = request.getSession();

        session.setAttribute("userId", user.getU_id());
        session.setAttribute("loggedInUser", user.getId());
        String role = user.getRole().replace("ROLE_", "");
        session.setAttribute("userRole", role);

        System.out.println("로그인 성공 - 회원번호: " + user.getU_id() 
                         + ", 아이디: " + user.getId() 
                         + ", 역할: " + role);
        
        

     // ✅ 역할(Role) 기반 리다이렉트 처리
        String redirectUrl = request.getHeader("Referer");
        if (role.equals("ADMIN")) {
            // 관리자일 경우
            response.sendRedirect(request.getContextPath() + "/admin/main");
        } else if (role.equals("USER")) {
            // 일반 사용자일 경우
            // 장바구니에서 로그인 후 돌아오는 경우 처리
            if (redirectUrl != null && redirectUrl.endsWith("/login/loginform")) {
                String prevUrl = (String) session.getAttribute("prevUrl");
                if (prevUrl != null && prevUrl.endsWith("/pay")) {
                    response.sendRedirect(request.getContextPath() + "/bag/login-success");
                    return;
                }
            }
            response.sendRedirect(request.getContextPath() + "/main");
        } else {
            // 기타 역할이 있을 경우 기본 페이지
            response.sendRedirect(request.getContextPath() + "/main");
        }
    }
}
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

        // ✅ 수정된 로직: 로그인 직전 페이지를 확인하여 장바구니로 리다이렉트할지 결정
        String redirectUrl = request.getHeader("Referer");
        if (redirectUrl != null && redirectUrl.endsWith("/login/loginform")) {
            // 로그인 폼으로 리다이렉트 되기 전 URL을 세션에서 가져옴
            String prevUrl = (String) session.getAttribute("prevUrl");
            // 이전 URL이 /pay 요청이었다면 장바구니 페이지로 리다이렉트
            if (prevUrl != null && prevUrl.endsWith("/pay")) {
                 response.sendRedirect(request.getContextPath() + "/bag/login-success");
            } else {
                 response.sendRedirect(request.getContextPath() + "/main");
            }
        } else {
            // 그 외의 경우 (예: 로그인 폼으로 직접 이동) 메인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/main");
        }
    }
}
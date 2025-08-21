package login;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import join.UserVO; // UserVO import
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
        
        // 1. 로그인한 사용자의 아이디(String)를 가져옵니다.
        String username = authentication.getName();
        
        // 2. 아이디를 이용해 DB에서 전체 사용자 정보(UserVO)를 다시 조회합니다.
        UserVO user = loginMapper.findById(username);

        // 3. 새로운 세션을 가져와 필요한 정보를 저장합니다.
        HttpSession session = request.getSession();
        session.setAttribute("userId", user.getU_id());       // 회원 번호
        session.setAttribute("loggedInUser", user.getId());   // 아이디
        String role = user.getRole().replace("ROLE_", "");
        session.setAttribute("userRole", role);   // "USER" 또는 "ADMIN"

        System.out.println("로그인 성공 - 회원번호: " + user.getU_id() 
                         + ", 아이디: " + user.getId() 
                         + ", 역할: " + role);

        // 4. 게스트 카트 처리
        Object guestCart = session.getAttribute("guestCart");
        if (guestCart != null) {
            response.sendRedirect(request.getContextPath() + "/bag/login-success");
            return;
        }

        // 5. 권한에 따라 리다이렉트
        if ("ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/main");
        } else {
            response.sendRedirect(request.getContextPath() + "/main");
        }
    }
}
package login;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import join.UserVO;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private LoginService service;

    // 로그인 폼 화면
    @GetMapping("/loginform")
    public String loginForm() {
        return "loginform"; // /WEB-INF/views/loginform.jsp
    }
    

    @PostMapping
    public String loginProcess(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            Model model,
            HttpSession session) {

        UserVO loginUser = service.getUser(username, password);

        if (loginUser != null) {
            // 로그인 성공 시 세션에 사용자 정보 저장
            session.setAttribute("loginUser", loginUser);
            session.setAttribute("userId", loginUser.getU_id());
            
        	if("ROLE_ADMIN".equals(loginUser.getRole())) {

            return "redirect:/admin/main"; // 로그인 성공 시 이동할 페이지
        	}else
        		return "redirect:/main";
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 잘못되었습니다.");
            return "loginform"; // 로그인 실패 시 재로그인 폼
        }
    }
    

 
    
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); // 모든 세션 정보 제거
        return "redirect:/login/loginform";
    }

}
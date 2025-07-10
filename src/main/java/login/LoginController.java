package login;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private LoginService service;

    // 로그인 화면 띄우기
    @GetMapping("/loginform")
    public String loginForm() {
        return "loginform"; // /WEB-INF/views/loginform.jsp
    }

    // 로그인 처리
    @PostMapping
    public String loginProcess(
            @RequestParam("username") String username,
            @RequestParam("password") String password,
            Model model,
            HttpSession session) {

        int result = service.login(username, password);

        if (result == 1) {
            session.setAttribute("loginId", username);
            return "redirect:/main";
        } else {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 잘못되었습니다.");
            return "loginform";
        }
    }
}

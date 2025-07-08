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
        return "loginform"; // login.jsp 또는 login.html (뷰 이름)
    }

    // 로그인 처리
    @PostMapping("/login")
    public String loginProcess(@RequestParam("id") String id,
            @RequestParam("password") String password,
            Model model,
            HttpSession session) {

    	int result = service.login(id, password);

    	if (result == 1) {
			// 로그인 성공 시 세션 저장 등 처리 후 리디렉트
			session.setAttribute("loginId", id);
			return "redirect:/home"; // 메인 페이지나 대시보드로
		} else {
			// 로그인 실패 시 다시 로그인 페이지로, 에러 메시지 전달
			model.addAttribute("errorMsg", "아이디 또는 비밀번호가 잘못되었습니다.");
			return "loginform"; // JSP 위치 (예: /WEB-INF/views/login/loginForm.jsp)
		}
	}
}
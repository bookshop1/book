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

    // �α��� ȭ�� ����
    @GetMapping("/loginform")
    public String loginForm() {
        return "loginform"; // login.jsp �Ǵ� login.html (�� �̸�)
    }

    // �α��� ó��
    @PostMapping("/login")
    public String loginProcess(@RequestParam("id") String id,
            @RequestParam("password") String password,
            Model model,
            HttpSession session) {

    	int result = service.login(id, password);

    	if (result == 1) {
			// �α��� ���� �� ���� ���� �� ó�� �� ����Ʈ
			session.setAttribute("loginId", id);
			return "redirect:/home"; // ���� �������� ��ú����
		} else {
			// �α��� ���� �� �ٽ� �α��� ��������, ���� �޽��� ����
			model.addAttribute("errorMsg", "���̵� �Ǵ� ��й�ȣ�� �߸��Ǿ����ϴ�.");
			return "loginform"; // JSP ��ġ (��: /WEB-INF/views/login/loginForm.jsp)
		}
	}
}
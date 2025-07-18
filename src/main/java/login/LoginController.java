package login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private LoginService service;

   
    @GetMapping("/loginform")
    public String loginForm() {
        return "loginform"; // /WEB-INF/views/loginform.jsp
    }


}
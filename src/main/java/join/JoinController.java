package join;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/join")
public class JoinController {

    @Autowired
    private JoinService joinService;

    @RequestMapping("/joinform")
    public String joinForm() {
        return "joinForm"; 
    }

    @RequestMapping("/register")
    public String register(UserVO user, Model model) {
        int result = joinService.register(user);
        model.addAttribute("msg", result > 0 ? "회원가입 성공!" : "회원가입 실패");
        return "joinResult"; 
    }
}

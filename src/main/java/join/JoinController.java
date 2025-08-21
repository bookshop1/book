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

    // GET 요청만 처리하도록 명시
    @GetMapping("/joinform")
    public String joinForm() {
        return "joinForm"; 
    }

    // POST 요청만 처리하도록 명시하고, URL을 더 명확하게 변경
    @PostMapping("/register")
    public String register(UserVO user, Model model) {
        int result = joinService.register(user);
        model.addAttribute("msg", result > 0 ? "회원가입 성공!" : "회원가입 실패");
        return "joinResult"; 
    }
}
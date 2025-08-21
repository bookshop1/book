package main;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    // http://localhost:8888/ 로 접속하면 이 메서드가 실행됩니다.
    @GetMapping("/")
    public String redirectToMain() {
        // "redirect:/main"은 사용자를 /main 경로로 다시 보내라는 뜻입니다.
        return "redirect:/main";
    }
}
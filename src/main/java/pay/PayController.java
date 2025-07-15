package pay;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import view.View;
import view.ViewService;


@Controller
public class PayController {
	
	ViewService service;
	
	@GetMapping("/pay")
	public String pay(Model model) {
		return "pay";
	}
}

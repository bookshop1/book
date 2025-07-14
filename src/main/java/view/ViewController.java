package view;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("view")
public class ViewController {
	
	@Autowired
	ViewService service;
	
	
	
	@GetMapping("/detail")
	public String detail(@RequestParam("id") int id, Model model) {
		View view = service.getDetail(id);
		model.addAttribute("view", view);
		
		return "detail";
		//접근 url http://localhost:8888/view/detail?id=3 이런식으로 하시면 됩니다.
	}
	
	

}
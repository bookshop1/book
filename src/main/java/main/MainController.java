package main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/main")
public class MainController {
	
	@Autowired
	MainService service;
	
	@GetMapping
	public String list(Model model) {
		List<Book> books = service.findAll();
		model.addAttribute("books", books);
		return "main";
	}
	
	@GetMapping("/detail")
	public String detail(@RequestParam("num") int num, Model model) {
		Book book = service.findBookById(num);
		
		model.addAttribute("book", book);
		return "detail";
	}

}

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
	public String list(@RequestParam(value = "keyword", required = false) String keyword, Model model) {
	    List<Book> books;
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        books = service.search(keyword);
	    } else {
	        books = service.findAll();
	    }
	    model.addAttribute("books", books);
	    return "main"; // main.jsp
	}
	
	@GetMapping("/detail")
	public String detail(@RequestParam("id") int id, Model model) {
		Book book = service.findBookById(id);
		
		model.addAttribute("book", book);
		return "detail";
	}

}

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
    public String list(@RequestParam(value = "keyword", required = false) String keyword,
                       @RequestParam(value = "category", required = false) String category,
                       Model model) {
        
        List<Book> books;
        
        if (category != null && !category.trim().isEmpty()) {
            // 移댄뀒怨좊━蹂� 議고쉶
            books = service.findByCategory(category);
            model.addAttribute("currentCategory", category);
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            // 寃��깋�뼱 議고쉶
            books = service.search(keyword);
        } else {
            // �쟾泥� 議고쉶
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

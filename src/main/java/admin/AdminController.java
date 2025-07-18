package admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("admin")
public class AdminController {
	
	@Autowired
	AdminService service;
	
	@GetMapping("/main")
	public String list(Model model) {
		List<Book> books = service.findAll();
		model.addAttribute("books", books);
		return "admin_main";
	}
	//추가
	@GetMapping("/addform")
	public String addform() {
		return "addform";
	}
	
	@PostMapping("/add")
	public String insertbook(Book book) {
		service.insertbook(book);
		return "redirect:/admin/main";
	}
	
	
	//수정
	@GetMapping("/edit/{b_id}")
	public String editForm(@PathVariable int b_id, Model model) {
	    Book book = service.findById(b_id);
	    model.addAttribute("book", book);
	    return "/book_edit";
	}
	
	@PostMapping("/edit")
	public String updateBook(Book book) {
	    service.updateBook(book);
	    return "redirect:/admin/main";
	}
	
	//삭제
	@GetMapping("/delete/{b_id}")
	public String delete(@PathVariable int b_id) {
	    service.deleteBook(b_id);
	    return "redirect:/admin/main";
	}

}

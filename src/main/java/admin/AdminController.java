package admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import main.Book;


@Controller
@RequestMapping("admin")
public class AdminController {
	
	@Autowired
	AdminService service;
	
	@GetMapping("/main")
    public String adminList(@RequestParam(value = "keyword", required = false) String keyword,
                            @RequestParam(value = "category", required = false) String category,
                            Model model) {
		
        List<AdminBook> books;
        
        // 카테고리 필터링이 요청된 경우
        if (category != null && !category.trim().isEmpty()) {
            books = service.findByCategory(category);
            model.addAttribute("currentCategory", category);
        // 키워드 검색이 요청된 경우
        } else if (keyword != null && !keyword.trim().isEmpty()) {
            books = service.search(keyword);
            model.addAttribute("currentKeyword", keyword);
        // 아무 조건이 없을 경우 모든 도서 조회
        } else {
            books = service.findAll();
        }
        
        model.addAttribute("books", books);
        return "admin_main"; // admin.jsp 뷰를 반환
    }
	
	@GetMapping("/addform")
	public String addform() {
		return "addform";
	}
	
	@PostMapping("/add")
	public String insertbook(AdminBook book) {
		service.insertbook(book);
		return "redirect:/admin/main";
	}
	
	@GetMapping("/edit/{b_id}")
	public String editForm(@PathVariable int b_id, Model model) {
	    AdminBook book = service.findById(b_id);
	    model.addAttribute("book", book);
	    return "/book_edit";
	}
	
	@PostMapping("/edit")
	public String updateBook(AdminBook book) {
	    service.updateBook(book);
	    return "redirect:/admin/main";
	}
	
	@PostMapping("/delete/{b_id}")
	public String delete(@PathVariable int b_id) {
	    service.deleteBook(b_id);
	    return "redirect:/admin/main";
	}

}

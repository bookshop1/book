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

import chart.ReviewAvgDTO;
import main.Book;
import main.MainService;
import view.Comment;
import view.CommentService;


@Controller
@RequestMapping("admin")
public class AdminController {
	
	@Autowired
	AdminService service;
	
	@Autowired
	MainService mainService;
	
	@Autowired
	CommentService commentService;

	
	@GetMapping("/main")
	public String list(@RequestParam(value = "keyword", required = false) String keyword,
			            @RequestParam(value = "category", required = false) String category,
			            Model model) {
		List<Book> books;

	    if (category != null && !category.trim().isEmpty()) {
	        // 카테고리별 조회
	        books = mainService.findByCategory(category);
	        model.addAttribute("currentCategory", category);
	    } else if (keyword != null && !keyword.trim().isEmpty()) {
	        // 키워드 검색
	        books = mainService.search(keyword);
	    } else {
	        // 전체 조회
	        books = mainService.findAll();
	    }

	    model.addAttribute("books", books);
	    return "admin_main";
	}
	//�߰�
	@GetMapping("/addform")
	public String addform() {
		return "addform";
	}
	
	@PostMapping("/add")
	public String insertbook(AdminBook book) {
		service.insertbook(book);
		return "redirect:/admin/main";
	}
	
	
	//����
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
	
	//����
	@PostMapping("/delete/{b_id}")
	public String delete(@PathVariable int b_id) {
	    service.deleteBook(b_id);
	    return "redirect:/admin/main";
	}
	
	@GetMapping("/detail")
	public String detail(@RequestParam("id") int id, Model model) {
	    // 도서 상세 정보
	    AdminBook book = service.findById(id);
	    model.addAttribute("book", book);

	    // 해당 도서의 댓글 목록
	    List<Comment> comments = commentService.getCommentsByBookId(id);
	    model.addAttribute("comments", comments);

	    // 해당 도서의 평균 별점과 리뷰 수
	    ReviewAvgDTO reviewAvg = commentService.getReviewAvgByBookId(id);
	    model.addAttribute("reviewAvg", reviewAvg);

	    return "admindetail";  // /WEB-INF/views/view/admindetail.jsp
	}


	
}
